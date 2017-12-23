# Deluge

<p align="center">
    <img src="logo.png" width="400">
</p>

Deluge is a feature-rich BitTorrent client with Web interface.

## Installation

First, execute

```
docker build -t cusdeb.com:5000/deluge:1_3_15_armhf .
sudo ./postinst.sh
docker-compose up -p
```

Then, go to `http://[Device IP Address]:8002`. You will be asked to enter a password. By default, it's `deluge`. It's highly recommended to change it after successful login.

## Uninstallation

First, stop the Deluge container by executing
```
docker stop delugeweb_deluge-web_1
```

If for some reason Docker says something like `Error response from daemon: No such container: delugeweb_deluge-web_1`, execute

```
docker ps
```

and find the container name and execute `docker stop` again.

Then, remove the container by executing

```
docker rm delugeweb_deluge-web_1
```

Finally, execute

```
sudo ./postrm.sh
```

to remove all the directories associated with Deluge (except the directory intended for downloads which is located in `/srv/common`).

## Configuration

* Change the `PORT` parameter in `docker-compose.yml` to use different port for the Web interface.
* `/srv/deluge/web.conf` allows changing all sort of things related to the Web interface.
