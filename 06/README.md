# Exercise 06

**Level:** Intermediate · **Concepts:** namespaces, `--pid host`

## Problem definition

Monitoring has always been one of the most important daily tasks of a sysadmin, but its importance is often neglected. Thanks to the DevOps movement, monitoring now gets much more attention and is regarded as one of the basic pillars of any IT infrastructure.

There are many CLI monitoring tools so useful that you'd like to have them available on every platform you manage. However, IT systems are heterogeneous (on-premise servers, cloud instances, network devices…), so this is not usually possible.

Docker to the rescue! Docker runs on many platforms, so you can build a monitoring image that includes your favourite CLI tools and run it wherever you need it.

In this exercise, your task is to design and build an image that includes several monitoring tools from the `*top` family. Then, run a container that, by default, runs `atop` in the host PID namespace, so it shows the host's processes instead of only the container's.

## Deliverables

A Dockerfile for the image and a shell script (`run.sh`) to build and run the container.

## How to check your solution

Run your script. `atop` should start and list the host's processes (for example, your Docker daemon or your desktop applications), not just `atop` itself. Press `q` to quit.

`sol/test.sh` checks this automatically for the reference solution.
