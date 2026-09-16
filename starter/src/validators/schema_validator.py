REQUIRED = {
    'customers':['customer_id','full_name','email','status'],
    'products':['product_id','category_id','product_name','unit_price','status'],
    'orders':['order_id','customer_id','order_date','status','order_total'],
    'order_items':['order_item_id','order_id','product_id','quantity','unit_price','discount_amount'],
    'payments':['payment_id','order_id','payment_date','payment_status','amount'],
}


def validate_schema(name, df):
    # TODO Buổi 7: phát hiện missing required columns; raise ValueError có thông tin dataset/cột.
    raise NotImplementedError('Implement validate_schema()')
