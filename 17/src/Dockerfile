FROM python:3.15.2-alpine3.24
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY app.py entrypoint.sh ./
USER 65534:65534
EXPOSE 8000
ENTRYPOINT ["/app/entrypoint.sh"]
