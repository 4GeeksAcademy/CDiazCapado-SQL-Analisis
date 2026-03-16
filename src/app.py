import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
import pandas as pd


# Load environment variables
load_dotenv()

# Read DB path from environment variable
DB_PATH = os.getenv('DB_PATH', './data/database.db')  # fallback to default
DB_URL = f'sqlite:///{DB_PATH}'

# Connect to the existing SQLite database
def connect():
    try:
        engine = create_engine(DB_URL)
        engine.connect()
        print("✅ Connected to existing SQLite database.")
        return engine
    except Exception as e:
        print(f"❌ Error connecting to database: {e}")
        return None

# Run student-defined queries from queries.sql
def run_queries_from_file(engine, filepath):
    try:
        with open(filepath, "r", encoding="utf-8-sig") as file:
            content = file.read()

        # quitar comentarios línea a línea
        clean_lines = []
        for line in content.splitlines():
            stripped = line.strip()
            if not stripped:
                continue
            if stripped.startswith("--"):
                continue
            clean_lines.append(line)

        clean_sql = "\n".join(clean_lines)

        queries = [q.strip() for q in clean_sql.split(";") if q.strip()]

        for i, query in enumerate(queries, start=1):
            try:
                print(f"\n🔎 Query {i}:\n{query}")
                df = pd.read_sql(query, con=engine)
                print(df)
            except Exception as e:
                print(f"❌ Error in Query {i}: {e}")
    except Exception as e:
        print(f"❌ Error processing queries from {filepath}: {e}")
# Entry point
if __name__ == "__main__":
    engine = connect()
    if engine:
        run_queries_from_file(engine, './src/sql/queries.sql')