@echo off
chcp 65001 >nul
echo ========================================
echo    Lancement de DiamondsSearch
echo ========================================
echo.

REM Vérifier que Node.js est installé
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [❌ ERREUR] Node.js n'est pas installé.
    echo Veuillez exécuter install.bat d'abord.
    pause
    exit /b 1
)

REM Vérifier que les dépendances sont installées
if not exist "node_modules" (
    echo [❌ ERREUR] Les dépendances ne sont pas installées.
    echo Veuillez exécuter install.bat d'abord.
    pause
    exit /b 1
)

REM Vérifier que Python (.venv) est installé
.venv\Scripts\python.exe --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [❌ ERREUR] Environnement virtuel Python (.venv) n'est pas configuré.
    echo Veuillez exécuter install.bat d'abord.
    pause
    exit /b 1
)

REM Vérifier que Ollama est installé
ollama --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [⚠️ ATTENTION] Ollama n'est pas installé.
    echo L'IA ne fonctionnera pas, mais l'application peut démarrer.
    echo.
    set /p choice="Voulez-vous continuer ? (o/n) : "
    if /i "%choice%" neq "o" exit /b 1
)

echo [✅ OK] Tous les prérequis sont vérifiés.
echo.
echo Lancement de DiamondsSearch...
echo.

npm start

if %errorlevel% neq 0 (
    echo.
    echo [❌ ERREUR] L'application n'a pas pu démarrer.
    echo Vérifiez les logs ci-dessus pour plus de détails.
    echo.
    pause
) 