import os
from dataclasses import dataclass
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

@dataclass(frozen=True)
class Settings:
    root = Path(__file__).resolve().parents[1]
    db_url = os.getenv('DATABASE_URL')
    api_url = os.getenv('MOCK_API_URL', 'https://localhost:8000')
    api_key = os.getenv('MOCK_API_KEY', 'training_key')
    logging_level = os.getenv('LOGGING_LEVEL')
    raw_dir: Path = root / 'data' / 'raw'
    reject_dir: Path = root / 'data' / 'reject'
    metadata_dir: Path = root / 'metadata'
    report_dir: Path = root / 'reports'
    log_dir: Path = root / 'logs'
    staging_dir: Path = root / 'data' / 'staging'

SETTINGS = Settings()