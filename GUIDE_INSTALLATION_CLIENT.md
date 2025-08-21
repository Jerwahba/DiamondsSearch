# 📋 Guide d'Installation - DiamondsSearch Bot WhatsApp

## 🎯 Vue d'ensemble

DiamondsSearch est un bot WhatsApp intelligent qui utilise l'Intelligence Artificielle pour analyser les demandes de diamants et effectuer des recherches automatiques dans une base de données complète.

### Fonctionnalités principales
- 🤖 **IA intégrée** : Analyse intelligente des demandes de diamants
- 📱 **Interface WhatsApp** : Intégration native avec WhatsApp
- 🖥️ **Interface graphique** : Application desktop intuitive
- 🔍 **Recherche avancée** : Support de multiples critères (poids, couleur, clarté, etc.)
- 📊 **Base de données** : Mise à jour automatique toutes les 5 minutes
- 🔗 **Liens DDP** : Inclusion automatique des liens internet des pierres

---

## ⚙️ Prérequis Système

### Système d'exploitation supporté
- ✅ **Windows 10/11** (64-bit)
- ✅ **macOS 10.15+** (Intel/Apple Silicon)
- ✅ **Linux** (Ubuntu 18.04+, CentOS 7+)

### Configuration minimale requise
- **RAM** : 4 GB minimum (8 GB recommandé)
- **Espace disque** : 2 GB libre
- **Processeur** : Intel i3 ou équivalent AMD
- **Connexion internet** : Requise pour WhatsApp et mise à jour des données

---

## 📥 Installation Automatique (Recommandée)

### Windows
1. **Téléchargez** le dossier complet du projet
2. **Extrayez** le dossier dans un emplacement de votre choix (ex: `C:\DiamondsSearch`)
3. **Double-cliquez** sur `install.bat`
4. **Suivez** les instructions à l'écran
5. **Attendez** la fin de l'installation

### macOS/Linux
1. **Téléchargez** le dossier complet du projet
2. **Extrayez** le dossier dans un emplacement de votre choix
3. **Ouvrez** un terminal dans le dossier
4. **Exécutez** : `chmod +x install.sh && ./install.sh`
5. **Suivez** les instructions à l'écran

---

## 🔧 Installation Manuelle (Si l'automatique échoue)

### Étape 1 : Installer Node.js
1. Allez sur [https://nodejs.org/](https://nodejs.org/)
2. Téléchargez la version **LTS** (recommandée)
3. Installez en suivant l'assistant
4. **Vérifiez** : Ouvrez un terminal et tapez `node --version`

### Étape 2 : Installer Python
1. Allez sur [https://www.python.org/downloads/](https://www.python.org/downloads/)
2. Téléchargez Python **3.8 ou supérieur**
3. **IMPORTANT** : Cochez "Add Python to PATH" lors de l'installation
4. **Vérifiez** : Ouvrez un terminal et tapez `python --version`

### Étape 3 : Installer Ollama
1. Allez sur [https://ollama.ai/](https://ollama.ai/)
2. Téléchargez la version pour votre système
3. Installez en suivant l'assistant
4. **Vérifiez** : Ouvrez un terminal et tapez `ollama --version`

### Étape 4 : Installer les dépendances du projet
1. **Ouvrez** un terminal dans le dossier du projet
2. **Installez les dépendances Node.js** :
   ```bash
   npm install
   ```
3. **Installez les dépendances Python** :
   ```bash
   cd backend
   pip install -r requirements.txt
   cd ..
   ```
4. **Téléchargez le modèle IA** :
   ```bash
   ollama pull llama3:latest
   ```

---

## 🚀 Lancement de l'Application

### Méthode 1 : Interface graphique
1. **Double-cliquez** sur `DiamondsSearch.exe` (Windows)
2. Ou **double-cliquez** sur `DiamondsSearch.app` (macOS)
3. Ou **exécutez** `./DiamondsSearch` (Linux)

### Méthode 2 : Ligne de commande
1. **Ouvrez** un terminal dans le dossier du projet
2. **Exécutez** :
   ```bash
   npm start
   ```

---

## 📱 Configuration Initiale

### Première connexion WhatsApp
1. **Lancez** l'application
2. **Cliquez** sur "Démarrer" dans l'interface
3. **Scannez** le QR code avec votre téléphone :
   - Ouvrez WhatsApp sur votre téléphone
   - Allez dans Paramètres > WhatsApp Web
   - Scannez le QR code affiché à l'écran
4. **Attendez** la confirmation de connexion

### Configuration des groupes
1. **Ajoutez** les noms des groupes WhatsApp à surveiller
2. **Séparez** plusieurs groupes par des virgules
3. **Cliquez** sur "Sauvegarder"

---

## 🧪 Test de l'Application

### Test simple
1. **Envoyez** ce message dans un groupe configuré :
   ```
   Je cherche un diamant de 2 carats, couleur D, clarté VS1
   ```
2. **Vérifiez** que vous recevez une réponse privée avec des résultats

### Test de demande courte
1. **Envoyez** ce message :
   ```
   F round GIA
   ```
2. **Vérifiez** que le bot comprend et répond correctement

### Test de demande multiple
1. **Envoyez** ce message :
   ```
   Je cherche un diamant de 2 carats ET un diamant de 3 carats
   ```
2. **Vérifiez** que le bot traite les deux demandes séparément

---

## 🔍 Critères de Recherche Supportés

### Formes de diamants
- **Round** (rond)
- **Princess** (princesse)
- **Cushion** (coussin)
- **Oval** (ovale)
- **Emerald** (émeraude)
- **Pear** (poire)
- **Marquise** (marquise)
- **Asscher** (asscher)
- **Radiant** (radiant)
- **Heart** (cœur)

### Caractéristiques techniques
- **Poids** : 0.1 à 30 carats
- **Couleur** : D, E, F, G, H, I, J, K, L, M
- **Clarté** : IF, VVS1, VVS2, VS1, VS2, SI1, SI2
- **Laboratoire** : GIA, IGI, HRD
- **Taille** : EX, VG, G
- **Prix** : prix total ou prix par carat
- **Localisation** : Hong Kong, New York, etc.

### Demandes courtes acceptées
- `"F round GIA"` → couleur F, forme ronde, certificat GIA
- `"VS1 2 carats"` → clarté VS1, poids 2 carats
- `"round D color"` → forme ronde, couleur D

---

## 🛠️ Dépannage

### Problème : "Node.js not found"
**Solution** :
1. Réinstallez Node.js depuis [https://nodejs.org/](https://nodejs.org/)
2. Redémarrez votre ordinateur
3. Vérifiez avec `node --version`

### Problème : "Python not found"
**Solution** :
1. Réinstallez Python depuis [https://www.python.org/downloads/](https://www.python.org/downloads/)
2. **Cochez** "Add Python to PATH" lors de l'installation
3. Redémarrez votre ordinateur
4. Vérifiez avec `python --version`

### Problème : "Ollama not found"
**Solution** :
1. Réinstallez Ollama depuis [https://ollama.ai/](https://ollama.ai/)
2. Redémarrez votre ordinateur
3. Vérifiez avec `ollama --version`

### Problème : Erreur de connexion WhatsApp
**Solutions** :
1. **Déconnectez** WhatsApp Web de tous les autres appareils
2. **Vérifiez** votre connexion internet
3. **Redémarrez** l'application
4. **Rescannez** le QR code

### Problème : L'application ne démarre pas
**Solutions** :
1. **Vérifiez** que tous les prérequis sont installés
2. **Exécutez** le script d'installation à nouveau
3. **Vérifiez** les logs dans la console
4. **Contactez** le support technique

---

## 📞 Support Technique

### Informations de contact
- **Email** : [Votre email]
- **Téléphone** : [Votre numéro]
- **Horaires** : [Vos horaires de support]

### Informations à fournir en cas de problème
1. **Système d'exploitation** et version
2. **Version** de Node.js (`node --version`)
3. **Version** de Python (`python --version`)
4. **Version** d'Ollama (`ollama --version`)
5. **Message d'erreur** exact
6. **Capture d'écran** du problème

---

## 🔄 Mise à jour

### Mise à jour automatique
L'application se met à jour automatiquement lors du lancement.

### Mise à jour manuelle
1. **Téléchargez** la nouvelle version
2. **Remplacez** les fichiers existants
3. **Relancez** l'application

---

## 📋 Checklist d'Installation

- [ ] Node.js installé et vérifié
- [ ] Python installé et vérifié
- [ ] Ollama installé et vérifié
- [ ] Dépendances installées
- [ ] Modèle IA téléchargé
- [ ] Application lancée avec succès
- [ ] WhatsApp connecté
- [ ] Groupes configurés
- [ ] Test de recherche effectué
- [ ] Réponse reçue avec succès

---

## 🎉 Félicitations !

Votre bot DiamondsSearch est maintenant opérationnel ! 

**Prochaines étapes** :
1. **Testez** avec différents types de demandes
2. **Configurez** les groupes selon vos besoins
3. **Formez** vos utilisateurs aux bonnes pratiques
4. **Surveillez** les performances et les retours

**Bonne utilisation !** 🚀 