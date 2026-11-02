# Exercise 14

**Level:** Intermediate · **Concepts:** layer caching, instruction order, `.dockerignore`, BuildKit cache mounts, production dependencies

## Problem definition

A slow build is more than an annoyance: it slows down every change you test locally and every run of your CI pipeline. Most of the time, a build is slow because it repeats work it could reuse.

The files in `src/` build the image of a small Node.js app with Express. The `run.sh` script builds and runs it, publishing it at <http://localhost:8014>. It works, but its `Dockerfile` has several problems that a team working on it every day would notice:

- any change in the code, even a single line, reinstalls all the dependencies;
- everything in the directory is sent to the builder, including the `node_modules` directory that developers have after running `npm install` on their machines;
- the dependencies are downloaded from the npm registry again every time they change, even the ones that did not change;
- the image includes the development dependencies, such as `nodemon`, which are not needed to run the app.

Change the `Dockerfile` so that the build avoids those problems, and add any file it needs.

## Deliverables

A `Dockerfile` and a `.dockerignore` file.

## How to check your solution

1. Run `npm install` with your local Node.js, or create a big `node_modules` directory by hand to simulate it.
2. Build the image with `docker build --progress=plain -t fast-build .`. Look at the size of the build context in the output (`transferring context`).
3. Change the message in `server.js` and build again. The step that installs the dependencies must show `CACHED`.
4. Run the image and check that it serves the new message, and that `node_modules/nodemon` does not exist in it (`docker run --rm fast-build ls node_modules`).
5. When you are done, remove the container and the image.

`sol/test.sh` checks that the starting `Dockerfile` reinstalls the dependencies when the code changes, and that the reference solution passes the steps above.

## Hints

- Docker reuses the cache of an instruction only if the instruction, and everything before it, did not change. For `COPY`, that includes the content of the copied files.
- Which files does `npm` need to install the dependencies? Copy those first, install, and copy the rest of the code after.
- `npm ci` installs exactly what `package-lock.json` says, and fails if it does not match `package.json`. `npm install` may update the lock file.
- Look at `RUN --mount=type=cache` and at where npm keeps its download cache.
- `NODE_ENV=production` and `npm ci --omit=dev` leave the development dependencies out.

## Going further

- Compare the time and the size of the build context before and after your changes.
- Use a multi-stage build: a stage that installs all the dependencies and runs the tests, and a final stage with only the production ones.
- Share the build cache in CI with `docker buildx build --cache-to` and `--cache-from`, for example with the GitHub Actions cache (`type=gha`).
