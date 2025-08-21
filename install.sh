#!/bin/bash

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "    Installation de DiamondsSearch"
echo -e "========================================${NC}"
echo
echo "Ce script va installer et configurer DiamondsSearch"
echo "sur votre système."
echo
read -p "Appuyez sur Entrée pour continuer..."

echo
echo -e "${BLUE}========================================"
echo -e "Vérification des prérequis..."
echo -e "========================================${NC}"
echo

# Vérifier Node.js
echo -e "${BLUE}[1/4] Vérification de Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}[❌ ERREUR] Node.js n'est pas installé.${NC}"
    echo
    echo "Veuillez télécharger et installer Node.js depuis :"
    echo "https://nodejs.org/"
    echo
    echo "Choisissez la version LTS (recommandée)."
    echo "Après l'installation, redémarrez votre terminal."
    echo
    echo "Puis relancez ce script."
    echo
    exit 1
else
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}[✅ OK] Node.js est installé (version $NODE_VERSION)${NC}"
fi

# Vérifier Python
echo -e "${BLUE}[2/4] Vérification de Python...${NC}"
if ! command -v python3 &> /dev/null; then
    if ! command -v python &> /dev/null; then
        echo -e "${RED}[❌ ERREUR] Python n'est pas installé.${NC}"
        echo
        echo "Veuillez télécharger et installer Python depuis :"
        echo "https://www.python.org/downloads/"
        echo
        echo "Choisissez Python 3.8 ou supérieur."
        echo "Après l'installation, redémarrez votre terminal."
        echo
        echo "Puis relancez ce script."
        echo
        exit 1
    else
        PYTHON_VERSION=$(python --version)
        echo -e "${GREEN}[✅ OK] Python est installé (version $PYTHON_VERSION)${NC}"
    fi
else
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}[✅ OK] Python3 est installé (version $PYTHON_VERSION)${NC}"
fi

# Vérifier Ollama
echo -e "${BLUE}[3/4] Vérification d'Ollama...${NC}"
if ! command -v ollama &> /dev/null; then
    echo -e "${RED}[❌ ERREUR] Ollama n'est pas installé.${NC}"
    echo
    echo "Veuillez télécharger et installer Ollama depuis :"
    echo "https://ollama.ai/"
    echo
    echo "Choisissez la version pour votre système."
    echo "Après l'installation, redémarrez votre terminal."
    echo
    echo "Puis relancez ce script."
    echo
    exit 1
else
    OLLAMA_VERSION=$(ollama --version)
    echo -e "${GREEN}[✅ OK] Ollama est installé (version $OLLAMA_VERSION)${NC}"
fi

echo
echo -e "${GREEN}[4/4] Tous les prérequis sont installés !${NC}"
echo
echo -e "${BLUE}========================================"
echo -e "Installation des dépendances..."
echo -e "========================================${NC}"
echo

echo -e "${BLUE}[1/3] Installation des dépendances Node.js...${NC}"
echo "Cette étape peut prendre quelques minutes..."
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}[❌ ERREUR] Échec de l'installation des dépendances Node.js${NC}"
    echo
    echo "Vérifiez votre connexion internet et relancez le script."
    echo
    exit 1
else
    echo -e "${GREEN}[✅ OK] Dépendances Node.js installées avec succès${NC}"
fi

echo
echo -e "${BLUE}[2/3] Installation des dépendances Python...${NC}"
echo "Cette étape peut prendre quelques minutes..."
cd backend
pip3 install -r requirements.txt 2>/dev/null || pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo -e "${RED}[❌ ERREUR] Échec de l'installation des dépendances Python${NC}"
    echo
    echo "Vérifiez votre connexion internet et relancez le script."
    echo
    cd ..
    exit 1
else
    echo -e "${GREEN}[✅ OK] Dépendances Python installées avec succès${NC}"
fi
cd ..

echo
echo -e "${BLUE}[3/3] Téléchargement du modèle IA (Ollama)...${NC}"
echo "Cette étape peut prendre 10-15 minutes selon votre connexion..."
echo "Taille du modèle : environ 4 GB"
echo
ollama pull llama3:latest
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}[⚠️ ATTENTION] Échec du téléchargement du modèle Ollama${NC}"
    echo
    echo "Vous pourrez le télécharger manuellement plus tard avec :"
    echo "ollama pull llama3:latest"
    echo
    echo "L'application fonctionnera mais sans l'IA."
else
    echo -e "${GREEN}[✅ OK] Modèle IA téléchargé avec succès${NC}"
fi

echo
echo -e "${BLUE}========================================"
echo -e "🎉 Installation terminée avec succès !"
echo -e "========================================${NC}"
echo
echo "Votre bot DiamondsSearch est maintenant prêt !"
echo
echo -e "${GREEN}📋 Prochaines étapes :${NC}"
echo "1. Lancez l'application avec : npm start"
echo "2. Scannez le QR code WhatsApp"
echo "3. Configurez vos groupes"
echo "4. Testez avec une recherche de diamant"
echo
echo -e "${BLUE}📖 Consultez le guide d'installation pour plus de détails :${NC}"
echo "GUIDE_INSTALLATION_CLIENT.md"
echo 