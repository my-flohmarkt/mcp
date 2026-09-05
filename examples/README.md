# Examples

Raw JSON-RPC over Streamable HTTP — no MCP client needed. The server answers
with an SSE-framed body, so each response is a `data: {...}` line.

```bash
./search-by-city.sh
./search-by-radius.sh
./recently-updated.sh
./list-tools.sh
./get-event.sh 22e452bc-9311-4e81-b924-4874f6c7f922
```
