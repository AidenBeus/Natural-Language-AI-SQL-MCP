"""Create the local SQLite database used by the YouTube MCP server."""

from pathlib import Path
import sqlite3


ROOT = Path(__file__).parent
DATABASE_PATH = ROOT / "youtube.sqlite"


def main() -> None:
    if DATABASE_PATH.exists():
        DATABASE_PATH.unlink()

    with sqlite3.connect(DATABASE_PATH) as connection:
        connection.execute("PRAGMA foreign_keys = ON")
        connection.executescript((ROOT / "setup_youtube.sql").read_text(encoding="utf-8"))
        connection.executescript((ROOT / "setup_youtube_data.sql").read_text(encoding="utf-8"))

    print(f"Created {DATABASE_PATH}")


if __name__ == "__main__":
    main()
