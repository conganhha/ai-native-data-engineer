from pathlib import Path
import pandas as pd


def read_dataset(path: Path) -> pd.DataFrame:
    """TODO Buổi 5: đọc CSV hoặc JSON và trả về DataFrame."""
    raise NotImplementedError('Implement read_dataset()')


def profile(df: pd.DataFrame) -> dict:
    """TODO Buổi 5: rows, columns, missing theo cột, duplicate rows."""
    raise NotImplementedError('Implement profile()')
