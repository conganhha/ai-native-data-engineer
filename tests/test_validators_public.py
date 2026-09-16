import pandas as pd
from src.validators.business_validator import split_valid_invalid


def test_bad_email_rejected():
    df = pd.DataFrame([{'customer_id':'CUS1','full_name':'A','email':'bad','status':'active'}])
    valid, reject = split_valid_invalid('customers', df)
    assert len(valid) == 0
    assert 'INVALID_EMAIL' in reject.iloc[0].error_code


def test_negative_price_rejected():
    df = pd.DataFrame([{'product_id':'P1','category_id':'C1','product_name':'X','unit_price':-1,'cost_price':1,'status':'active'}])
    valid, reject = split_valid_invalid('products', df)
    assert 'NEGATIVE_PRICE' in reject.iloc[0].error_code


def test_quantity_zero_rejected():
    df = pd.DataFrame([{'order_item_id':'I1','order_id':'O1','product_id':'P1','quantity':0,'unit_price':1,'discount_amount':0}])
    valid, reject = split_valid_invalid('order_items', df)
    assert 'INVALID_QUANTITY' in reject.iloc[0].error_code


def test_valid_customer_passes():
    df = pd.DataFrame([{'customer_id':'CUS1','full_name':'A','email':'a@b.com','status':'active'}])
    valid, reject = split_valid_invalid('customers', df)
    assert len(valid) == 1 and len(reject) == 0
