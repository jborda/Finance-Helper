#!/bin/bash

# --- Lista de URLs para buscar os dados ---
urls=(
    "https://www.tesourodireto.com.br/o/historico-rentabilidade/160?days=30"
    "https://www.tesourodireto.com.br/o/historico-rentabilidade/162?days=30"
    "https://www.tesourodireto.com.br/o/historico-rentabilidade/169?days=30"
    "https://www.tesourodireto.com.br/o/historico-rentabilidade/178?days=30"
    "https://www.tesourodireto.com.br/o/historico-rentabilidade/205?days=30"
)

# --- Caminho para o arquivo JSON local ---
json_file="data/tesouro_direto.json"

# --- Valida se o arquivo JSON existe ---
if [ ! -f "$json_file" ]; then
    echo "Erro: O arquivo $json_file não foi encontrado."
    exit 1
fi

# --- Loop para processar cada URL ---
for url in "${urls[@]}"; do
    echo "Processando URL: $url"

    # Faz o curl e extrai os valores usando jq
    json_data=$(curl -s "$url" | jq -c '.TrsrBd | {nm, ult_untrRedVal: .untrRedVal[-1]}')

    # Valida se a extração do jq foi bem-sucedida
    if [ -z "$json_data" ]; then
        echo "Aviso: Não foi possível extrair dados da URL $url. Pulando para a próxima."
        continue
    fi

    # Extrai o nome do título e o valor de resgate para variáveis
    nm=$(echo "$json_data" | jq -r '.nm')
    untr_red_val=$(echo "$json_data" | jq -r '.ult_untrRedVal')

    echo "  - Encontrado: NM='$nm', Valor de resgate='$untr_red_val'"

    # Use 'jq' para atualizar o untrRedVal no arquivo JSON local.
    # A flag --in-place (-i) edita o arquivo original diretamente.
    jq --arg nm "$nm" --argjson val "$untr_red_val" '(.response.TrsrBdTradgList[] | select(.TrsrBd.nm == $nm) | .TrsrBd.untrRedVal) = $val' "$json_file" > "temp.json" && mv "temp.json" "$json_file"

    echo "  - O valor de '$untr_red_val' foi atualizado para o título '$nm'."
done

echo "Processo concluído."
