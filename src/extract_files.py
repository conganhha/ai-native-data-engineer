import json
import pandas as pd
from pathlib import Path
from config import SETTINGS
from logger import get_logger

logger = get_logger(file_log='extract.log')

def read_dataset(path: Path) -> pd.DataFrame:
    file_name = path.name
    logger.info(f"READ {file_name}")
    if not path.exists():
        logger.error(f"{path} DOES NOT EXIST")
        raise FileNotFoundError(f"{path} DOES NOT EXIST")
    try:
        if path.suffix == ".csv":
            df = pd.read_csv(path, dtype=str, keep_default_na=False)
        elif path.suffix == ".json":
            raw_data = json.loads(path.read_text(encoding='utf-8'))
            match raw_data:
                case list() as records:
                    pass
                case {"data": list() as records}:
                    pass
                case _:
                    raise ValueError(f"UNSUPPORTED_JSON_FORMAT: {path}")
            df = pd.DataFrame(records, dtype=str).fillna("")
        else:
            raise ValueError(f"UNSUPPORTED_FILE: {path}")
    except Exception as e:
        logger.error(f"UNKNOWN_ERROR: {path}")
        raise
    if len(df) == 0:
        logger.critical(f"EMPTY_DATASET: {file}")
        raise ValueError(f"EMPTY_DATASET: {file}")
    logger.info(f"SUCCESS {file_name}: {len(df)} rows")
    return df

def profile(df: pd.DataFrame) -> dict:
    rows = len(df)
    columns = len(df.columns)
    missings = df.isna().sum().to_dict()
    duplicates = int(df.duplicated().sum())

    return {'rows': rows, 'columns': columns, 'missings': missings, 'duplicates': duplicates}


source = Path(__file__).resolve().parents[1] / 'data' / 'incremental' / 'day_2026-07-01'
files = ["customers_daily.csv", "products_daily.csv", "orders_daily.csv", "order_items_daily.csv", "payments_daily.json"]
df: dict[str, pd.DataFrame] = {}
for file in files:
    df[file] = read_dataset(source / file)
    logger.info(profile(df[file]))