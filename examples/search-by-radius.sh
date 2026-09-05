#!/usr/bin/env bash
# Everything within 25 km of Berlin Mitte over a date range.
# lat, lng and radiusKm must always be sent together; radius is capped at 100 km.
curl -sS https://mcp.my-flohmarkt.de/mcp \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"search_events","arguments":{"lat":52.52,"lng":13.405,"radiusKm":25,"dateFrom":"2026-09-01","dateTo":"2026-09-30","limit":10}}}'
