#!/bin/bash

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "    Lancement de DiamondsSearch"
echo -e "========================================${NC}"
echo

# Vérifier que Node.js est installé
if ! command -v node &> /dev/null; then
    echo -e "${RED}[❌ ERREUR] Node.js n'est pas installé.${NC}"
    echo "Veuillez exécuter install.sh d'abord."
    exit 1
fi

# Vérifier que les dépendances sont installées
if [ ! -d "node_modules" ]; then
    echo -e "${RED}[❌ ERREUR] Les dépendances ne sont pas installées.${NC}"
    echo "Veuillez exécuter install.sh d'abord."
    exit 1
fi

# Vérifier que Python est installé
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo -e "${RED}[❌ ERREUR] Python n'est pas installé.${NC}"
    echo "Veuillez exécuter install.sh d'abord."
    exit 1
fi

# Vérifier que Ollama est installé
if ! command -v ollama &> /dev/null; then
    echo -e "${YELLOW}[⚠️ ATTENTION] Ollama n'est pas installé.${NC}"
    echo "L'IA ne fonctionnera pas, mais l'application peut démarrer."
    echo
    read -p "Voulez-vous continuer ? (o/n) : " choice
    if [[ ! "$choice" =~ ^[Oo]$ ]]; then
        exit 1
    fi
fi

echo -e "${GREEN}[✅ OK] Tous les prérequis sont vérifiés.${NC}"
echo
echo "Lancement de DiamondsSearch..."
echo

npm start

if [ $? -ne 0 ]; then
    echo
    echo -e "${RED}[❌ ERREUR] L'application n'a pas pu démarrer.${NC}"
    echo "Vérifiez les logs ci-dessus pour plus de détails."
    echo
fi 