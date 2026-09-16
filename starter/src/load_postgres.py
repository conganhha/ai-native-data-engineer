PK = {
    'customers':'customer_id', 'products':'product_id', 'orders':'order_id',
    'order_items':'order_item_id', 'payments':'payment_id'
}


def upsert_dataframe(name, df):
    """TODO Buổi 6: INSERT ... ON CONFLICT ... DO UPDATE. Trả inserted/updated stats."""
    raise NotImplementedError('Implement upsert_dataframe()')
