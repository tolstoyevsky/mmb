# Nextcloud

<p align="center">
    <img src="logo.png" width="400">
</p>

Nextcloud is a self-hosted collaboration platform which can act as an alternative to [Google Workspace](https://workspace.google.com/) and [Microsoft 365](https://microsoft.com/en-ww/microsoft-365).

<table>
  <tr>
    <td align="center" colspan="2"><b>Nextcloud</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="https://nextcloud.com/blog/nextcloud-hub-22-introduces-approval-workflows-integrated-knowledge-management-and-decentralized-group-administration/">22</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>6 Jul 2021</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>8001</td>
  </tr>
  <tr>
    <td valign="top">Base image</td>
    <td><a href="https://hub.docker.com/_/alpine">The official Docker image</a> based on <a href="https://alpinelinux.org/posts/Alpine-3.14.0-released.html">Alpine 3.14</a></td>
  </tr>
</table>

## Features

* Nginx [1.20.1](https://nginx.org/en/CHANGES-1.20) and PHP [7.4.23](https://php.net/ChangeLog-7.php#PHP_7_4).
* The [Bookmarks](https://github.com/nextcloud/bookmarks) application allows users to collect and organize bookmarks.
* The [Calendar](https://github.com/nextcloud/calendar) and [Contacts](https://github.com/nextcloud/contacts) applications allow users to synchronize calendars and contacts with the server respectively.
* The [Circles](https://github.com/nextcloud/circles) allows users to create their own groups of users/colleagues/friends. Those groups of users (or circles) can then be used by any other app (for example, [Collectives](https://gitlab.com/collectivecloud/collectives)) for sharing purpose through the Circles API.
* The [Collectives](https://gitlab.com/collectivecloud/collectives) allows users to to build shared knowledge.
* The [Deck](https://github.com/nextcloud/deck) application allows users to organize their work using [Kanban](https://en.wikipedia.org/wiki/Kanban_(development)) style dashboard.
* The [Files viewer](https://github.com/nextcloud/viewer) application allows users to view their photos and videos.
* The [Mail](https://github.com/nextcloud/mail) application allows users to use their IMAP email accounts using a web interface within Nextcloud.
* The [News](https://github.com/nextcloud/news) application allows users to collect RSS/Atom feeds for later viewing.
* The [News Updater](https://github.com/nextcloud/news-updater) microservice allows users to speed up fetching of RSS/Atom feed updates.
* The [Notes](https://github.com/nextcloud/notes) application allows users to make notes. It also provides categories for better organization and supports [Markdown](https://en.wikipedia.org/wiki/Markdown).
* The [Notifications](https://github.com/nextcloud/notifications) application provides a backend and frontend for the notification API available in Nextcloud. The API is used by other applications to notify users in the web UI and sync clients about various things.
* The [Passman](https://github.com/nextcloud/passman) application allows users to manage their passwords and share them with other users.
* The [PDF viewer](https://github.com/nextcloud/files_pdfviewer) application allows users to view PDF files. It uses the [PDF.js](https://mozilla.github.io/pdf.js/) library under the hood.
* The [Photos](https://github.com/nextcloud/photos) application allows users to create albums from their contents, favorite and tag their photos, show slideshows and share their photos or albums with other users.
* The [Photo Sphere Viewer](https://github.com/nextcloud/files_photospheres) application allows users to view Google PhotoSphere 360° images.
* The [Right click](https://github.com/nextcloud/files_rightclick) application allows users to have a right click menu.
* The [Talk](https://github.com/nextcloud/spreed) application allows users to have private, group, public and password protected calls. It uses the [simpleWebRTC](https://simplewebrtc.com) library under the hood.
* The [Text](https://github.com/nextcloud/text) allows users to collaborate on documents using [Markdown](https://en.wikipedia.org/wiki/Markdown).

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter | Description | Default |
| --- | --- | --- |
| PORT                 | The port the web server listens on                                                                   | 8001 |
| PM_MAX_CHILDREN      | [pm.max_children](https://php.net/manual/en/install.fpm.configuration.php#pm.max-children)           | 5    |
| PM_START_SERVERS     | [pm.start_servers](https://php.net/manual/en/install.fpm.configuration.php#pm.start-servers)         | 2    |
| PM_MIN_SPARE_SERVERS | [pm.min_spare_servers](https://php.net/manual/en/install.fpm.configuration.php#pm.min-spare-servers) | 1    |
| PM_MAX_SPARE_SERVERS | [pm.max_spare_servers](https://php.net/manual/en/install.fpm.configuration.php#pm.max-spare-servers) | 3    |

In order to calculate the values of `PM_MAX_CHILDREN`, `PM_START_SERVERS`, `PM_MIN_SPARE_SERVERS` and `PM_MAX_SPARE_SERVERS` that fit your needs, use [PHP-FPM Process Calculator](https://spot13.com/pmcalculator/).
