const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode-terminal');
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');
const { formatResults } = require('./format-results.js');

// Détection du chemin base en dev/production (asar)
function getAppBasePath() {
    try {
        if (typeof process.resourcesPath === 'string' && __dirname.includes('app.asar')) {
            return path.join(process.resourcesPath, 'app.asar.unpacked');
        }
    } catch (_) { /* ignore */ }
    return __dirname;
}

// Chemin du fichier pour sauvegarder les groupes (en production, écrire dans userData)
function getGroupsFilePath() {
    const relative = path.join('backend', 'data', 'groups.json');
    if (__dirname.includes('app.asar')) {
        try {
            const { app } = require('electron');
            const userDataDir = app.getPath('userData');
            const fullPath = path.join(userDataDir, relative);
            const dirPath = path.dirname(fullPath);
            if (!fs.existsSync(dirPath)) {
                fs.mkdirSync(dirPath, { recursive: true });
            }
            return fullPath;
        } catch (_) { /* fallback below */ }
    }
    return path.join(getAppBasePath(), relative);
}

const GROUPS_FILE_PATH = getGroupsFilePath();

// Fonction pour charger les groupes depuis le fichier
function loadGroups() {
    try {
        if (fs.existsSync(GROUPS_FILE_PATH)) {
            const data = fs.readFileSync(GROUPS_FILE_PATH, 'utf8');
            return new Set(JSON.parse(data));
        }
    } catch (error) {
        console.error('Erreur lors du chargement des groupes:', error);
    }
    // Valeurs par défaut si le fichier n'existe pas ou en cas d'erreur
    return new Set(['Test bot']);
}

// Fonction pour sauvegarder les groupes dans le fichier
function saveGroups() {
    try {
        const groupsArray = Array.from(NOM_DES_GROUPE);
        fs.writeFileSync(GROUPS_FILE_PATH, JSON.stringify(groupsArray), 'utf8');
    } catch (error) {
        console.error('Erreur lors de la sauvegarde des groupes:', error);
    }
}

// Nom du groupe à écouter
const NOM_DES_GROUPE = loadGroups();

let client = null;

// Gestion globale des promesses non gérées pour éviter l'arrêt du processus
process.on('unhandledRejection', (error) => {
    console.error('Unhandled promise rejection:', error);
});

// Tente de trouver le chemin d'un navigateur Chromium installé (Chrome/Edge)
function resolveBrowserExecutablePath() {
    try {
        if (process.platform === 'win32') {
            const programFiles = process.env['PROGRAMFILES'] || 'C:/Program Files';
            const programFilesX86 = process.env['PROGRAMFILES(X86)'] || 'C:/Program Files (x86)';
            const candidates = [
                path.join(programFiles, 'Google', 'Chrome', 'Application', 'chrome.exe'),
                path.join(programFilesX86, 'Google', 'Chrome', 'Application', 'chrome.exe'),
                path.join(programFiles, 'Microsoft', 'Edge', 'Application', 'msedge.exe'),
                path.join(programFilesX86, 'Microsoft', 'Edge', 'Application', 'msedge.exe')
            ];
            for (const candidate of candidates) {
                if (fs.existsSync(candidate)) return candidate;
            }
        } else if (process.platform === 'darwin') {
            const candidates = [
                '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
                '/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge'
            ];
            for (const candidate of candidates) {
                if (fs.existsSync(candidate)) return candidate;
            }
        } else {
            const candidates = [
                '/usr/bin/google-chrome',
                '/usr/bin/google-chrome-stable',
                '/usr/bin/chromium-browser',
                '/usr/bin/chromium',
                '/snap/bin/chromium',
                '/usr/bin/microsoft-edge'
            ];
            for (const candidate of candidates) {
                if (fs.existsSync(candidate)) return candidate;
            }
        }
    } catch (e) {
        console.warn('Erreur lors de la détection du navigateur Chromium:', e);
    }
    return null;
}

// Vérifier si une commande est disponible dans le PATH
function isCommandAvailable(commandName) {
    try {
        const { spawnSync } = require('child_process');
        const checker = process.platform === 'win32' ? 'where' : 'which';
        const result = spawnSync(checker, [commandName], { stdio: 'ignore' });
        return result.status === 0;
    } catch (_) {
        return false;
    }
}

// Fonction pour obtenir la liste des groupes
function getGroups() {
    return Array.from(NOM_DES_GROUPE);
}

// Fonction pour ajouter un groupe
function addGroup(groupName) {
    if (groupName && groupName.trim() !== '') {
        NOM_DES_GROUPE.add(groupName.trim());
        saveGroups(); // Sauvegarder les changements
        return true;
    }
    return false;
}

// Fonction pour supprimer un groupe
function removeGroup(groupName) {
    const result = NOM_DES_GROUPE.delete(groupName);
    if (result) {
        saveGroups(); // Sauvegarder les changements
    }
    return result;
}

function startBot() {
    if (client) {
        return; // Le bot est déjà démarré
    }

    const executablePath = resolveBrowserExecutablePath();

    client = new Client({
        authStrategy: new LocalAuth(),
        // Réduit les problèmes de lancement Chromium dans des environnements sandboxés
        puppeteer: {
            headless: true,
            executablePath: executablePath || undefined,
            args: [
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-dev-shm-usage',
                '--disable-gpu',
                '--no-zygote',
                '--disable-software-rasterizer',
                '--disable-features=site-per-process'
            ],
            timeout: 0
        },
        qrMaxRetries: 12,
        takeoverOnConflict: true,
        takeoverTimeoutMs: 0
    });

    client.on('qr', qr => {
        // Afficher le QR code dans le terminal
        qrcode.generate(qr, {small: true});

        // Afficher un lien direct pour scanner le QR code
        const qrCodeUrl = 'https://api.qrserver.com/v1/create-qr-code/?data=' + encodeURIComponent(qr);
        console.log('Scanne ce QR ici : ' + qrCodeUrl);
        console.log('Ou utilise ce lien direct dans WhatsApp: https://wa.me/qr/' + encodeURIComponent(qr));

        // Émettre un événement pour afficher le QR code dans l'interface
        if (global.mainWindow) {
            global.mainWindow.webContents.send('qr-code', qr);
        }
    });

    client.on('ready', () => {
        console.log('Client is ready!');
        if (global.mainWindow) {
            global.mainWindow.webContents.send('bot-ready');
        }
    });

    client.on('loading_screen', (percent, message) => {
        console.log('Chargement WhatsApp:', percent, message || '');
    });

    client.on('auth_failure', (msg) => {
        console.error('Echec d\'authentification WhatsApp:', msg);
        if (global.mainWindow) {
            global.mainWindow.webContents.send('qr-code-error', 'Echec d\'authentification. Veuillez relancer et rescanner le QR.');
        }
    });

    client.on('disconnected', (reason) => {
        console.error('Client WhatsApp déconnecté:', reason);
        if (global.mainWindow) {
            global.mainWindow.webContents.send('qr-code-error', 'Déconnecté: ' + reason);
        }
    });

    client.on('message', async message => {
        const chat = await message.getChat();

        // Vérifie que c'est un message de groupe et que le nom correspond
        if (chat.isGroup && NOM_DES_GROUPE.has(chat.name)) {
            // Get sender's contact info to message them directly
            const contact = await message.getContact();
            const senderId = contact.id._serialized;

            // Résolution robuste de l'exécutable Python/back_main
            const basePath = getAppBasePath();
            const backendDir = path.join(basePath, 'backend');
            const backMainExe = path.join(backendDir, 'back_main.exe');
            const backMainPy = path.join(backendDir, 'back_main.py');

            /**
             * Stratégie d'exécution:
             * 1) Si back_main.exe existe => exécuter directement (aucun Python requis)
             * 2) Sinon, essayer venv local .venv/python
             * 3) Sinon, utiliser lanceurs système (py|python|python3)
             */
            let child;
            if (fs.existsSync(backMainExe)) {
                child = spawn(backMainExe, [message.body], { cwd: backendDir, windowsHide: true });
            } else {
                const venvPython = process.platform === 'win32'
                    ? path.join(basePath, '.venv', 'Scripts', 'python.exe')
                    : path.join(basePath, '.venv', 'bin', 'python');

                const candidates = [];
                if (fs.existsSync(venvPython)) {
                    candidates.push(venvPython);
                }
                if (process.platform === 'win32') {
                    candidates.push('py', 'python', 'python3');
                } else {
                    candidates.push('python3', 'python');
                }

                // Essayer les candidats jusqu'à succès
                let started = false;
                for (const cmd of candidates) {
                    try {
                        child = spawn(cmd, [backMainPy, message.body], { cwd: backendDir, windowsHide: true });
                        started = true;
                        break;
                    } catch (e) {
                        console.warn('Echec lancement avec', cmd, e);
                    }
                }

                if (!started) {
                    console.error('Impossible de trouver Python pour exécuter back_main.py');
                    message.reply('Erreur: Python introuvable sur cette machine et aucun exécutable packagé trouvé.');
                    return;
                }
            }

            const pythonProcess = child;

            let pythonOutput = '';
            pythonProcess.stdout.on('data', (data) => {
                pythonOutput += data.toString();
            });

            let errorOutput = '';
            pythonProcess.stderr.on('data', (data) => {
                errorOutput += data.toString();
            });

            pythonProcess.on('error', (err) => {
                console.error('Erreur lors du démarrage du processus Python:', err);
            });

            pythonProcess.on('close', (code) => {
                if (code === 0) {
                    try {
                        const pythonData = JSON.parse(pythonOutput);

                        if (pythonData && pythonData.results) {
                            console.log('Filtres extraits:', pythonData.filters);
                            console.log('Résultats de la recherche:', pythonData.results);
                            console.log('Type de filters:', typeof pythonData.filters, Array.isArray(pythonData.filters));
                            console.log('Multiple requests:', pythonData.multiple_requests);
                            
                            // Check if this is a multiple requests response
                            if (pythonData.multiple_requests) {
                                console.log('Multiple requests detected:', pythonData.total_requests, 'requests');
                            }
                            
                            // Formatter et envoyer la réponse
                            const replyMessage = formatResults(pythonData.filters, pythonData.results);
                            
                            // Send the message directly to the user who made the request
                            if (senderId) {
                                client.sendMessage(senderId, replyMessage);
                                console.log(`Réponse envoyée en privé à ${contact.pushname || senderId}`);
                            } else {
                                // Fallback to replying in group if sender can't be identified
                                message.reply(replyMessage);
                                console.log('Impossible d\'identifier l\'expéditeur, réponse envoyée dans le groupe.');
                            }

                        } else if (pythonData && Object.keys(pythonData).length === 0) {
                            // Ne rien faire si l'IA n'a extrait aucun filtre (message non pertinent)
                            console.log("Aucun filtre extrait, le message n'était pas une demande de recherche.");
                        }

                    } catch (e) {
                        console.error('Erreur lors du parsing de la réponse JSON du script Python:', e);
                        console.error('Réponse brute:', pythonOutput);
                    }
                } else {
                    console.error(`Erreur d'exécution du script Python (code: ${code})`);
                    console.error(errorOutput);
                    // Donner un message clair à l'utilisateur final
                    let hint = '';
                    if (errorOutput && /No python/i.test(errorOutput)) {
                        hint = '\nAstuce: Installez Python ou utilisez l\'exécutable packagé inclus.';
                    }
                    if (global.mainWindow) {
                        global.mainWindow.webContents.send('python-error', `Erreur d'exécution du script (code ${code}).${hint}`);
                    }
                }
            });
        }
    });

    client.initialize();
    return true;
}

function stopBot() {
    if (client) {
        client.destroy();
        client = null;
        return true;
    }
    return false;
}

module.exports = { startBot, stopBot, getGroups, addGroup, removeGroup };
