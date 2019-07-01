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
    <td><a href="https://github.com/RocketChat/Rocket.Chat/releases/tag/1.1.0">1.1</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>28 May 2019</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>8006</td>
  </tr> 
  <tr>
    <td valign="top">Base image</td>
    <td><code>cusdeb/stretch-node:amd64</code></td>
  </tr>
</table>

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## How to migrate from Rocket.Chat 0.70+ to 1.0+

* Stop and remove the current Rocket.Chat and MongoDB containers.
* Run the up-to-dated containers. Note that the Rocket.Chat container will crash but don't worry, because it will be fixed soon.
* run `docker run -it --rm --net=container:rocketchat_mongo_1 mongo:3.2-jessie bash` where `rocketchat_mongo_1` is the name of the MongoDB container.
* execute the following code in the shell
  ```
  mongo mongo/rocketchat --eval "rs.initiate({ _id: 'rs0', members: [ { _id: 0, host: 'localhost:27017' } ]})"
  ```

  You should get the following message (the Rocket.Chat version may be different):

  ```
  MongoDB shell version: 3.2.21
  connecting to: mongo/rocketchat
  { "ok" : 1 }
  ```
* Restart the Rocket.Chat and MongoDB containers. Now everything should be fine.

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter      | Description                      | Default               |
| -------------- | -------------------------------- | --------------------- |
| PORT           | Port Rocket.Chat is available on | 8006                  |
| MONGO_DATABASE | Database name                    | rocketchat            |
| MONGO_HOST     | MongoDB host                     | 127.0.0.1:27018       |
| ROOT_URL       | Rocket.Chat host                 | http://127.0.0.1:8006 |
