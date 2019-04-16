# Project 10

## Problem definition

When deploying an app, it's really important to monitor if it's properly working. In case it exposes a REST API, you can test the endpoints to make sure they reply with the expected answers.

In this project, you're required to build a Docker image that tests the endpoints from Project 09 app with the `pyresttest` tool (https://github.com/svanoort/pyresttest) and the provided YAML tests file.

Once built, you can test the image from the `tests` directory against the port of the server part of the app like this:
```
docker run --rm -v $PWD:/tests my-pyresttest http://<app_ip>:8000 tests.yaml
```

## Deliverables

A Dockerfile.
