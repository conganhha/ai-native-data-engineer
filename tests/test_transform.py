from src.transform import normalize
from src.extract_files import profile
import pandas as pd
import pytest

def test_profile_metrics(tmp_path):
    tmp_datas = {
        'col1': [1, 'cong', None, 'cong'],
        'col2': [2, 'cong', None, 'cong']
    }
    df = pd.DataFrame(tmp_datas)
    pf = profile(df)
    assert pf['columns'] == 2
    assert pf['rows'] == 4
    assert pf['duplicates'] == 1
    assert len(pf['missings']) == 2

def test_normalize_raw_immutability(tmp_path):
    tmp_datas = {
        'Email': ['CongAnhDzvcl@gmail.com', 'vipPro@gmaiL.com'],
        'unit_price': [2, 3]
    }
    df = pd.DataFrame(tmp_datas)
    df_normalize = normalize(df)
    assert df.to_dict() != df_normalize.to_dict()

def test_normalize_strings_and_enums():
    raw_df = pd.DataFrame({
        "email": ["  User1@Domain.COM ", "ADMIN@TEST.ORG\t"],
        "status": [" PENDING ", "COMPLETED "],
        "payment_method": [" Credit_Card ", "PAYPAL"],
        "channel": [" Web ", " MOBILE_APP "],
    })

    cleaned_df = normalize(raw_df)

    assert cleaned_df["email"].tolist() == ["user1@domain.com", "admin@test.org"]
    assert cleaned_df["status"].tolist() == ["pending", "completed"]
    assert cleaned_df["payment_method"].tolist() == ["credit_card", "paypal"]
    assert cleaned_df["channel"].tolist() == ["web", "mobile_app"]


def test_normalize_numeric_and_datetime():
    raw_df = pd.DataFrame({
        "amount": ["120.50", "300", "invalid"],
        "quantity": ["1", "5", "10"],
        "created_at": [
            "2026-10-15 10:00:00",
            "2026-10-15T15:30:00Z",
            "2026/10/16 00:00:00",
        ],
    })

    cleaned_df = normalize(raw_df)

    assert pd.api.types.is_numeric_dtype(cleaned_df["amount"])
    assert pd.api.types.is_numeric_dtype(cleaned_df["quantity"])
    assert cleaned_df["amount"].isna().sum() == 1

    assert pd.api.types.is_datetime64_any_dtype(cleaned_df["created_at"])
    assert cleaned_df["created_at"].dt.tz is not None