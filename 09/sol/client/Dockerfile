# Build stage: compile the Vue app into static files.
FROM node:26.13.0-alpine3.24 AS build
ADD https://github.com/testdrivenio/flask-vue-crud.git#be91da59a10d07384537c2f76f4505eb344d1682:client /app
WORKDIR /app
# The app calls the API at http://localhost:5001. Point it to /api on the
# same origin instead, which Nginx forwards to the server.
RUN sed -i 's|http://localhost:5001|/api|' src/components/*.vue && \
    npm ci && \
    npm run build

# Final stage: only Nginx and the compiled files.
FROM nginx:1.30.6-alpine3.24
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
