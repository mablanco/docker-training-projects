# Docker training projects

Hands-on exercises to learn Docker by solving small, realistic problems. They are meant both for people learning Docker on their own and for teachers who want ready-made exercises for their courses. Everything is licensed under GPLv3, so feel free to use and adapt it.

> **Work in progress:** the exercises date from 2019 and are being updated to current Docker practices one by one. The ones marked ✅ in the index below are already updated and tested in CI every week.

## How each exercise is organized

Each exercise lives in a numbered directory:

- `README.md`: the problem to solve, the deliverables, and how to check that your solution works.
- `src/` (optional): files you start from.
- `sol/`: one possible solution. There are usually several valid ones, so treat it as a reference, not as the only answer.
- `sol/test.sh`: a script that builds and runs the solution and checks that it works. CI runs it on every change.

The goal is to find a simple, working solution to the problem as stated. Features like volumes or extra containers are only needed when the problem asks for them.

## Requirements

- Docker Engine with the Compose plugin (`docker compose`), or Docker Desktop.
- Bash, to run the `run.sh` and `test.sh` scripts.
- An internet connection, to pull images and packages.

## For learners

1. Pick an exercise from the index. The level gives an idea of the order, but the exercises in a sequence (02 → 03, 08 → 09 → 10) build on each other.
2. Read its `README.md` and try to solve it without looking at `sol/`.
3. Check your solution with the steps in the exercise's README.
4. Compare it with the one in `sol/`. If yours is different but works, that's fine.

## For teachers

- Each exercise is self-contained and can be handed out as is: give students the exercise's `README.md` and `src/` directory.
- The concepts column in the index helps to match exercises to the topics of each session.
- `sol/test.sh` checks a solution automatically. You can adapt it to check your students' solutions.
- Suggestions and new exercises are welcome (see [How to contribute](#how-to-contribute)).

## Index of exercises

| # | Exercise | Level | Concepts | Updated |
|---|----------|-------|----------|---------|
| [01](01) | Fix the build of an image of a complete WordPress installation | Beginner | Dockerfile, reading build errors | |
| [02](02) | Deploy WordPress and MySQL in two containers | Beginner | Official images, networks, environment variables | |
| [03](03) | Orchestrate exercise 02 with Docker Compose | Beginner | Docker Compose | |
| [04](04) | Deploy a development/testing environment for Magento 2 (to be replaced by Nextcloud) | Advanced | Building a complex PHP app image | |
| [05](05) | Deploy an Nginx reverse proxy in front of two web servers with different PHP versions | Intermediate | Several images, networks, reverse proxy | |
| [06](06) | Build a monitoring image that runs `atop` in the host PID namespace | Intermediate | Namespaces, `--pid host` | ✅ |
| [07](07) | Build an Apache web server image with PHP support | Beginner | Dockerfile, volumes | |
| [08](08) | Build the image of a Flask app for a development environment | Beginner | Language images, dependencies | |
| [09](09) | Deploy a CRUD app based on Flask and Vue.js with Docker Compose in production | Advanced | Several images, production servers, Docker Compose | |
| [10](10) | Test the endpoints of the exercise 09 app (moving from pyresttest to Hurl) | Intermediate | Tooling images, testing APIs | |
| [11](11) | Design a multi-stage image that builds and runs a simple Go app | Intermediate | Multi-stage builds, minimal images | |

## Note on security

To keep the focus on the problem being solved, passwords and credentials in these exercises are written in clear text.

Never do this in production or in any sensitive environment. Use a secrets management solution instead, such as Docker secrets, BuildKit build secrets, HashiCorp Vault or your cloud provider's secret manager.

## How to contribute

New exercises and improvements are welcome. To keep the repository consistent:

1. Create a directory named with the next number after the last one in the repository.
2. Add a `README.md` with the problem, the expected deliverables and how to check the solution. Use an existing exercise as a template.
3. Add any starting files in `src/` and a working solution in `sol/`.
4. Add a `sol/test.sh` script that builds and runs the solution and fails if it doesn't work, and add the exercise to the matrix in `.github/workflows/exercises.yml`.
5. Add the exercise to the index above, with your name and a contact email or URL in parentheses.

Solution Dockerfiles are linted with [hadolint](https://github.com/hadolint/hadolint) using the rules in `.hadolint.yaml`.

## License

GPLv3
