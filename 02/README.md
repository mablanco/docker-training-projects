# Exercise 02

**Level:** Beginner · **Concepts:** official images, user-defined networks, volumes, environment variables

## Problem definition

Exercise 01 runs WordPress and MySQL in the same container. That goes against a basic Docker practice: each container should run a single service, so that each one can be updated, scaled and restarted on its own.

Your task is to deploy WordPress and MySQL in two containers, using their official images from Docker Hub. Write a shell script (`run.sh`) that:

- creates a network for both containers, so WordPress can reach MySQL by its container name;
- stores the MySQL data in a named volume, so it is not lost when the container is removed;
- configures both containers with environment variables (database name, user and password);
- publishes WordPress at <http://localhost:8002>.

Pin the image versions instead of using `latest`, so the script keeps working the same way in the future.

## Deliverables

A shell script (`run.sh`) that deploys both containers.

## How to check your solution

1. Run your script and open <http://localhost:8002>. MySQL needs some seconds to initialize the first time. Until it is ready, WordPress shows "Error establishing a database connection".
2. Once it is ready, you should see the WordPress installation page. Complete the installation and create a post.
3. Remove both containers (`docker rm -f <container> ...`) and run the script again, without deleting the volume. Your post should still be there.
4. When you are done, remove the containers, the network and the volume.

`sol/test.sh` checks the first two steps automatically for the reference solution.

## Hints

- `docker network create`, `docker volume create` and the `--network`, `-v` and `-e` options of `docker run`.
- The environment variables each image accepts are documented on its Docker Hub page: [wordpress](https://hub.docker.com/_/wordpress) and [mysql](https://hub.docker.com/_/mysql).
- The legacy `--link` option still appears in many tutorials. Don't use it: user-defined networks replace it.
