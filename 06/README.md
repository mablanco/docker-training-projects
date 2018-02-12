# Project 06

## Problem definition

Monitoring has always been one of the most outstanding tasks in the daily tasks of a sysadmin, but its importance is usually neglected. Nowadays, thanks to the DevOps movement, monitoring is getting more and more visibility and is currently regarded as one of the basic pillars in any IT infrastructure.

There are many CLI monitoring tools that are so nice and powerful that you'd like to have them available for each and every platform under your management. However, because of the inherent heterogeneity of any IT system, made up of on-premise servers, cloud instances, network devices, etc., this is not usually possible.

Docker to the rescue! Today, Docker is supported by many platforms, even by several networking brands. That way, you could build a monitoring container that includes your favourite CLI tools and deploy them wherever you need them.

In this project, your task is to design and build an image that hosts several monitoring tools from the `*top` family. Then, deploy a container that, by default, runs `atop` in the host namespace.

## Deliverables

A Dockerfile for the image and a shell script to build and run the container.
