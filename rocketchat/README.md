# Rocket.Chat

<p align="center">
    <img src="logo.svg" width="400">
</p>

Rocket.Chat is a self-hosted alternative to Slack.

<table>
  <tr>
    <td align="center" colspan="2"><b>Rocket.Chat</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="https://github.com/RocketChat/Rocket.Chat/releases/tag/6.2.5">6.2.5</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>8 June 2023</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>8006</td>
  </tr> 
  <tr>
    <td valign="top">Base image</td>
    <td><a href="https://hub.docker.com/_/node">Official Docker image</a> based on <a href="https://debian.org/releases/bullseye/">Debian 11 "Bullseye"</a></td>
  </tr>
</table>

## Table of Contents

* [Installation](#installation)
* [Troubleshooting](#troubleshooting)
* [Configuration](#configuration)

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## Troubleshooting

### control is locked

The Rocket.Chat server complains "control is locked" after migration failure:

```
Not migrating, control is locked. Attempt 1/30. Trying again in 10 seconds.
```

To solve the problem, stick to the following instructions (inspired by [Rocket.Chat#5542](https://github.com/RocketChat/Rocket.Chat/issues/5542)):

```
$ docker exec -it rocketchat_mongo_1 mongo
rs0:PRIMARY> use rocketchat
rs0:PRIMARY> db.migrations.update({_id: 'control'}, {$set: {locked: false}})
```

### Connection to Mongo refused after upgrading Rocket.Chat to 5.x

To solve the problem, stick to the following instructions (inspired by [Rocket.Chat#26519](https://github.com/RocketChat/Rocket.Chat/issues/26519)):

```
$ docker exec -it rocketchat_mongo_1 mongo
config = rs.config()
config.members[0].host = 'mongo:27017'
rs.reconfig(config)
```

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter      | Description                      | Default               |
| -------------- | -------------------------------- | --------------------- |
| PORT           | Port Rocket.Chat is available on | 8006                  |
| MONGO_DATABASE | Database name                    | rocketchat            |
| MONGO_HOST     | MongoDB host                     | mongo:27017           |
| ROOT_URL       | Rocket.Chat host                 | http://127.0.0.1:8006 |
