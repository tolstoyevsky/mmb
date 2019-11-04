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
    <td>33061</td>
  </tr> 
  <tr>
    <td>Data volume</td>
    <td>/srv/mysql</td>
  </tr> 
  <tr>
    <td valign="top">Base image</td>
    <td>cusdeb/alpine3.7:amd64</td>
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
    <td colspan="2">Any option in <code>/etc/mysql/my.cnf</code> from the <code>mysqld</code> section. For example, to change the port which is used by default, use the <code>MYSQLD_port</code> environment variable.</td>
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

