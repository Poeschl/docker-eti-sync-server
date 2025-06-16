# Dockerized eti Sync Server

This is a dockerized version of the [Sync Server of the eti Lan Tools](https://www.eti-lan.xyz/sync_server.php).
It will start the sync server inside a docker container and provides them locally to any installed eti [Lan-Launcher](https://www.eti-lan.xyz/).

## Differences to the original server running in a VM

* The container does not have any firewall functionality, but it prevents Resilio Sync from accessing the internet.
  This means that the sync server can only be used locally.
* The commands of the VM-based sync server are not available. 
  The server starts automatically in the container and shuts it down when the container stops, that's it.
* There is no auto-update of the sync-server container itself, you need to pull the latest image manually.
  However, the auto-update of the lan-launcher and its games works as usual.
  So the sync server will always be up-to-date with the latest games of the eti Lan Tools after a successful start.

## Setup

As a requirement for a successful operation make sure to have a __linux__ system and a __docker__ or a __rootful podman__ installation running.

Look at the [`deploy` folder's Readme](deploy/README.md) for setup instructions.

## Auth

The default login for the Resilio Sync Web UI is:

```
User: `root`
Password: `lan`
```

## FAQ

### I get a `Read-only file system` in the system logs after startup and no web ui is available

This could be due the filesystem share between windows and the WSL, therefor Windows is not supported.
It can be "fixed" by letting docker manage the storage be commenting out the volume line in the docker-compose.
