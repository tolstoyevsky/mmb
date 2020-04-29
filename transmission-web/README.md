# Transmission

<p align="center">
    <img src="logo.png" width="200">
</p>

Transmission is a lightweight BitTorrent client with Web interface.

<table>
  <tr>
    <td align="center" colspan="2"><b>Transmission</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="https://github.com/transmission/transmission/releases/tag/2.94">2.94</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>01 May 2018</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>8003</td>
  </tr>
  <tr>
    <td>Data volume</td>
    <td>/srv/common/downloads</td>
  </tr>
  <tr>
    <td valign="top">Base image</td>
    <td><a href="https://hub.docker.com/_/alpine">Official Docker image</a> based on <a href="https://alpinelinux.org/posts/Alpine-3.11.0-released.html">Alpine 3.11</a></td>
  </tr>
</table>

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter | Description | Default |
| --- | --- | --- |
| ALLOWED  | Allowed IP addresses. By default, you can reach the Web interface only from the local network | `192.168.*.*` |
| AUTH     | Whether authentication is required                                                            | `true` |
| LOGIN    | User login                                                                                    | `cusdeb` |
| PASSWORD | User password                                                                                 | `cusdeb` |
| PORT     | Port for the Web interface                                                                    | `8003` |
