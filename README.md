# myFlohmarkt MCP server

Public, read-only [MCP](https://modelcontextprotocol.io) server for German flea
markets — Flohmarkt, Trödelmarkt, Hofflohmarkt, Kinderflohmarkt, Nachtflohmarkt,
Antik- und Sammlermarkt — from the catalogue behind
[my-flohmarkt.de](https://my-flohmarkt.de).

```
https://mcp.my-flohmarkt.de/mcp
```

- **Transport:** Streamable HTTP (`POST`). The server is stateless — no session
  id to carry between calls. `GET` returns `405`: there is no SSE stream, because
  the server sends no server-initiated notifications.
- **Authentication:** none. Every tool is read-only and public.
- **Protocol:** negotiates up to revision `2025-11-25`, falls back to whatever
  the client asks for.
- **Registry:** [`de.my-flohmarkt/flea-market-catalog`](https://registry.modelcontextprotocol.io/v0.1/servers/de.my-flohmarkt%2Fflea-market-catalog/versions/latest)
  in the official MCP registry, namespace verified by DNS.

This repository holds documentation and examples. It is **not** the server's
source code, and it deliberately keeps no copy of `server.json`: the registry
link above serves the current metadata, so there is nothing here to go stale.

## Tools

All three declare an `outputSchema` and answer with `structuredContent`
alongside the text block, so a client gets a typed result rather than a JSON
string to parse. All are annotated `readOnlyHint: true`, `destructiveHint:
false`, `idempotentHint: true`, `openWorldHint: false`.

### `search_events`

Search by free text, by city **or postal code (PLZ)** through the same `city`
argument, by date range, or by radius around a coordinate.

| argument | type | notes |
| --- | --- | --- |
| `query` | string | free text, ≤ 200 chars |
| `city` | string | city name **or** PLZ, ≤ 100 chars |
| `dateFrom`, `dateTo` | string | `YYYY-MM-DD` |
| `lat`, `lng`, `radiusKm` | number | all three required together, radius ≤ 100 km |
| `limit` | integer | 1–50, default 10 |

Returns `{ items, total, totalIsLowerBound, dataAsOf }`. Each item carries
`id`, `title`, `date`, `timeFrom`, `timeTo`, `plz`, `city`, `lat`, `lng`,
`marketType`, `imageUrl`, `updatedAt` and `url` — the public event page.

### `get_event`

Full detail for one event by its UUID, as returned in the `id` field of the
other two tools: description, street address, opening times, market type and
topics, entrance fee and seller stand fee, stand sizes and table rental, and
whether sellers can still sign up. Unknown or non-public UUIDs return
`{ "error": "not_found" }`.

### `recently_updated_events`

The most recently added or changed events, newest first. Use it to see what is
new without a query; use `search_events` when you know the city, PLZ, dates or
area.

## Connect

Claude Code:

```bash
claude mcp add --transport http myflohmarkt https://mcp.my-flohmarkt.de/mcp
```

Any client that reads `mcp.json` (VS Code, Cursor, …):

```json
{
  "servers": {
    "myflohmarkt": {
      "type": "http",
      "url": "https://mcp.my-flohmarkt.de/mcp"
    }
  }
}
```

Raw JSON-RPC, no client required — see [`examples/`](examples).

## Without MCP

The same catalogue is served as plain REST for clients that do not speak MCP:

```
GET https://mcp.my-flohmarkt.de/events/search?city=Hamburg&limit=10
```

Machine-readable context for agents lives at
[llms.txt](https://my-flohmarkt.de/llms.txt) and
[llms-full.txt](https://my-flohmarkt.de/llms-full.txt); the REST contract is in
[openapi.json](https://my-flohmarkt.de/openapi.json).

## Limits and freshness

- **1200 requests per minute per IP**, 32 concurrent. Over the limit the server
  answers `429` with a `retry-after` header.
- Under heavy load a tool may answer `{ "error": "duckdb_query_overloaded",
  "retryAfterSeconds": n }` instead of blocking — retry after that many seconds.
- Answers come from a catalogue snapshot refreshed hourly. Every list result
  carries `dataAsOf` so you can see how fresh the data is. Coverage and
  methodology: [datenstand](https://my-flohmarkt.de/datenstand).

## Privacy

The server needs no account and sets no cookies. Request telemetry stores a
salted **HMAC hash** of the client IP (truncated), never the raw address, and
only a *classification* of the user agent — not the raw header. Query text and
tool arguments are not logged. Full policy:
[Datenschutz](https://my-flohmarkt.de/datenschutz).

## Stability and versioning

Tool names and their arguments are a public contract and are treated as
write-once: they are never renamed or given a new required argument. Changes
are additive — a new optional argument, a new field in a result — so a client
written against today's tools keeps working.

The version you can observe is `serverInfo.version` from `initialize`, and it
matches the version published in the registry, which is where the
machine-readable metadata lives:

```
https://registry.modelcontextprotocol.io/v0.1/servers/de.my-flohmarkt%2Fflea-market-catalog/versions/latest
```

Breaking anything in that contract would mean a new tool alongside the old one,
not a silent change to the existing one.

## Links

- Website: [my-flohmarkt.de](https://my-flohmarkt.de) · [FAQ](https://my-flohmarkt.de/faq)
- Legal: [Impressum](https://my-flohmarkt.de/impressum) · [AGB](https://my-flohmarkt.de/agb)
- Issues with the server: open an issue here.
