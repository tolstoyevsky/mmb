# Nextcloud

<p align="center">
    <img src="logo.png" width="400">
</p>

Nextcloud is a self-hosted file storage and synchronization service.

<table>
  <tr>
    <td align="center" colspan="2"><b>Nextcloud</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="https://github.com/nextcloud/server/pull/8127">13 RC4</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>31 Jan 2018</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>8001</td>
  </tr>
  <tr>
    <td>Route</td>
    <td>/nc</td>
  </tr>
  <tr>
    <td>Data volume</td>
    <td>/srv/nextcloud/data</td>
  </tr>
  <tr>
    <td valign="top">Other volumes</td>
    <td>
        /srv/nextcloud/config.php<br>
        /srv/nextcloud/data/nginx<br>
        /srv/nextcloud/data/supervisor<br>
    </td>
  </tr>
  <tr>
    <td valign="top">Base images</td>
    <td>
        cusdeb/stretch:armhf (for armhf port)<br>
        debian:stretch (for amd64 port)
    </td>
  </tr>
</table>

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter | Description | Default |
| --- | --- | --- |
| PORT        | Port the web server listens on | 8001      |
| DB_HOST     | MySQL/MariDB server host       | 127.0.0.1 |
| DB_NAME     | Database name                  | cusdeb    |
| DB_USERNAME | User name                      | root      |
| DB_PASSWORD | User password                  | cusdeb    |
