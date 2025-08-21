@echo off
chcp 65001 >nul
echo ========================================
echo    Installation de DiamondsSearch
echo ========================================
echo.
echo Ce script va installer et configurer DiamondsSearch
echo sur votre système Windows.
echo.
echo Appuyez sur une touche pour continuer...
pause >nul

echo.
echo ========================================
echo Vérification des prérequis...
echo ========================================
echo.

REM Vérifier Node.js
echo [1/4] Vérification de Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [❌ ERREUR] Node.js n'est pas installé.
    echo.
    echo Veuillez télécharger et installer Node.js depuis :
    echo https://nodejs.org/
    echo.
    echo Choisissez la version LTS (recommandée).
    echo Après l'installation, redémarrez votre ordinateur.
    echo.
    echo Puis relancez ce script.
    echo.
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo [✅ OK] Node.js est installé (version %NODE_VERSION%)
)

REM Vérifier Python
echo [2/4] Vérification de Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [❌ ERREUR] Python n'est pas installé.
    echo.
    echo Veuillez télécharger et installer Python depuis :
    echo https://www.python.org/downloads/
    echo.
    echo IMPORTANT : Cochez "Add Python to PATH" lors de l'installation.
    echo Choisissez Python 3.8 ou supérieur.
    echo Après l'installation, redémarrez votre ordinateur.
    echo.
    echo Puis relancez ce script.
    echo.
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
    echo [✅ OK] Python est installé (version %PYTHON_VERSION%)
)

REM Vérifier Ollama
echo [3/4] Vérification d'Ollama...
ollama --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [❌ ERREUR] Ollama n'est pas installé.
    echo.
    echo Veuillez télécharger et installer Ollama depuis :
    echo https://ollama.ai/
    echo.
    echo Choisissez la version Windows.
    echo Après l'installation, redémarrez votre ordinateur.
    echo.
    echo Puis relancez ce script.
    echo.
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('ollama --version') do set OLLAMA_VERSION=%%i
    echo [✅ OK] Ollama est installé (version %OLLAMA_VERSION%)
)

echo.
echo [4/4] Tous les prérequis sont installés !
echo.
echo ========================================
echo Installation des dépendances...
echo ========================================
echo.

echo [1/3] Installation des dépendances Node.js...
echo Cette étape peut prendre quelques minutes...
npm install
if %errorlevel% neq 0 (
    echo [❌ ERREUR] Échec de l'installation des dépendances Node.js
    echo.
    echo Vérifiez votre connexion internet et relancez le script.
    echo.
    pause
    exit /b 1
) else (
    echo [✅ OK] Dépendances Node.js installées avec succès
)

echo.
echo [2/3] Installation des dépendances Python...
echo Cette étape peut prendre quelques minutes...
cd backend
..\\.venv\\Scripts\\pip.exe install -r requirements.txt
if %errorlevel% neq 0 (
    echo [❌ ERREUR] Échec de l'installation des dépendances Python
    echo.
    echo Vérifiez votre connexion internet et relancez le script.
    echo.
    cd ..
    pause
    exit /b 1
) else (
    echo [✅ OK] Dépendances Python installées avec succès
)
cd ..

echo.
echo [3/3] Téléchargement du modèle IA (Ollama)...
echo Cette étape peut prendre 10-15 minutes selon votre connexion...
echo Taille du modèle : environ 4 GB
echo.
ollama pull llama3:latest
if %errorlevel% neq 0 (
    echo [⚠️ ATTENTION] Échec du téléchargement du modèle Ollama
    echo.
    echo Vous pourrez le télécharger manuellement plus tard avec :
    echo ollama pull llama3:latest
    echo.
    echo L'application fonctionnera mais sans l'IA.
) else (
    echo [✅ OK] Modèle IA téléchargé avec succès
)

echo.
echo ========================================
echo 🎉 Installation terminée avec succès !
echo ========================================
echo.
echo Votre bot DiamondsSearch est maintenant prêt !
echo.
echo 📋 Prochaines étapes :
echo 1. Lancez l'application avec : npm start
echo 2. Scannez le QR code WhatsApp
echo 3. Configurez vos groupes
echo 4. Testez avec une recherche de diamant
echo.
echo 📖 Consultez le guide d'installation pour plus de détails :
echo GUIDE_INSTALLATION_CLIENT.md
echo.
echo Appuyez sur une touche pour fermer...
pause >nul 