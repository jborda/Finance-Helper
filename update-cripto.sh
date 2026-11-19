#!/bin/bash

OUTPUT_DIR="data"
FILENAME="cripto.json"
mkdir -p "$OUTPUT_DIR"

BASES='["BTC", "ETH", "USDT","USDC","CHZ","SOL","BANANAS31","FUN","SHELL","BMT","HYPE"]'

SYMBOLS=$(curl -sf "https://api.binance.com/api/v3/exchangeInfo" \
    | jq -c --argjson bases "$BASES" '[
        .symbols[]
        | select(.quoteAsset == "USDT" and .status == "TRADING")
        | select(.baseAsset as $b | $bases | index($b))
        | .symbol
      ]')

# Inclui USDTBRL para converter USD em BRL
SYMBOLS=$(echo "$SYMBOLS" | jq -c '. + ["USDTBRL"]')

curl -sfG "https://api.binance.com/api/v3/ticker/24hr" \
    --data-urlencode "symbols=$SYMBOLS" \
    | jq '
        (map(select(.symbol == "USDTBRL")) | .[0].lastPrice | tonumber) as $brl
        | map(. + {
            lastPriceUSD: (.lastPrice | tonumber),
            lastPriceBRL: ((.lastPrice | tonumber) * $brl)
          })
      ' > "$OUTPUT_DIR/$FILENAME"

echo "Salvo em $OUTPUT_DIR/$FILENAME"