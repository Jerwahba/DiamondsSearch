# DiamondsSearch - Bot WhatsApp de Recherche de Diamants

Un bot WhatsApp intelligent qui utilise l'IA pour extraire les critères de recherche de diamants depuis les messages et effectuer des recherches dans une base de données de diamants.

## 🚀 Installation Rapide

### Prérequis
- **Node.js** (version 16 ou supérieure) - [Télécharger ici](https://nodejs.org/)
- **Python** (version 3.8 ou supérieure) - [Télécharger ici](https://www.python.org/downloads/)
- **Ollama** - [Télécharger ici](https://ollama.ai/)

### Étapes d'installation

1. **Cloner ou télécharger le projet**
   ```bash
   git clone [URL_DU_REPO]
   cd DiamondsSearch
   ```

2. **Installer les dépendances Node.js**
   ```bash
   npm install
   ```

3. **Installer les dépendances Python**
   ```bash
   cd backend
   pip install -r requirements.txt
   cd ..
   ```

4. **Installer et configurer Ollama**
   ```bash
   # Télécharger et installer Ollama depuis https://ollama.ai/
   # Puis télécharger le modèle Llama3
   ollama pull llama3:latest
   ```

5. **Lancer l'application**
   ```bash
   npm start
   ```

## 📱 Utilisation

1. **Démarrer le bot** : Cliquez sur "Démarrer" dans l'interface
2. **Scanner le QR code** : Utilisez WhatsApp sur votre téléphone pour scanner le QR code affiché
3. **Configurer les groupes** : Ajoutez les noms des groupes WhatsApp que le bot doit surveiller
4. **Tester** : Envoyez un message dans un groupe configuré avec des critères de diamant (ex: "Je cherche un diamant de 2 carats, couleur D, clarté VS1")

## 🔧 Configuration

### Groupes WhatsApp
- Le bot surveille uniquement les groupes ajoutés dans l'interface
- Les réponses sont envoyées en privé à l'utilisateur qui fait la demande
- Ajoutez/supprimez des groupes via l'interface graphique

### Critères de recherche supportés
- **Forme** : round, princess, cushion, oval, emerald, pear, marquise, asscher, radiant, heart
- **Poids** : en carats (ex: 2, 2.5, entre 1 et 3)
- **Couleur** : D, E, F, G, H, I, J, K, L, M
- **Clarté** : IF, VVS1, VVS2, VS1, VS2, SI1, SI2
- **Laboratoire** : GIA, IGI, HRD
- **Taille** : EX, VG, G
- **Prix** : prix total ou prix par carat
- **Localisation** : Hong Kong, New York, etc.
- **DDP** : lien internet de la pierre (URL de la page de détail du diamant)

### Demandes courtes et concises
Le bot reconnaît également les demandes très courtes et concises :

**Exemples de demandes courtes :**
- "F round GIA" → couleur F, forme ronde, certificat GIA
- "VS1 2 carats" → clarté VS1, poids 2 carats
- "round D color" → forme ronde, couleur D
- "GIA princess" → certificat GIA, forme princesse
- "2 carats VS2" → poids 2 carats, clarté VS2
- "F color round" → couleur F, forme ronde

Le bot utilise une combinaison d'IA et de reconnaissance de motifs pour traiter ces demandes courtes efficacement.

### Recherches multiples de diamants
Le bot peut maintenant détecter et traiter automatiquement les demandes de plusieurs diamants dans un seul message :

**Exemples de demandes multiples :**
- "Je cherche un diamant de 2 carats ET un diamant de 3 carats"
- "Je veux un diamant rond de 1.5 carats et un diamant princesse de 2 carats"
- "Cherchez-moi un diamant VS1 et aussi un diamant SI1"
- "Je cherche 2 diamants : un de 2 carats et un de 3 carats"

**Fonctionnement :**
- Le bot détecte automatiquement les demandes multiples
- Chaque demande est traitée séparément avec ses propres critères
- Les résultats sont organisés par demande dans la réponse
- Chaque diamant trouvé est associé à sa demande d'origine

## 🛠️ Dépannage

### Problèmes courants

**Erreur "Ollama not found"**
```bash
# Vérifier qu'Ollama est installé et en cours d'exécution
ollama list
```

**Erreur "Python not found"**
```bash
# Vérifier l'installation de Python
python --version
# ou
python3 --version
```

**Erreur "Node modules not found"**
```bash
# Réinstaller les dépendances
rm -rf node_modules package-lock.json
npm install
```

**Problème de connexion WhatsApp**
- Assurez-vous que WhatsApp Web n'est pas connecté sur d'autres appareils
- Vérifiez votre connexion internet
- Redémarrez le bot si nécessaire

## 📁 Structure du projet

```
DiamondsSearch/
├── backend/
│   ├── back_main.py          # Script principal Python
│   ├── requirements.txt      # Dépendances Python
│   └── data/                 # Données de configuration
├── frontend/
│   └── index.html           # Interface utilisateur
├── main.js                  # Application Electron
├── bot.js                   # Gestionnaire WhatsApp
├── format-results.js        # Formatage des résultats
└── package.json            # Configuration Node.js
```

## 🔍 Base de données

Le système télécharge automatiquement la base de données de diamants depuis une source externe et :
- **Lit toutes les feuilles** du fichier Excel (pas seulement la première)
- **Combine les données** de toutes les feuilles en une seule base de données
- **Valide automatiquement** que chaque feuille contient des données de diamants
- **Affiche des statistiques** détaillées sur le chargement (nombre de diamants, feuilles traitées)
- **Met à jour automatiquement** la base de données toutes les 5 minutes

## 🔒 Sécurité

- Le bot utilise l'authentification locale WhatsApp Web
- Les données de session sont stockées localement
- Aucune donnée personnelle n'est transmise à des tiers

## 📞 Support

En cas de problème :
1. Vérifiez que tous les prérequis sont installés
2. Consultez la section dépannage ci-dessus
3. Vérifiez les logs dans la console de l'application

## 📝 Licence

Ce projet est destiné à un usage personnel et éducatif.