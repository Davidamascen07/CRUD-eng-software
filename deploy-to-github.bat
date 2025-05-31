@echo off
echo Configurando repositorio Git...

REM Inicializar repositorio local se nao existir
if not exist .git (
    git init
    echo Repositorio Git inicializado.
)

REM Adicionar o repositorio remoto
git remote remove origin 2>nul
git remote add origin https://github.com/Davidamascen07/CRUD-eng-software.git

echo Baixando arquivos existentes do GitHub...
git pull origin main --allow-unrelated-histories

REM Se houver conflitos, o usuario precisara resolve-los manualmente
if %errorlevel% neq 0 (
    echo.
    echo ATENCAO: Podem existir conflitos que precisam ser resolvidos manualmente.
    echo Execute 'git status' para ver os conflitos e resolva-os antes de continuar.
    pause
    exit /b 1
)

echo Adicionando todos os arquivos locais...
git add .

echo Fazendo commit das mudancas...
git commit -m "Atualizacao do projeto CRUD - Engenharia de Software"

echo Enviando para o GitHub...
git push origin main

echo.
echo Projeto enviado com sucesso para o GitHub!
echo URL: https://github.com/Davidamascen07/CRUD-eng-software.git
pause
