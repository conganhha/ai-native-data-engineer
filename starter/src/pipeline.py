"""Buổi 8 - orchestration skeleton.

Mục tiêu cuối:
Source(file/API) -> RAW -> normalize -> validate -> reject/valid -> upsert CORE
-> DQ report -> checkpoint/watermark -> optional refresh MART.
"""
from pathlib import Path


def run(input_dir=Path('data/incremental/day_2026-07-01'), source='file', refresh=False):
    # TODO 1: tạo run_id và đọc checkpoint.
    # TODO 2: đọc file/API; API phải lưu RAW trước transform.
    # TODO 3: xử lý theo dependency order customers -> products -> orders -> order_items -> payments.
    # TODO 4: schema/business/cross-table validation + duplicate PK.
    # TODO 5: tách reject; upsert valid.
    # TODO 6: DQ report, watermark/checkpoint chỉ ghi sau successful run.
    # TODO 7: nếu refresh=True thì refresh Data Mart.
    raise NotImplementedError('Implement end-to-end pipeline')
