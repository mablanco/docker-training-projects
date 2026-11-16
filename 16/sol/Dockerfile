# A current, minimal base image: fewer packages, fewer vulnerabilities
FROM python:3.15.2-alpine3.24
# Fixes reach Alpine's package repositories before a new base image is
# published, so upgrade the system packages too
RUN apk upgrade --no-cache
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

USER 65534:65534
EXPOSE 5000
# A production server instead of Flask's development one
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
