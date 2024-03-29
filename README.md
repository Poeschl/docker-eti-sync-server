# Dockerized eti Sync Server

This is a dockerized version of the [Sync Server of the eti Lan Tools](https://www.eti-lan.xyz/sync_server.php).
It will start the sync server inside a docker container and provides them locally to any installed eti [Lan-Launcher](https://www.eti-lan.xyz/).

## Setup

As a requirement for a successful operation make sure to have a __linux__ system and a __docker__ or a __rootful podman__ installation running.
Since systemd is running inside the container we need those privileges (PRs to change welcome).

To make the setup as easy as possible a docker-compose.yaml is provided.
Download it to a new folder and execute `podman-compose up -d` to run it in daemon mode in the background.
The UI should be available under http://localhost:8888 and your hosts ip in the local network.
(For the login look in the next section)

## Auth

When logging into the container the authentication is:

User: `root`

Password: `lan`

This is the same as the default web-ui password. This can be changed via the custom config file `eti-config.conf`.

## FAQ

### I get a `Read-only file system` in the system logs after startup and no web ui is available

This could be due the filesystem share between windows and the WSL, therefor Windows is not supported.
It can be "fixed" by letting docker manage the storage be commenting out the volume line in the docker-compose.
