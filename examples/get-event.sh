#!/usr/bin/env bash
# Full detail for one event. Pass a UUID taken from a search result's `id`.
EVENT_ID="${1:?usage: get-event.sh <event-uuid>}"
curl -sS https://mcp.my-flohmarkt.de/mcp \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/event-stream' \
  -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"get_event\",\"arguments\":{\"id\":\"${EVENT_ID}\"}}}"
