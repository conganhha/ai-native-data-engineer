import pandas as pd
from logger import get_logger
from config import SETTINGS

logger = get_logger(file_log='nomarlize.log')

def normalize(df: pd.DataFrame):
    df_clean = df.copy()
    df_clean.columns = [c.strip().lower() for c in df_clean.columns]
    [df_clean[c].strip() for c in df_clean.columns]