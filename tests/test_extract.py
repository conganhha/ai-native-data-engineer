import pytest
import pandas as pd
from src.extract_files import read_dataset
from pathlib import Path

def test_read_csv_success(tmp_path):
    test_csv = {
        'id': [1, 2 , 3],
        'value': ['a', 'b', 'c']
    }
    pd.DataFrame(test_csv, dtype=str).fillna('').to_csv(tmp_path / 'test.csv')
    df = read_dataset(tmp_path / 'test.csv')
    assert isinstance(df, pd.DataFrame)

def test_json_nested_date(tmp_path):
    json_file = tmp_path / 'test.json'
    json_file.write_text(
        "{\"data\":\n" \
        "[\"abc\", 123]\n" \
        "}"
    )
    df = read_dataset(json_file)
    assert isinstance(df, pd.DataFrame)

def test_read_file_not_found(tmp_path):
    with pytest.raises(FileNotFoundError):
        read_dataset(tmp_path / 'not_exists.csv')

def test_read_unsupported_file(tmp_path):
    txt_file = tmp_path / 'test.txt'
    txt_file.write_text('abc')
    with pytest.raises(ValueError):
        read_dataset(txt_file)