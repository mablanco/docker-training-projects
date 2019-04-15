# Project 09

## Problem definition

When deploying a Python app in production, you should never use the Python interpreter itself to run the app. Instead, use a production WSGI server like **gunicorn**. Similarly, Node.js apps should be accessed through a web server or a reverse proxy.

In this project, you're required to deploy a CRUD app based on Flask and Vue.js. Clone the app from the <https://github.com/testdrivenio/flask-vue-crud> Github repo.

Test the app by opening <http://localhost:8080/books> in your browser. You should see a list of books. Then, try to add and delete some entries.

## Deliverables

A Dockerfile for the frontend, a Dockerfile for the backend and a docker-compose.yml file.
