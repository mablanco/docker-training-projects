# Exercise 01

**Level:** Beginner · **Concepts:** Dockerfile, image layers, reading build errors

## Problem definition

The files in `src/` build an image that runs a complete WordPress installation in a single container: Apache, PHP and MariaDB, all started by [Supervisor](https://supervisord.org/). The `run.sh` script builds the image and runs it, publishing WordPress at <http://localhost:8001>.

However, the build fails. Find the cause and fix it, so that the container runs and WordPress is accessible from a web browser.

## Deliverables

A fixed `Dockerfile`.

## How to check your solution

1. Run `src/run.sh`. The build must finish and the container must start.
2. Open <http://localhost:8001>. You should see the WordPress installation page, not "Error establishing a database connection".
3. When you are done, remove the container and the image (`docker rm -f wordpress-allinone`, `docker rmi wordpress-allinone`).

`sol/test.sh` checks that the starting `Dockerfile` still fails, and that the reference solution builds and shows the installation page.

## Hints

- Read the build output from the bottom up. Which instruction failed, and what was the error message?
- What does each `RUN` instruction start from, and what is left of it when it finishes?

## Going further

Running several services in one container, and creating the database at build time, makes the image hard to update and loses the data when the container is removed. Exercises [02](../02) and [03](../03) deploy the same application the Docker way: one service per container, with the data in a volume.
