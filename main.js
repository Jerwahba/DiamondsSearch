// Check if running directly with Node.js vs Electron
const isRunningWithElectron = process.versions && process.versions.electron;

if (!isRunningWithElectron) {
    console.log('This script is designed to be run with Electron, not Node.js directly.');
    console.log('Please use: npm start');
    process.exit(1);
}

const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const { startBot, stopBot, getGroups, addGroup, removeGroup } = require('./bot.js');

let mainWindow;

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 800,
        height: 600,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });

    mainWindow.loadFile('frontend/index.html');
    global.mainWindow = mainWindow;
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit();
    }
});

app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
        createWindow();
    }
});

// Gérer les événements de l'interface
ipcMain.on('start-bot', (event) => {
    const result = startBot();
    event.reply('bot-started', result);
});

ipcMain.on('stop-bot', (event) => {
    const result = stopBot();
    event.reply('bot-stopped', result);
});

// Gérer les événements pour les groupes
ipcMain.on('get-groups', (event) => {
    const groups = getGroups();
    event.reply('groups-list', groups);
});

ipcMain.on('add-group', (event, groupName) => {
    const result = addGroup(groupName);
    event.reply('group-added', result);
    // Envoyer la liste mise à jour
    event.reply('groups-list', getGroups());
});

ipcMain.on('remove-group', (event, groupName) => {
    const result = removeGroup(groupName);
    event.reply('group-removed', result);
    // Envoyer la liste mise à jour
    event.reply('groups-list', getGroups());
});
