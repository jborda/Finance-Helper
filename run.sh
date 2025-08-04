#!/bin/sh
echo #Setando variáveis
URL=https://www.tesourodireto.com.br/json/br/com/b3/tesourodireto/service/api/treasurybondsinfo.json
FILE_PATH=data/tesouro_direto.json

echo #Atualizando repositório
git pull

echo #Atualizando $FILE_PATH com $URL
curl $URL | jq > $FILE_PATH

echo #Comitando atualização
git add $FILE_PATH
git commit -m "Atualização Tesouro Direto"
git push

echo  # Finishi #
