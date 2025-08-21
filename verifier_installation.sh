#!/bin/bash

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "    Vérification de l'Installation"
echo -e "========================================${NC}"
echo

ERREURS=0
AVERTISSEMENTS=0

echo -e "${BLUE}[1/6] Vérification de Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}[❌ ERREUR] Node.js n'est pas installé${NC}"
    ((ERREURS++))
else
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}[✅ OK] Node.js version $NODE_VERSION${NC}"
fi

echo
echo -e "${BLUE}[2/6] Vérification de Python...${NC}"
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo -e "${RED}[❌ ERREUR] Python n'est pas installé${NC}"
    ((ERREURS++))
else
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version)
    else
        PYTHON_VERSION=$(python --version)
    fi
    echo -e "${GREEN}[✅ OK] Python version $PYTHON_VERSION${NC}"
fi

echo
echo -e "${BLUE}[3/6] Vérification d'Ollama...${NC}"
if ! command -v ollama &> /dev/null; then
    echo -e "${YELLOW}[⚠️ AVERTISSEMENT] Ollama n'est pas installé${NC}"
    ((AVERTISSEMENTS++))
else
    OLLAMA_VERSION=$(ollama --version)
    echo -e "${GREEN}[✅ OK] Ollama version $OLLAMA_VERSION${NC}"
fi

echo
echo -e "${BLUE}[4/6] Vérification des dépendances Node.js...${NC}"
if [ ! -d "node_modules" ]; then
    echo -e "${RED}[❌ ERREUR] Les dépendances Node.js ne sont pas installées${NC}"
    ((ERREURS++))
else
    echo -e "${GREEN}[✅ OK] Dépendances Node.js installées${NC}"
fi

echo
echo -e "${BLUE}[5/6] Vérification des dépendances Python...${NC}"
cd backend
if command -v python3 &> /dev/null; then
    python3 -c "import pandas, requests, schedule, openpyxl, ollama, numpy" 2>/dev/null
else
    python -c "import pandas, requests, schedule, openpyxl, ollama, numpy" 2>/dev/null
fi

if [ $? -ne 0 ]; then
    echo -e "${RED}[❌ ERREUR] Les dépendances Python ne sont pas installées${NC}"
    ((ERREURS++))
else
    echo -e "${GREEN}[✅ OK] Dépendances Python installées${NC}"
fi
cd ..

echo
echo -e "${BLUE}[6/6] Vérification du modèle IA...${NC}"
if command -v ollama &> /dev/null; then
    if ollama list | grep -q "llama3"; then
        echo -e "${GREEN}[✅ OK] Modèle IA disponible${NC}"
    else
        echo -e "${YELLOW}[⚠️ AVERTISSEMENT] Le modèle IA n'est pas téléchargé${NC}"
        ((AVERTISSEMENTS++))
    fi
else
    echo -e "${YELLOW}[⚠️ AVERTISSEMENT] Ollama non disponible, impossible de vérifier le modèle IA${NC}"
    ((AVERTISSEMENTS++))
fi

echo
echo -e "${BLUE}========================================"
echo -e "Résumé de la vérification"
echo -e "========================================${NC}"
echo

if [ $ERREURS -gt 0 ]; then
    echo -e "${RED}[❌ ERREURS] : $ERREURS problème(s) critique(s)${NC}"
    echo
    echo "Actions recommandées :"
    echo "1. Exécutez install.sh pour corriger les erreurs"
    echo "2. Redémarrez votre terminal après installation"
    echo "3. Relancez ce script de vérification"
else
    echo -e "${GREEN}[✅ OK] Aucune erreur critique détectée${NC}"
fi

if [ $AVERTISSEMENTS -gt 0 ]; then
    echo
    echo -e "${YELLOW}[⚠️ AVERTISSEMENTS] : $AVERTISSEMENTS avertissement(s)${NC}"
    echo
    echo "L'application fonctionnera mais certaines fonctionnalités"
    echo "pourraient être limitées (notamment l'IA)."
fi

if [ $ERREURS -eq 0 ]; then
    echo
    echo -e "${GREEN}[🎉 SUCCÈS] Votre installation est prête !${NC}"
    echo
    echo "Vous pouvez maintenant lancer l'application avec :"
    echo "- ./lancer.sh (recommandé)"
    echo "- ou npm start"
fi

echo 