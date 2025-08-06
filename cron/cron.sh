#!/bin/sh
echo "#Configura o cron para atualizar os valores do Tesouro Direto diariamente"
PROJECT_PATH=/home/jborda/Dropbox/Desenvolvimento/github/Finance-Helper

echo #Criando estrutura#
chmod +x $PROJECT_PATH/run.sh

echo "#Configurando cron"
crontab $PROJECT_PATH/cron/cron.cfg
crontab -l

echo "## FINISH ##"
