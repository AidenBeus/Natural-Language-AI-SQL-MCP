# YouTube Database MCP Server

This is a read-only Model Context Protocol (MCP) server for the YouTube-style
database in the supplied drawSQL diagram. It exposes two tools:

- `get_schema` returns the SQLite schema.
- `run_readonly_sql` runs a single SQLite `SELECT` or `WITH` query and returns
  up to 100 rows.

The server blocks data-changing SQL and access to demo passwords and bank
account fields. Those checks supplement SQLite's read-only connection mode;
they are not a substitute for production authentication and authorization.

## Run locally

Use Python 3.10 or later.

```powershell
py -m pip install -r requirements.txt
py setup_database.py
py youtube_mcp_server.py
```

The default transport is `stdio`, which is the right choice for a local MCP
client. This project already includes the Codex configuration at
`.codex/config.toml`. Open this folder in Codex, mark it as trusted if prompted,
then start a new Codex chat and ask a database question. Codex starts the MCP
server itself; do not start `youtube_mcp_server.py` in a separate terminal.
For every database-backed answer, the server instructs Codex to include the
exact query under an **SQL used** heading.

For another MCP client, configure it to run `py youtube_mcp_server.py` with
this directory as its working directory.

## Run over HTTP

```powershell
py youtube_mcp_server.py --transport streamable-http --host 127.0.0.1 --port 8000
```

For a local server, use a secure tunnel rather than exposing port 8000 to the
internet. A remote client should allow only `get_schema` and
`run_readonly_sql`, and require approval during development.

## Useful test questions

- Which videos have the most likes?
- Which creators are monetized but not verified?
- Who commented on "SQLite in 10 Minutes"?
- Which channels have the most subscribers?
- What were the payment totals for each creator?
