FROM python:3.15.2-alpine3.24
ENV PYTHONUNBUFFERED=1

# tini runs as PID 1: it forwards the signals to the service and reaps the
# zombie processes left by the background jobs
RUN apk add --no-cache tini

WORKDIR /app
COPY app.py entrypoint.sh ./
USER 65534:65534
EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --start-interval=1s \
  CMD ["wget", "-qO-", "http://127.0.0.1:8000/health"]

# Exec form, so that no shell sits between Docker and tini
ENTRYPOINT ["/sbin/tini", "--", "/app/entrypoint.sh"]
