def split_cross_table_invalid(name, df, reference_ids=None, order_dates=None):
    """TODO Buổi 7: cross-table integrity.

    Rules tối thiểu:
    products.category_id -> categories
    orders.customer_id -> customers
    order_items.order_id -> orders
    order_items.product_id -> products
    payments.order_id -> orders
    payment_date >= order_date
    """
    raise NotImplementedError('Implement split_cross_table_invalid()')
