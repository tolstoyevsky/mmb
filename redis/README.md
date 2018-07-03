# Redis

<p align="center">
    <img src="logo.svg" width="400">
</p>

Redis is an open source high-performance in-memory key-value data store.

<table>
  <tr>
    <td align="center" colspan="2"><b>Redis</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="https://raw.githubusercontent.com/antirez/redis/5.0/00-RELEASENOTES">5.0 RC3</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>14 Jun 2018</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>16379</td>
  </tr> 
  <tr>
    <td>Data volume</td>
    <td><code>/srv/redis-dump:/dump</code></td>
  </tr> 
  <tr>
    <td valign="top">Base images</td>
    <td>
        <code>cusdeb/alpine3.7:armhf</code> (for <code>armhf</code> port)<br>
        <code>cusdeb/alpine3.7:amd64</code> (for <code>amd64</code> port)
    </td>
  </tr>
</table>

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## Configuration

`docker-compose.yml` allows changing any of the supported by `redis.conf` directive. To do that make the environment variable name from `REDIS_CONF_` and the target directive name. For example, to change the port number, use the `REDIS_CONF_port` environment variable. If you want to choose the default value of one of the directives whose name contains dashes (`-`), use underscores (`_`) in the environment variable name related to the target directive. For example, to change the value of the `always-show-logo` directive, use the `REDIS_CONF_always_show_logo` environment variable. See the [example](http://download.redis.io/redis-stable/redis.conf) of `redis.conf` to know all the possible directives.

