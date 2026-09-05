#!/usr/bin/env bash
# Flea markets in Hamburg. The same argument accepts a postal code: "22459".
curl -sS https://mcp.my-flohmarkt.de/mcp \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"search_events","arguments":{"city":"Hamburg","limit":5}}}'
