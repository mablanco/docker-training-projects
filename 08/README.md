# Exercise 08

**Level:** Beginner · **Concepts:** language images, layer caching, bind mounts, development environments

## Problem definition

Docker makes Python development and testing easier: everyone on the team gets the same Python version and dependencies, without installing anything on their machine but Docker. During development, though, you don't want to rebuild the image every time you change a line of code.

In this exercise you have to build a Docker image for a development environment of a small Flask app. Use the `app.py` and `requirements.txt` files provided in `src/`. The image must:

- be based on an official Python image;
- install the dependencies in a way that doesn't reinstall them on every code change when the image is rebuilt;
- run the app with Flask's development server in debug mode, listening on port 5000.

Then run a container from it with the code mounted from your machine, so that changes to `app.py` are applied without rebuilding the image or restarting the container.

## Deliverables

A Dockerfile.

## How to check your solution

1. Build your image in the directory that contains your Dockerfile, `app.py` and `requirements.txt`.
2. Run a container that publishes port 5000 and mounts that directory on the app's directory in the container.
3. Make a GET request to <http://localhost:5000/>. You should get `"Hello World"`.
4. Change the message in `app.py` and save it. After a second or two, the same request should return the new message.
5. Rebuild the image after changing only `app.py`. The step that installs the dependencies should come from the cache.

`sol/test.sh` checks steps 3 and 4 automatically for the reference solution.

## Hints

- Docker rebuilds a layer when its instruction or the files it copies change, and every layer after it. Think about the order of `COPY` and `RUN`.
- `flask run --help` lists the options of the development server. By default it only listens on `127.0.0.1`, which can't be reached from outside the container.
- Look at what Python writes into the code directory when it runs, and who owns those files on your machine.
- On macOS, port 5000 may be taken by the AirPlay receiver. Publish the app on another host port if it is.
