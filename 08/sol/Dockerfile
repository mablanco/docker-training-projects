FROM python:3.15.0-alpine3.24
WORKDIR /app

# Don't write .pyc files into the mounted code (they would belong to root on
# the host) and print the logs straight away.
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install the dependencies before copying the code: this layer is only
# rebuilt when requirements.txt changes, not on every code change.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000
# Flask's development server, in debug mode: it reloads the app when the
# code changes and shows detailed errors. Never use it in production.
CMD ["flask", "--app", "app", "run", "--host", "0.0.0.0", "--debug"]
