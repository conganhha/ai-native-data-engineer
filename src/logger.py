import logging
from config import SETTINGS

def get_logger(name: str = "pipeline", file_log: str = "pipeline.log") -> logging:
    SETTINGS.log_dir.mkdir(exist_ok=True)

    logger = logging.getLogger(name)

    logger.setLevel(logging.DEBUG)

    fmt = logging.Formatter("%(asctime)s | %(levelname)-8s | %(name)s | %(message)s")

    console = logging.StreamHandler()
    console.setFormatter(fmt)
    logger.addHandler(console)

    file_h = logging.FileHandler(SETTINGS.log_dir / file_log, encoding="utf-8")
    file_h.setFormatter(fmt)
    logger.addHandler(file_h)

    return logger