#!/bin/sh
echo "#Setando variáveis"
URL=https://www.tesourodireto.com.br/json/br/com/b3/tesourodireto/service/api/treasurybondsinfo.json
PROJECT_PATH=/home/jborda/Dropbox/Desenvolvimento/github/Finance-Helper
FILE_PATH=data/tesouro_direto.json

echo "#Atualizando repositório"
git -C $PROJECT_PATH pull

echo "#Atualizando $FILE_PATH com $URL"
curl $URL | jq > $PROJECT_PATH/$FILE_PATH

echo "#Enviando atualização"
git -C $PROJECT_PATH add $FILE_PATH
git -C $PROJECT_PATH commit -m "Atualização Tesouro Direto"
git -C $PROJECT_PATH push

echo  "## Finishi ##"
