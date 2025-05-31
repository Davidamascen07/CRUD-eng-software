@echo off
echo Resolvendo conflitos do Git...

REM Resetar para o estado anterior e tentar novamente
git reset --hard HEAD~1

echo Fazendo pull das mudancas remotas...
git pull origin main

REM Se ainda houver conflitos, usar a estrategi de merge recursiva
if %errorlevel% neq 0 (
    echo Tentando merge com estrategia recursiva...
    git pull origin main -X ours
)

echo Adicionando arquivos novamente...
git add .

echo Fazendo commit das mudancas locais...
git commit -m "Merge: Atualizacao do projeto CRUD - Engenharia de Software"

echo Fazendo push para o GitHub...
git push origin main

if %errorlevel% equ 0 (
    echo.
    echo ✓ Projeto enviado com sucesso para o GitHub!
    echo URL: https://github.com/Davidamascen07/CRUD-eng-software.git
) else (
    echo.
    echo ✗ Erro ao enviar para o GitHub. Tente os comandos manuais.
)

pause
