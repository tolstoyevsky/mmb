# Memcached

<p align="center">
    <img src="logo.svg" width="200">
</p>

Memcached is an open source high-performance, distributed memory object caching system.

<table>
  <tr>
    <td align="center" colspan="2"><b>Memcached</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="https://github.com/memcached/memcached/wiki/ReleaseNotes159">1.5.9</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>07 Jul 2018</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>11212</td>
  </tr>
  <tr>
    <td valign="top">Base images</td>
    <td>
        <code>cusdeb/alpine3.7:armhf</code> (for <code>armhf</code> port)<br>
        <code>cusdeb/alpine3.7:amd64</code> (for <code>amd64</code> port)
    </td>
  </tr>
</table>

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter | Description | Default |
| --- | --- | --- |
| PORT      | Port the Memcached server listens on | 11212 |
| BIND      | Allows specifying from which interface Memcached must listen for connections | 127.0.0.1  |
| MEM_LIMIT | Allows specifying (in megabytes) how much RAM Memcached must use for item storage | 64 |
| CON_LIMIT | Allows specifying the max number of concurrent connections Memcached can accept | 1024 |

