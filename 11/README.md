# Exercise 11

**Level:** Intermediate · **Concepts:** multi-stage builds, static binaries, minimal images, non-root users

## Problem definition

Compiled languages such as Go need a whole toolchain to build the app, but not to run it. If the final image includes the toolchain, it is hundreds of megabytes bigger than needed, and every extra package is something more to update and a potential vulnerability.

In this exercise you have to build a multi-stage image for a small Go web server. Use the `main.go` and `go.mod` files provided in `src/` (the code is based on an example from <https://hackernoon.com/how-to-create-a-web-server-in-go-a064277287c9>). The image must:

- compile the code in a first stage, using an official Go image;
- copy only the resulting binary to the final image, which should be as small as possible (under 20 MB);
- not run as root;
- start the web server, which listens on port 8080.

## Deliverables

A Dockerfile.

## How to check your solution

1. Build your image in the directory that contains your Dockerfile, `main.go` and `go.mod`, and check its size with `docker image ls`.
2. Run a container that publishes port 8080 and open <http://localhost:8080/Docker>. You should get `Hello Docker`.
3. Check the user the image runs as with `docker image inspect --format '{{.Config.User}}' <image>`. It should not be empty or `root`.

`sol/test.sh` checks all of this automatically for the reference solution.

## Hints

- Each `FROM` starts a new stage, and `COPY --from=<stage>` copies files from a previous one.
- `scratch` is an empty image: no shell, no C library, no users. Find out which Go build setting produces a binary that doesn't need a C library.
- Without a shell, you can't use `RUN` in the final stage. `USER` also accepts a numeric ID, which doesn't need to exist in `/etc/passwd`.
