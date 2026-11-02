# Exercise 17

**Level:** Intermediate · **Concepts:** PID 1, signals, `exec`, exec and shell forms, zombie processes, init processes, healthchecks

## Problem definition

When Docker stops a container, it sends a `SIGTERM` signal to its main process, the one with PID 1, and waits 10 seconds by default. If the container is still running by then, Docker kills it with `SIGKILL`, which cannot be caught. A service that is killed this way does not get the chance to finish its ongoing requests, close its connections or flush its data. Orchestrators like Kubernetes or Docker Swarm stop containers all the time, on every deployment and every scale-down, so this matters.

The files in `src/` build a small Python web service. The service itself is well written: it handles `SIGTERM` and shuts down gracefully, printing a message. It also starts background jobs (`/report`) the way many tools do, with a shell that exits right away and leaves the job running on its own. The `run.sh` script builds and runs it, publishing it at <http://localhost:8017>.

However, the way it is packaged has problems:

- `docker stop graceful-app` takes 10 seconds, the container exits with code 137, and the service never prints its shutdown message;
- Docker has no way to know whether the service is actually working.

Change the packaging, not `app.py`, so that:

- `docker stop` stops the container in less than a couple of seconds, with exit code 0, and the service prints `Received SIGTERM, shutting down gracefully`;
- the finished background jobs do not stay as zombie processes;
- Docker reports the container as `healthy` when the service answers at `/health`.

## Deliverables

The fixed `Dockerfile` and `entrypoint.sh`.

## How to check your solution

1. Run the image and wait a few seconds. `docker ps` must show the container as `(healthy)`.
2. Open <http://localhost:8017/report> several times, wait two seconds and run `docker exec graceful-app ps -o pid,stat,comm`. No process should be in the `Z` (zombie) state.
3. Run `time docker stop graceful-app`. It must take less than a couple of seconds, and `docker logs graceful-app` must end with the shutdown message.
4. `docker inspect graceful-app --format '{{.State.ExitCode}}'` must print `0`.

`sol/test.sh` checks that the starting image is killed when it is stopped, and that the reference solution passes the steps above.

## Hints

- Run `docker exec graceful-app ps -o pid,comm`. Which process has PID 1? Which one receives the `SIGTERM`?
- Look at what the `exec` shell builtin does, and at the difference between the exec form (`["cmd", "arg"]`) and the shell form (`cmd arg`) of `CMD` and `ENTRYPOINT`.
- Once you fix the signals, check the zombie processes again. When a process ends, its parent must collect its exit status. A process whose parent has died is adopted by PID 1, so PID 1 must do that for all of them. Most applications do not.
- That is the job of a minimal init process such as [tini](https://github.com/krallin/tini), which is what `docker run --init` adds. It can be part of the image too, so it does not depend on how the container is run.
- Look at the `HEALTHCHECK` instruction. The image already has `wget`, from BusyBox. Inside the container, `localhost` may resolve to the IPv6 address `::1`, while this service only listens on IPv4.

## Going further

- Some services stop gracefully with another signal, like `SIGQUIT` for Nginx or `SIGWINCH` for Apache. Look at the `STOPSIGNAL` instruction.
- A service that needs more than 10 seconds to stop can get more time with `docker stop -t`, `stop_grace_period` in Compose or `terminationGracePeriodSeconds` in Kubernetes.
- Add the same healthcheck to a Compose file and make another service wait for it with `depends_on` and `condition: service_healthy`, as in exercise [03](../03).
