# Transmission

<p align="center">
    <img src="logo.png" width="400">
</p>

Transmission is a lightweight BitTorrent client with Web interface.

## Installation

First, execute

```
docker build -t cusdeb.com:5000/transmission:2_92_armhf .
docker-compose up -d
```

Then, go to `http://[Device IP Address]:8003`. You will be asked to enter a username and password. By default, in both cases it's `cusdeb`. It's highly recommended to change it in `docker-compose.yml`. See the [Configuration](#configuration) section.

## Uninstallation

First, stop the Transmission container by executing
```
docker stop transmissionweb_transmission-web_1
```

If for some reason Docker says something like `Error response from daemon: No such container: transmissionweb_transmission-web_1`, execute

```
docker ps
```

and find the container name and execute `docker stop` again.

Then, remove the container by executing

```
docker rm transmissionweb_transmission-web_1
```

Note that you have to manually remove the directory intended for downloads which is located in `/srv/common`.

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter | Description | Default |
| --- | --- | --- |
| ALLOWED  | Allowed IP addresses. By default, you can reach the Web interface only from the local network | `192.168.*.*` |
| AUTH     | Whether authentication is required | `true` |
| LOGIN    | User login | `cusdeb` |
| PASSWORD | User password | `cusdeb` |
| PORT     | Port for the Web interface | `8003` |
