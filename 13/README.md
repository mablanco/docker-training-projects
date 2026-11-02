# Exercise 13

**Level:** Intermediate · **Concepts:** BuildKit build secrets, build arguments, image history, image layers

## Problem definition

Builds often need credentials: a token to download a private package, a dataset or a licensed file. Passing them as build arguments is the first idea that comes to mind, and it works, but it leaves the credential in the image. Anyone who can pull the image can read it with `docker history`, and a credential written to a file can stay in a layer even if a later instruction deletes it.

The files in `src/` simulate this situation. The `run.sh` script:

1. starts a private artifact server with a new random token, saved in the `artifacts-token` file;
2. builds an image whose `Dockerfile` downloads a dataset from that server, passing the token as a build argument;
3. runs the image, which prints the dataset.

Run it and then look at `docker history --no-trunc private-data`: the token is there.

Change the `Dockerfile` and the `docker build` command in `run.sh` so that the image still downloads the dataset, but the token is not stored anywhere in the image.

## Deliverables

The fixed `Dockerfile` and `run.sh`.

## How to check your solution

1. Run your `run.sh`. It must print `Licensed dataset, version 1`.
2. Search the token, which is in the `artifacts-token` file, in `docker history --no-trunc private-data` and in `docker image inspect private-data`. It must not be there.
3. Search it in the layers too: `docker save private-data | tar -x -C <empty directory>`, and then look inside the layer archives.
4. When you are done, remove the server (`docker rm -f artifacts`), the image and the `artifacts-token` file.

`sol/test.sh` checks that the starting files leak the token, and that the reference solution passes the steps above.

## Hints

- Read the warnings at the end of the build output.
- Look at the `--secret` option of `docker build` and at the `RUN --mount=type=secret` instruction.
- A secret mount can expose the secret as a file under `/run/secrets/` or as an environment variable. Either way, it only exists while that `RUN` instruction runs.
- Changing the token does not invalidate the build cache, because BuildKit does not take secrets into account for it. Use `--no-cache` if you need to force the download again.

## Going further

- Pass the token as a secret with Docker Compose, with the `secrets` attribute of the `build` section.
- Some tools read their credentials from a file, like `~/.npmrc`, `~/.netrc` or `~/.pip/pip.conf`. Mount the secret at that path with the `target` option of the secret mount.
- To clone a private Git repository during a build, look at `RUN --mount=type=ssh` and the `--ssh` option of `docker build`, which forward your SSH agent instead of copying a key.
