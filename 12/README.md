# Exercise 12

**Level:** Intermediate · **Concepts:** non-root users, read-only filesystems, Linux capabilities, unprivileged ports

## Problem definition

By default, the main process of most containers runs as root. Containers isolate it from the host, but if someone exploits a vulnerability in the application, root inside the container makes it much easier to do damage or to escape. That is why many platforms, Kubernetes clusters with restrictive policies and OpenShift among them, refuse to run containers as root, and often also remove all Linux capabilities and mount the container filesystem read-only.

The files in `src/` build an image that serves a static website with Nginx. The `run.sh` script builds and runs it, publishing it at <http://localhost:8012>, and it works. However, it fails as soon as it runs with the restrictions of a hardened platform:

```bash
docker run -d --name hardened-site \
  --read-only --tmpfs /tmp \
  --cap-drop ALL --security-opt no-new-privileges \
  -p 8012:8080 hardened-site
```

Change the image so that it works with those options:

- the image must run as a non-root user, set with a numeric UID;
- Nginx must listen on port 8080 inside the container;
- the only writable path is `/tmp`, an in-memory filesystem (`tmpfs`);
- the access and error logs must still reach `docker logs`.

## Deliverables

A `Dockerfile` and any configuration file it needs.

## How to check your solution

1. Build the image, run it with the command above and open <http://localhost:8012>. You should see the website.
2. Run `docker exec hardened-site id`. The user must not be root.
3. Run `docker logs hardened-site`. You should see the requests you made.
4. Remove the container and run the image again adding `--user 12345:0`. The website must still work: some platforms, like OpenShift, run containers with an arbitrary UID instead of the one in the image.
5. When you are done, remove the container and the image.

`sol/test.sh` checks that the starting image fails with these options, and that the reference solution passes the steps above.

## Hints

- Run the starting image with the options above, without `-d`, and read the error. Then try again with only some of the options to see which one breaks what.
- The official Nginx image already has an unprivileged user. Look at `/etc/passwd` inside it.
- Nginx writes a PID file and several temporary directories at runtime. All their paths can be set in `nginx.conf`.
- Why would `USER nginx` be less useful than `USER 101` for a platform that must check that a container does not run as root?
- Docker sets `net.ipv4.ip_unprivileged_port_start=0` inside containers, so binding port 80 works without root there. Other runtimes and Kubernetes nodes do not always do that, which is why images built to run without root listen on ports above 1024.

## Going further

- Compare your image with the official [`nginxinc/nginx-unprivileged`](https://hub.docker.com/r/nginxinc/nginx-unprivileged) image.
- Write a Compose file that runs the image with the same restrictions (`read_only`, `tmpfs`, `cap_drop`, `security_opt`, `user`).
- Apply the same restrictions to the images of other exercises, such as [09](../09) or [11](../11). Which ones work as they are?
