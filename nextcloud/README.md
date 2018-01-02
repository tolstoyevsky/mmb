# Nextcloud

<p align="center">
    <img src="logo.png" width="400">
</p>

Nextcloud is a self-hosted file storage and synchronization service.


## Prerequisites

Build and run the [MySQL](https://github.com/tolstoyevsky/mmb/tree/master/mysql) container before running Nextcloud.

## Installation

First, execute

```
docker build -t cusdeb.com:5000/nextcloud:13beta3_armhf .
sudo ./postinst.sh
docker-compose up -d
```

Then, go to `http://[Device IP Address]:8001`.

Finally, create an administrator's user account.

## Uninstallation

First, stop the Nextcloud container by executing
```
docker stop nextcloud_nextcloud_1
```

If for some reason Docker says something like `Error response from daemon: No such container: nextcloud_nextcloud_1`, execute

```
docker ps
```

and find the container name and execute `docker stop` again.

Then, remove the container by executing

```
docker rm nextcloud_nextcloud_1
```

Note that you have to remove manually the configuration file `/srv/nextcloud/config.php` and data directory `/srv/nextcloud/data`.

## Configuration

* Change the `PORT` parameter in `docker-compose.yml` to use different port for Nextcloud.
* `/srv/nextcloud/config.php` allows changing all sort of things related to Nextcloud. Refer to the [official documentation](https://docs.nextcloud.com/server/12/admin_manual/configuration_server/config_sample_php_parameters.html) to know more about each parameter from the configuration file.
