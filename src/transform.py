import pandas as pd
from logger import get_logger
from config import SETTINGS

logger = get_logger(file_log='nomarlize.log')

LOWERCASE_COLUMNS = ['email', 'status', 'payment_status', 'payment_method', 'channel']
NUMERIC_COLUMNS = ['unit_price', 'cost_price', 'order_total', 'discount_amount', 'amount', 'quantity']
DATETIME_COLUMNS = ['order_date', 'payment_date', 'created_at', 'updated_at']

def normalize(df: pd.DataFrame) -> pd.DataFrame:
    out = df.copy()
    out.columns = [c.strip().lower() for c in out.columns]
    for c in out.select_dtypes(include=["object", "string"]).columns:
        out[c] = out[c].str.strip()
    for c in LOWERCASE_COLUMNS:
        if c in out.columns:
            out[c] = out[c].str.lower()
    for c in NUMERIC_COLUMNS:
        if c in out.columns:
            out[c] = pd.to_numeric(out[c], errors='coerce')
    for c in DATETIME_COLUMNS:
        if c in out.columns:
            out[c] = pd.to_datetime(out[c], errors='coerce', utc=True)
    return out