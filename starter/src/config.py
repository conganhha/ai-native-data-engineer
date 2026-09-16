from dataclasses import dataclass
from pathlib import Path
import os
from dotenv import load_dotenv

load_dotenv()


@dataclass(frozen=True)
class Settings:
    root: Path = Path(__file__).resolve().parents[1]
    database_url: str = os.getenv('DATABASE_URL', 'postgresql+psycopg://de_user:de_password@localhost:5432/ecommerce')
    api_url: str = os.getenv('MOCK_API_URL', 'http://localhost:8000')
    api_key: str = os.getenv('MOCK_API_KEY', 'training-key')
    raw_dir: Path = root / 'data' / 'raw'
    reject_dir: Path = root / 'data' / 'reject'
    metadata_dir: Path = root / 'metadata'
    report_dir: Path = root / 'reports'


SETTINGS = Settings()
