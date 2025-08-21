@echo off
chcp 65001 >nul
echo ========================================
echo    Vérification de l'Installation
echo ========================================
echo.

set "ERREURS=0"
set "AVERTISSEMENTS=0"

echo [1/6] Vérification de Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [❌ ERREUR] Node.js n'est pas installé
    set /a ERREURS+=1
) else (
    for /f "tokens=*" %%i in ('node --version 2^>nul') do set NODE_VERSION=%%i
    echo [✅ OK] Node.js version %NODE_VERSION%
)

echo.
echo [2/6] Vérification de Python (.venv)...
.venv\Scripts\python.exe --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [❌ ERREUR] Environnement virtuel Python ^(.venv^) n'est pas configuré
    set /a ERREURS+=1
) else (
    for /f "tokens=*" %%i in ('.venv\Scripts\python.exe --version 2^>nul') do set PYTHON_VERSION=%%i
    echo [✅ OK] Python version %PYTHON_VERSION% (environnement virtuel)
)

echo.
echo [3/6] Vérification d'Ollama...
ollama --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [⚠️ AVERTISSEMENT] Ollama n'est pas installé
    set /a AVERTISSEMENTS+=1
) else (
    for /f "tokens=*" %%i in ('ollama --version 2^>nul') do set OLLAMA_VERSION=%%i
    echo [✅ OK] Ollama version %OLLAMA_VERSION%
)

echo.
echo [4/6] Vérification des dépendances Node.js...
if not exist "node_modules" (
    echo [❌ ERREUR] Les dépendances Node.js ne sont pas installées
    set /a ERREURS+=1
) else (
    echo [✅ OK] Dépendances Node.js installées
)

echo.
echo [5/6] Vérification des dépendances Python...
cd backend
..\.venv\Scripts\python.exe -c "import pandas, requests, schedule, openpyxl, ollama, numpy" >nul 2>&1
if %errorlevel% neq 0 (
    echo [❌ ERREUR] Les dépendances Python ne sont pas installées dans .venv
    set /a ERREURS+=1
) else (
    echo [✅ OK] Dépendances Python installées dans .venv
)
cd ..

echo.
echo [6/6] Vérification du modèle IA...
ollama list | findstr "llama3" >nul 2>&1
if %errorlevel% neq 0 (
    echo [⚠️ AVERTISSEMENT] Le modèle IA n'est pas téléchargé
    set /a AVERTISSEMENTS+=1
) else (
    echo [✅ OK] Modèle IA disponible
)

echo.
echo ========================================
echo Résumé de la vérification
echo ========================================
echo.

if %ERREURS% gtr 0 (
    echo [❌ ERREURS] : %ERREURS% problème(s) critique(s)
    echo.
    echo Actions recommandées :
    echo 1. Exécutez install.bat pour corriger les erreurs
    echo 2. Redémarrez votre ordinateur après installation
    echo 3. Relancez ce script de vérification
) else (
    echo [✅ OK] Aucune erreur critique détectée
)

if %AVERTISSEMENTS% gtr 0 (
    echo.
    echo [⚠️ AVERTISSEMENTS] : %AVERTISSEMENTS% avertissement(s)
    echo.
    echo L'application fonctionnera mais certaines fonctionnalités
    echo pourraient être limitées (notamment l'IA).
)

if %ERREURS% equ 0 (
    echo.
    echo [🎉 SUCCÈS] Votre installation est prête !
    echo.
    echo Vous pouvez maintenant lancer l'application avec :
    echo - lancer.bat (recommandé)
    echo - ou npm start
)

echo.
pause 