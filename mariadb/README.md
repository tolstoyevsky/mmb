# MariaDB

<p align="center">
    <img src="logo.png" width="400">
</p>

MariaDB is a community-developed fork of MySQL that is dedicated to FOSS (free and open source software) and released under the GNU GPL. The image was inspired by [alpine-mariadb](https://bitbucket.org/yobasystems/alpine-mariadb).

<table>
  <tr>
    <td align="center" colspan="2"><b>MariaDB</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="https://mariadb.org/mariadb-10-1-is-stable-ga/">10.1</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>17 Oct 2015</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>3306</td>
  </tr> 
  <tr>
    <td>Data volume</td>
    <td>/srv/mysql</td>
  </tr> 
  <tr>
    <td valign="top">Base images</td>
    <td>
        cusdeb/alpinev3.7:armhf (for armhf port)<br>
        alpine:3.7 (for amd64 port)
    </td>
  </tr>
</table>

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter | Description | Default |
| --- | --- | --- |
| MYSQLD_*            | Any option in `/etc/mysql/my.cnf` from the `mysqld` section |        |
| MYSQL_ROOT_PASSWORD | root password for MariaDB                                   | cusdeb |
| MYSQL_DATABASE      | Database name                                               |        |
| MYSQL_USER          | User name for the database                                  |        |
| MYSQL_PASSWORD      | User password for the database                              |        |
