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
    <td><a href="https://mariadb.com/kb/en/mariadb-1060-release-notes/">10.6</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>26 Apr 2021</td>
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
    <td valign="top">Base image</td>
    <td><a href="https://hub.docker.com/_/alpine">Official Docker image</a> based on <a href="https://alpinelinux.org/posts/Alpine-3.16.0-released.html">Alpine 3.16</a></td>
  </tr>
</table>

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## Configuration

`docker-compose.yml` supports the following parameters.

<table>
  <tr>
    <td align="center"><b>Parameter</b></td>
    <td align="center"><b>Description</b></td>
    <td align="center"><b>Default</b></td>
  </tr>
  <tr>
    <td>MYSQLD_*</td>
    <td colspan="2">Any option in <code>/etc/my.cnf</code> from the <code>mysqld</code> section. For example, to change the port which is used by default, use the <code>MYSQLD_port</code> environment variable.</td>
  </tr>
  <tr>
    <td>MYSQL_ROOT_PASSWORD</td>
    <td>root password for MariaDB.</td>
    <td>cusdeb</td>
  </tr>
  <tr>
    <td>MYSQL_DATABASE</td>
    <td>Database name.</td>
    <td></td>
  </tr>
  <tr>
    <td>MYSQL_USER</td>
    <td>User name for the database.</td>
    <td></td>
  </tr>
  <tr>
    <td>MYSQL_PASSWORD</td>
    <td>User name for the database.</td>
    <td></td>
  </tr>
</table>

