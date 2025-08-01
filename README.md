# Finance-Helper
## Preparação
git clone https://github.com/jborda/Finance-Helper.git
cd Finance-Helper

## Execução
URL=https://www.tesourodireto.com.br/json/br/com/b3/tesourodireto/service/api/treasurybondsinfo.json
FILE_PATH=data/tesouro_direto.json

git pull
curl $URL | jq > $FILE_PATH
git add $FILE_PATH
git commit -m Atualização Testouro Direto"
git push

## Cron
