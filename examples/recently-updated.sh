#!/usr/bin/env bash
# What was added or changed most recently.
curl -sS https://mcp.my-flohmarkt.de/mcp \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"recently_updated_events","arguments":{"limit":10}}}'
