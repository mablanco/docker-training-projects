# Exercise 07

**Level:** Beginner · **Concepts:** writing a Dockerfile, installing packages, foreground processes, logs, bind mounts

## Problem definition

Docker makes it easy to test and deploy websites: you only need a web server and a language interpreter inside a container, and the website's files, which can be part of the image or mounted from your machine.

In this exercise you have to build that image yourself, starting from a plain Debian image, with Apache as the web server and PHP as the language. The image must:

- install Apache and its PHP module from the distribution's packages, keeping the image as small as you reasonably can;
- include an `index.php` file that calls the `phpinfo()` function, as the default page;
- run Apache in a way that keeps the container running;
- send Apache's access and error logs to the container's output, so they show up in `docker logs`.

## Deliverables

A Dockerfile and an `index.php` file.

## How to check your solution

1. Build your image and run a container that publishes port 80 on a port of your machine, for example 8007.
2. Open <http://localhost:8007>. You should see the PHP information page.
3. Run `docker logs <container>`. You should see the request you just made.
4. Create a directory with a different `index.php` and run a new container with that directory mounted on Apache's document root (`/var/www/html`). The new page should replace the one in the image, and changes to the file should show up when you reload.

`sol/test.sh` checks all of this automatically for the reference solution.

## Hints

- Clean up the package manager's cache in the same `RUN` instruction that installs the packages. Otherwise it stays in the image's layers.
- A container lives as long as its main process. Look for the option that makes Apache stay in the foreground.
- The official [`httpd`](https://hub.docker.com/_/httpd) and [`php`](https://hub.docker.com/_/php) images write their logs to the container's output by linking the log files to `/dev/stdout` and `/dev/stderr`.

## Going further

In practice you would usually start from the official `php:<version>-apache` image, which already has Apache, PHP and its logs set up. Compare its size and its Dockerfile with yours.
