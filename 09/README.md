# Exercise 09

**Level:** Advanced · **Concepts:** multi-stage builds, production servers, reverse proxy, Docker Compose

## Problem definition

A development setup is not suitable for production. Python apps should not be served with the interpreter's built-in server, but with a production WSGI server such as **gunicorn**. Frontend apps built with tools like Vite should not run their development server either: they are compiled into static files and served by a web server such as **Nginx**.

In this exercise you have to deploy a CRUD app made of a Flask API (backend) and a Vue.js frontend. The code is in the [testdrivenio/flask-vue-crud](https://github.com/testdrivenio/flask-vue-crud) repository, in its `server` and `client` directories.

Write a Dockerfile for each part and a `compose.yaml` file that deploys them, so that:

- the backend runs with gunicorn;
- the frontend is compiled in one stage of a multi-stage build, and the final image only contains Nginx and the compiled files;
- Nginx serves the frontend at <http://localhost:8080> and forwards the API requests to the backend under the `/api` path, so the backend doesn't need to be published on any port;
- the images get the app's code from a fixed commit of its repository, so they always build the same app.

## Deliverables

A Dockerfile for the frontend, a Dockerfile for the backend, an Nginx configuration file and a `compose.yaml` file.

## How to check your solution

1. Run `docker compose up -d --build` and open <http://localhost:8080>. You should see a book collection management app with three books.
2. Add a book, edit it and delete it. Reload the page after each change: the list should always show the latest state.
3. Open <http://localhost:8080/api/books>. You should get the list of books in JSON.
4. When you are done, run `docker compose down`.

`sol/test.sh` checks the frontend, the API through Nginx and that added books are kept, for the reference solution.

## Hints

- `ADD` can get files straight from a Git repository, including a specific commit and subdirectory, with no need to install Git in the image.
- The frontend calls the API at `http://localhost:5001`. You need to change that address in the source code before compiling it.
- In `proxy_pass`, a trailing slash after the address makes Nginx remove the matching location prefix (`/api/`) from the forwarded request.
- The app uses HTML5 history routing (paths like `/ping`). Nginx has to answer unknown paths with `index.html`.
- The backend keeps the books in memory, inside the Python process. Think about what happens if gunicorn runs several worker processes.
- The app pins Flask 2.2, which doesn't work with Werkzeug 3. Look at the error the backend logs if it doesn't start.
