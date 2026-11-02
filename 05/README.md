# Exercise 05

**Level:** Intermediate · **Concepts:** several images, user-defined networks, reverse proxy, name-based virtual hosts

## Problem definition

One of the best uses of Docker is setting up test environments. For example, it's easy to check how a web app behaves with different versions of its language, without installing any of them on your machine.

In this exercise you have to deploy two PHP web servers, one with the oldest PHP version that is still supported and one with the newest (PHP 8.3 and 8.5 at the time of writing). An `index.php` file that calls the `phpinfo()` function is enough as the app. An Nginx reverse proxy sits in front of both and is the only container published on your machine. That makes three containers in total.

The proxy forwards each request to one web server or the other depending on the host name in the URL:

- <http://php83.localhost:8005> → the PHP 8.3 web server
- <http://php85.localhost:8005> → the PHP 8.5 web server
- any other host name → a 404 error

Write a shell script (`run.sh`) that builds the three images and runs the three containers on a user-defined network.

## Deliverables

A shell script and one directory per image: `nginx` with a Dockerfile and the Nginx configuration, and one per PHP version with a Dockerfile and an `index.php` file.

## How to check your solution

1. Run your script and open <http://php83.localhost:8005> and <http://php85.localhost:8005>. Each page should show its PHP version at the top.
2. Open <http://other.localhost:8005>. You should get a 404 error.
3. Check with `docker ps` that only the proxy container publishes a port.
4. When you are done, remove the containers and the network.

`sol/test.sh` checks the first two steps automatically for the reference solution.

## Hints

- Browsers and `curl` resolve any `*.localhost` name to your own machine, so you don't need to edit `/etc/hosts`.
- The official [`php`](https://hub.docker.com/_/php) image has variants with Apache already set up (`<version>-apache`).
- Nginx chooses a `server` block by comparing its `server_name` with the `Host` header of the request. Look at the `default_server` parameter of `listen` for the requests that match no name.
- Nginx resolves the host names in `proxy_pass` when it starts. Think about the order in which the containers have to start.

## Going further

Rewrite the script as a `compose.yaml` file, as in exercise 03.
