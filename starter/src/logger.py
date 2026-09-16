import logging
from pathlib import Path


def get_logger(name='pipeline'):
    # TODO: Buổi 5 - cấu hình file handler + console handler, format timestamp/level/name/message.
    Path('logs').mkdir(exist_ok=True)
    logger = logging.getLogger(name)
    if logger.handlers:
        return logger
    logger.setLevel(logging.INFO)
    return logger
