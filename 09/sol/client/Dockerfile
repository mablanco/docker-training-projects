FROM node:8-alpine
RUN apk add --update --no-cache subversion && \
    rm -rf /var/cache/apk/*
WORKDIR /app
RUN svn export --trust-server-cert --non-interactive https://github.com/testdrivenio/flask-vue-crud/trunk/client
WORKDIR /app/client
RUN grep -r -H "localhost:5000" * | cut -f 1 -d ":" | xargs sed -i 's/localhost\:5000/app-server:8000/g'
RUN npm install
EXPOSE 8080
ENV HOST='0.0.0.0'
CMD ["npm", "run", "serve"]
