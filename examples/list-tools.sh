#!/usr/bin/env bash
# List the tools the server exposes, with their input and output schemas.
curl -sS https://mcp.my-flohmarkt.de/mcp \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'
