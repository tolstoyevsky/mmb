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
    <td><a href="https://github.com/RocketChat/Rocket.Chat/releases/tag/4.3.0">4.3.0</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>28 Dec 2021</td>
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
* [First run of Rocket.Chat](#first-run-of-rocketchat)
* [How to upgrade MongoDB 3.2 to 3.6](#how-to-upgrade-mongodb-32-to-36)
* [Troubleshooting](#troubleshooting)
* [Configuration](#configuration)

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## First run of Rocket.Chat

If you're running Rocket.Chat from here for the very first time, you have to
* first, run `docker-compose up mongo`;
* next, run `docker run -it --rm --net=container:rocketchat_mongo_1 mongo:3.2-jessie bash` where `rocketchat_mongo_1` is the name of the MongoDB container;
* then, execute the following code in the shell
  ```
  mongo mongo/rocketchat --eval "rs.initiate({ _id: 'rs0', members: [ { _id: 0, host: 'localhost:27017' } ]})"
  ```
* finally, stop the current container and run `docker-compose up -d`.

Next time you want to run Rocket.Chat, simply run `docker-compose up -d`.

## How to upgrade MongoDB 3.2 to 3.6

If you're running MMB Rocket.Chat for the very first time, simply skip the section. However, if you have been using Rocket.Chat for a while, you have to upgrade the MongoDB data files to version 3.6 before attempting an upgrade Rocket.Chat itself.

Initially, MMB Rocket.Chat was using MongoDB 3.2. To upgrade its data files to version 3.6, first of all you have to upgrade them to version 3.4.

* First, run the container based on [dubc/mongodb-3.4](https://hub.docker.com/r/dubc/mongodb-3.4) (there is no an official Docker image with MongoDB 3.4) in the following way:

  ```
  docker run --rm --net=host -v /srv/mongo:/data/db dubc/mongodb-3.4
  ```

* Then, connect to the MongoDB server using `mongo` and execute

  ```
  db.adminCommand( { setFeatureCompatibilityVersion: "3.4" } )
  ```

* Next, run a container with MongoDB 3.6 based on the official Docker image

  ```
  docker run --rm --net=host -v /srv/mongo:/data/db mongo:3.6-xenial --oplogSize 128 --replSet rs0
  ```

* Finally, connect to the MongoDB server using `mongo` and execute

  ```
  db.adminCommand( { setFeatureCompatibilityVersion: "3.6" } )
  ```

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

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter      | Description                      | Default               |
| -------------- | -------------------------------- | --------------------- |
| PORT           | Port Rocket.Chat is available on | 8006                  |
| MONGO_DATABASE | Database name                    | rocketchat            |
| MONGO_HOST     | MongoDB host                     | mongo:27017           |
| ROOT_URL       | Rocket.Chat host                 | http://127.0.0.1:8006 |
