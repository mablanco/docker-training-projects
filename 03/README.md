# Exercise 03

**Level:** Beginner · **Concepts:** Docker Compose, healthchecks, service dependencies

## Problem definition

Shell scripts are flexible, but as a deployment grows they become hard to maintain: you have to create and remove networks and volumes by hand, keep track of the order in which containers start, and clean everything up afterwards. Docker Compose describes the whole deployment in a single file and manages it for you.

Your task is to deploy exercise 02 (WordPress and MySQL in two containers) with Docker Compose. Write a `compose.yaml` file that:

- defines both services with pinned image versions;
- stores the MySQL data in a named volume;
- publishes WordPress at <http://localhost:8003>;
- starts WordPress only when MySQL is ready to accept connections, not just when its container has started.

## Deliverables

A `compose.yaml` file.

## How to check your solution

1. Run `docker compose up -d` in the directory of your `compose.yaml` and open <http://localhost:8003>. You should see the WordPress installation page straight away, without the "Error establishing a database connection" message from exercise 02.
2. Complete the installation and create a post.
3. Run `docker compose down` and then `docker compose up -d` again. Your post should still be there.
4. When you are done, run `docker compose down -v` to remove the containers, the network and the volume.

`sol/test.sh` checks the first step automatically for the reference solution.

## Hints

- Compose creates a network for the project by default, and services reach each other by service name.
- `depends_on` on its own only waits for the container to start. Look at its long syntax and at the `healthcheck` attribute.
- The top-level `version` attribute that many tutorials still use is obsolete. Compose ignores it.
