from sqlalchemy import create_engine, text
from .config import SETTINGS

engine = create_engine(SETTINGS.database_url, pool_pre_ping=True)


def ping():
    with engine.connect() as conn:
        return conn.execute(text('SELECT 1')).scalar_one()
