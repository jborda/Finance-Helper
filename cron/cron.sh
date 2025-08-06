#!/bin/sh
echo "#Configura o cron para atualizar os valores do Tesouro Direto diariamente"
RUN_PATH=/home/jborda/Dropbox/Desenvolvimento/github/Finance-Helper

echo #Criando estrutura#
chmod +x $RUN_PATH/run.sh

echo "#Configurando cron"
crontab cron.cfg
crontab -l

echo "## FINISH ##"
