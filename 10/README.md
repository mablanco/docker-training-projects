# Exercise 10

**Level:** Intermediate · **Concepts:** tooling images, `ENTRYPOINT` and `CMD`, container networking, API testing

## Problem definition

When you deploy an app, you need to check that it works. If it exposes a REST API, you can test its endpoints and make sure they answer as expected. Running those tests in a container means anyone can run them, in CI or on their machine, without installing anything but Docker.

In this exercise you have to build a Docker image that tests the API of the exercise 09 app with [Hurl](https://hurl.dev), using the tests file provided in `src/tests.hurl`. The image must:

- be based on the official Hurl image;
- include the tests file, so it can run on its own;
- run the tests by default when a container starts, and accept other Hurl options or files when they are passed to `docker run`;
- test the app at `http://client/api` by default (the Nginx service of exercise 09), and accept another address through an environment variable.

Then run it against the exercise 09 app.

## Deliverables

A Dockerfile.

## How to check your solution

1. Start the exercise 09 app: run `docker compose up -d --build` in its `sol` directory (or in your own solution's).
2. Build your image in the directory that contains your Dockerfile and `tests.hurl`.
3. Run a container from your image, connected to the app's Compose network. You can find the network's name with `docker network ls`. All the tests should pass:

   ```text
   Success tests.hurl (8 request(s) in 26 ms)
   ```

4. Stop the app and run the tests again. They should fail.

`sol/test.sh` does all of this automatically for the reference solution.

## Hints

- Look at the official image's `ENTRYPOINT` with `docker image inspect`, and at how `ENTRYPOINT` and `CMD` work together.
- `hurl --test` runs the files in test mode and returns a non-zero exit code if any test fails.
- Hurl reads variables such as `{{base_url}}` from environment variables named `HURL_VARIABLE_<name>`.
- Containers on the same network reach each other by service or container name. `localhost` inside the test container is the container itself, not your machine.
