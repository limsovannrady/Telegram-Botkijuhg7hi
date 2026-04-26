FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        tini \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY telegram_bot_simple.py ./

RUN useradd --create-home --shell /bin/bash botuser \
    && chown -R botuser:botuser /app
USER botuser

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["python", "-u", "telegram_bot_simple.py"]
