# Cleanup

<p align="center">
    <img src="logo.png" width="400">
</p>

Cleanup is a simple service for cleaning server from old docker containers, images and volumes by cron schedule. 

<table>
  <tr>
    <td align="center" colspan="2"><b>Cleanup</b></td>
  </tr>

  <tr>
    <td>Volume</td>
    <td><code>/var/run/docker.sock:/var/run/docker.sock</code></td>
  </tr>
  <tr>
    <td valign="top">Base image</td>
    <td><code>alpine:3.13</code></td>
  </tr>
</table>

## Configuration

`docker-compose.yml` supports the following parameter.

| Parameter | Description | Default |
| --- | --- | --- |
| CRON_SCHEDULE                    | Schedule for cleaning script | 0 12 * * 6 |


## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.
