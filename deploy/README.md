# Docker installation

Use the following points to set up the docker installation:

1. Ensure you have Docker and Docker Compose installed on your system.
    You can follow the official [Docker installation guide](https://docs.docker.com/get-docker/) for your operating system.
2. Adjust the `.env` and the `docker-compose.yaml` files as needed.
3. Replace `<host-ip>` in the `eti-config.conf` file with the actual IP address of your host machine.
4. Start the stack with `docker-compose up -d`. This will run the containers in detached mode.
5. The Resilio Sync Web UI should now be accessible at `http://<host-ip>:8888` or `http://localhost:8888` if you are running it locally.
