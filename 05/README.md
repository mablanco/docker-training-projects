# Project 05

## Problem definition

One of the best use cases for Docker is the deployment of testing environments. For example, it's really easy to test webapps based on different programming languages and/or versions.

In this project, you're required to deploy two PHP apps, one under version 5.x and one under 7.x. An `index.php` file calling the `phpinfo()` function is enough for this project.  Access to both webservers will be managed by a reverse proxy (use Nginx for that). Therefore, you'll need three containers.

Once deployed, the webapps will be accessed through the following URLs:

- <http://php5>
- <http://php7>

Ypu will need to add the following line to your `/etc/hosts` file in order to be able to open those webpages:

`127.0.2.1 php5 php7`

## Deliverables

A shell script and three folders per container, each  hosting a Dockerfile and an index.php file.
