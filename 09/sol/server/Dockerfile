FROM python:3.15.0-alpine3.24

# The app, pinned to the last commit of its repository.
ADD https://github.com/testdrivenio/flask-vue-crud.git#be91da59a10d07384537c2f76f4505eb344d1682:server /app
WORKDIR /app

# The app pins Flask 2.2, which breaks with Werkzeug 3, so Werkzeug is
# capped. gunicorn is the production WSGI server.
RUN pip install --no-cache-dir -r requirements.txt "Werkzeug<3" gunicorn==26.2.0 && \
    adduser -D -H app
USER app

EXPOSE 5000
# A single worker: the app keeps the books in memory, and each worker
# process would have its own copy.
CMD ["gunicorn", "--workers", "1", "--threads", "4", "--bind", "0.0.0.0:5000", "app:app"]
