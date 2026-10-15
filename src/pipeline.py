from config import SETTINGS
from extract_files import read_dataset, profile
from transform import normalize
from pathlib import Path
from logger import get_logger
import pandas as pd
import argparse

logger = get_logger(file_log="pipeline.log")

df: dict[str, pd.DataFrame] = {}
parser = argparse.ArgumentParser()
parser.add_argument("--input_dir", default=Path(__file__).resolve().parents[1] / 'data' / 'incremental' / 'day_2026-07-01')
args = parser.parse_args()
source = args.input_dir
files = ["customers_daily.csv", "products_daily.csv", "orders_daily.csv", "order_items_daily.csv", "payments_daily.json"]

for file in files:
    df[file] = read_dataset(source / file)
    logger.info(profile(df[file]))
    Path(SETTINGS.staging_dir).mkdir(exist_ok=True)
    normalize(df[file]).to_csv(SETTINGS.staging_dir / f"{file}_clean.csv", encoding='utf-8', index=False)