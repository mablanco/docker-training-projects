# Exercise 04

**Level:** Advanced · **Concepts:** building a complex PHP app image, entrypoint scripts, volumes for state, Docker Compose

## Problem definition

[Nextcloud](https://nextcloud.com/) is a self-hosted platform to store, share and edit files. It is a large PHP application, with many requirements: several PHP extensions, specific PHP settings, a database, a cache and a scheduler for its background jobs. Nextcloud publishes an official image, but building your own is a good way to learn what it takes to containerize an application like this.

Your task is to build a Nextcloud image without using the official one, and to deploy it with Docker Compose. The image must:

- be based on the official `php` image with Apache, in a PHP version supported by the Nextcloud release you choose;
- include the [PHP extensions and settings](https://docs.nextcloud.com/server/latest/admin_manual/installation/system_requirements.html) that Nextcloud needs;
- download a pinned Nextcloud release from <https://download.nextcloud.com/server/releases/> and verify its checksum;
- install Nextcloud automatically the first time it starts, with the database, the admin account and the trusted domains taken from environment variables, and skip the installation on the following starts.

The deployment (`compose.yaml`) must:

- run Nextcloud, MariaDB and Redis, each in its own container, with pinned image versions;
- configure Nextcloud to use Redis for caching and file locking;
- run the Nextcloud background jobs every 5 minutes in a separate container, with the same image;
- keep the configuration, the files uploaded by the users and the database in volumes;
- publish Nextcloud at <http://localhost:8004>.

## Deliverables

A `Dockerfile`, the scripts and configuration files it needs, and a `compose.yaml` file.

## How to check your solution

1. Run `docker compose up -d --build --wait`. The first start takes a few minutes: Nextcloud installs itself, and then the first run of the background jobs has to finish.
2. Open <http://localhost:8004> and log in with the admin account. Upload a file.
3. Go to *Administration settings → Overview*. There should be no errors. Without HTTPS, a warning about the `Strict-Transport-Security` header is expected.
4. Run `docker compose down` and `docker compose up -d --wait`. Nextcloud must start without installing itself again, and your file must still be there.
5. When you are done, run `docker compose down -v --rmi local`.

`sol/test.sh` checks steps 1, 2 and 4 automatically for the reference solution, using WebDAV to upload the file.

## Hints

- The official `php` image comes with helpers to install extensions: `docker-php-ext-install` for the bundled ones and `pecl` for the rest. The [`install-php-extensions`](https://github.com/mlocati/docker-php-extension-installer) script does both and also installs the system libraries each extension needs.
- `ADD --checksum` downloads a file and checks it. Doing it in a separate build stage keeps the tarball out of the final image.
- Nextcloud is managed from the command line with `occ`. Look at `occ maintenance:install` and `occ config:system:set`. Run it as the `www-data` user, the one that owns the files.
- An entrypoint script can do the first-time setup and then `exec` the command of the image, so the same image can run Apache or the background jobs.
- The code belongs to the image, but `config/` and `data/` hold state. What happens to them when you rebuild the image or recreate the container?
- Nextcloud installs only when the database accepts connections. A `healthcheck` in the database service and `depends_on` help with that.

## Going further

- Upgrade to the next Nextcloud release by changing the version in the `Dockerfile`, and make the entrypoint run `occ upgrade` when needed. The reference solution does it.
- Pass the passwords as [Compose secrets](https://docs.docker.com/compose/how-tos/use-secrets/) instead of environment variables.
- Put a reverse proxy with HTTPS in front of Nextcloud, such as Caddy or Traefik, and enable HSTS.
- Apps installed from the Nextcloud app store are written to the code directory, so they are lost when the container is recreated. Add a `custom_apps` directory in a volume and configure it in `apps_paths`.
