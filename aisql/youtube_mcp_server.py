"""Read-only MCP server for the YouTube database design.

Run ``python setup_database.py`` once, then start this server with
``python youtube_mcp_server.py``. The default stdio transport works with MCP
clients such as Codex. Use ``--transport streamable-http`` for remote clients.
"""

from __future__ import annotations

import argparse
import re
import sqlite3
from pathlib import Path
from typing import Any

from fastmcp import FastMCP

ROOT = Path(__file__).parent
DATABASE_PATH = ROOT / "youtube.sqlite"
MAX_ROWS = 100

mcp = FastMCP(
    name="youtube-database",
    instructions=(
        "Use this server to answer questions about a sample YouTube database. "
        "Call get_schema before writing SQL when the schema is not already known. "
        "Only use run_readonly_sql for a single SQLite SELECT or WITH query. "
        "After every answer based on run_readonly_sql, include an `SQL used` "
        "heading followed by the exact query from the tool result in a fenced "
        "sql code block. Never expose password, bank routing number, or bank "
        "account number."
    ),
)


def connect_read_only() -> sqlite3.Connection:
    """Open the local database in SQLite read-only mode."""
    if not DATABASE_PATH.exists():
        raise FileNotFoundError(
            "Database does not exist. Run `python setup_database.py` first."
        )

    connection = sqlite3.connect(f"file:{DATABASE_PATH}?mode=ro", uri=True)
    connection.row_factory = sqlite3.Row
    connection.execute("PRAGMA query_only = ON")
    return connection


def validate_query(sql: str) -> str:
    """Reject statements that are not one read-only SQLite query."""
    query = sql.strip()
    if not query:
        raise ValueError("SQL cannot be empty.")

    # A trailing semicolon is fine; any other semicolon would enable another
    # statement. The database connection is read-only as a second safeguard.
    query = query[:-1].rstrip() if query.endswith(";") else query
    if ";" in query:
        raise ValueError("Only one SQL statement is allowed.")

    if not re.match(r"^(SELECT|WITH)\b", query, flags=re.IGNORECASE):
        raise ValueError("Only SELECT or WITH queries are allowed.")

    forbidden = re.compile(
        r"\b(ATTACH|DETACH|PRAGMA|VACUUM|INSERT|UPDATE|DELETE|DROP|ALTER|CREATE|REPLACE)\b",
        flags=re.IGNORECASE,
    )
    if forbidden.search(query):
        raise ValueError("The query contains a disallowed operation.")

    sensitive = re.compile(r"\b(password|routing_number|account_number)\b", re.IGNORECASE)
    if sensitive.search(query):
        raise ValueError("Queries cannot access sensitive account fields.")

    return query


@mcp.tool()
def get_schema() -> str:
    """Return the SQL schema and relationship details for the YouTube database."""
    with connect_read_only() as connection:
        rows = connection.execute(
            "SELECT sql FROM sqlite_master "
            "WHERE type = 'table' AND name NOT LIKE 'sqlite_%' "
            "ORDER BY name"
        ).fetchall()
    return "\n\n".join(row["sql"] for row in rows)


@mcp.tool()
def run_readonly_sql(sql: str) -> dict[str, Any]:
    """Run one SQLite SELECT/WITH query and return at most 100 rows.

    Do not select `user.password`, `bank.routing_number`, or
    `bank.account_number`. Aggregate or omit sensitive fields instead.
    In the final user-facing answer, reproduce the returned `sql` value under
    an `SQL used` heading in a fenced SQL code block.
    """
    query = validate_query(sql)

    with connect_read_only() as connection:
        cursor = connection.execute(query)
        if cursor.description is None:
            raise ValueError("The query did not return rows.")
        columns = [column[0] for column in cursor.description]
        rows = [dict(row) for row in cursor.fetchmany(MAX_ROWS)]

    return {
        "sql": query,
        "columns": columns,
        "row_count": len(rows),
        "rows": rows,
        "truncated": len(rows) == MAX_ROWS,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Start the YouTube MCP server.")
    parser.add_argument(
        "--transport",
        default="stdio",
        choices=("stdio", "sse", "streamable-http"),
        help="MCP transport; use stdio for a local MCP client.",
    )
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8000)
    args = parser.parse_args()

    if args.transport == "stdio":
        mcp.run(transport="stdio")
    else:
        mcp.run(transport=args.transport, host=args.host, port=args.port)


if __name__ == "__main__":
    main()
