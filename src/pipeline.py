from extract_files import read_dataset, profile
from transform import normalize
from pathlib import Path
from logger import get_logger
import pandas as pd

logger = get_logger(file_log="pipeline.log")

source = Path(__file__).resolve().parents[1] / 'data' / 'incremental' / 'day_2026-07-01'
files = ["customers_daily.csv", "products_daily.csv", "orders_daily.csv", "order_items_daily.csv", "payments_daily.json"]
df: dict[str, pd.DataFrame] = {}
for file in files:
    df[file] = read_dataset(source / file)
    logger.info(df[file].head(5))
    logger.info(normalize(df[file]).head(5))