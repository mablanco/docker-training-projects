# Docker training projects

## Purpose

This repository hosts projects that I've been using as exercises in my Docker training courses. Feel free to use them under the GPLv3 license.

Each directory includes a problem description (`README.md`), a possible solution for it (`sol` folder) and optionally source files as part of the problem description (`src` folder).

The goal of these projects is to look for and find a simple and feasible solution for the proposed problem. Therefore, features like volumes and container linking are only used if needed or asked for.

## How to contribute

If you wish to contribute with your own projects (which I greatly encourage), please follow these guidelines in order to keep some coherence in this repository:

1. Create a directory and name it with the following number after the last one currently present in the repo.
2. Include a README.md file explaining the problem to be solved and the deliverables expected.
3. Add any source files needed.
4. Add the files that make up a feasible solution.
5. Add a short description of the project to the list below, adding your name and contact email or URL in parenthesis.

## Note on security

Please be warned that, in order to not distract the student from solving the specific proposed problem, all the passswords and credentials are included in clear text.

This SHOULD NEVER be done in production and/or sensitive environment, where a credentials management solution should be used, like Docker Secrets, Hashicorp's Vault, Keywhiz, Ansible Vault, etc.

## Index of projects

1. Fix the build of an image of a complete Wordpress installation.
2. Deploy Wordpress and MySQL in two containers.
3. Orchestrate project 02 with Docker Compose.
4. Deploy a development/testing environment for Magento 2.
5. Deploy a Nginx-based reverse proxy in front of two webservers with different PHP versions.
6. Deploy a monitoring container that runs 'atop' in the host namespace.
7. Deploy an Apache webserver with PHP7 support.
8. Build the image of a Flask app to be run in a development environment.
9. Clone and deploy a CRUD app, based on Flask and Vue.js, with Docker Compose in production (work in progress).
10. Launch automatic tests of endpoints against the previous Flask app.
11. Design a multi-stage image that builds and deploys a simple Golang app.

## License

GPLv3
