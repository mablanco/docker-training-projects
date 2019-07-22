FROM python:3.7.3-alpine
RUN pip install gunicorn
RUN apk add --update --no-cache subversion && \
    rm -rf /var/cache/apk/*
WORKDIR /app
RUN svn export  --trust-server-cert --non-interactive https://github.com/testdrivenio/flask-vue-crud/trunk/server
WORKDIR /app/server
RUN pip install -r requirements.txt
EXPOSE 8000
ENTRYPOINT ["gunicorn", "-w", "2", "-b", "0.0.0.0", "app:app"]
