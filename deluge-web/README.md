# Deluge

<p align="center">
    <img src="logo.png" width="200">
</p>

Deluge is a feature-rich BitTorrent client with Web interface.

<table>
  <tr>
    <td align="center" colspan="2"><b>Deluge</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="http://dev.deluge-torrent.org/wiki/ReleaseNotes/1.3.15">1.3.15</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>12 May 2017</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>8002</td>
  </tr>
  <tr>
    <td>Data volume</td>
    <td>/srv/common/downloads</td>
  </tr>
  <tr>
    <td valign="top">Other volumes</td>
    <td>
        /srv/deluge/state<br>
        /srv/deluge/web.conf
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

* Change the `PORT` parameter in `docker-compose.yml` to use different port for the Web interface.
* `/srv/deluge/web.conf` allows changing all sort of things related to the Web interface.
