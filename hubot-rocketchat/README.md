# Rocket.Chat Hubot adapter

Rocket.Chat Hubot adapter is the way to integrate [Hubot](https://hubot.github.com) with [Rocket.Chat](https://rocket.chat). This is one of the third-party [adapters](https://hubot.github.com/docs/adapters/).

<table>
  <tr>
    <td align="center" colspan="2"><b>Rocket.Chat Hubot adapter</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td>2.0 (<a href="https://github.com/RocketChat/hubot-rocketchat/commit/930d085472bb9afa122721fa1b0bec59a783b86b">930d085472bb9afa122721fa1b0bec59a783b86b</a>)</td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>04 Jun 2018</td>
  </tr>
  <tr>
    <td valign="top">Base image</td>
    <td><code>cusdeb/alpine3.7:amd64</code></td>
  </tr>
</table>

## Table of Contents

* [Features](#features)
* [Installation](#installation)
* [Note to macOS users](#note-to-macos-users)
* [Configuration](#configuration)
* [Installing external scripts](#installing-external-scripts)
* [Debugging](#debugging)
* [Known issues](#known-issues)

## Features

The following set of scripts makes the bot capable of doing all sort of things:

* [hubot-happy-birthder](https://github.com/tolstoyevsky/hubot-happy-birthder) – writes birthday messages to users.
* [hubot-help](https://github.com/tolstoyevsky/hubot-help) – shows available commands.
* [hubot-huntflow-reloaded](https://github.com/tolstoyevsky/hubot-huntflow-reloaded) – helps handling incoming interviews.
* [hubot-pugme](https://github.com/tolstoyevsky/hubot-pugme) – shows random pictures with pugs.
* [hubot-reaction](https://github.com/hubot-scripts/hubot-reaction) – interacts with [replygif.net](http://replygif.net).
* [hubot-redis-brain](https://github.com/hubotio/hubot-redis-brain) – allows using Redis as an alternative storage backend for the Hubot in-memory key-value storage exposed as `robot.brain`.
* [hubot-thesimpsons](https://github.com/hubot-scripts/hubot-thesimpsons) – generates the quotes and images related to The Simpsons.
* [hubot-viva-las-vegas](https://github.com/tolstoyevsky/hubot-viva-las-vegas) – allows handling leave requests.
* [hubot-vote-or-die](https://github.com/tolstoyevsky/hubot-vote-or-die) – allows building polls.

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## Note to macOS users

macOS doesn't have the `/srv` directory which the Redis service relies on. Moreover, it's not possible to create that directory because of [System Integrity Protection](https://arstechnica.com/gadgets/2015/09/os-x-10-11-el-capitan-the-ars-technica-review/8/#h1) (or simply SIP), so edit `docker-compose.yml` to replace `/srv/redis-dump:/dump` to `./redis-dump:/dump`.

## Configuration

`docker-compose.yml` supports the following parameters.

<table>
  <tr>
    <td align="center"><b>Parameter</b></td>
    <td align="center"><b>Description</b></td>
    <td align="center"><b>Default</b></td>
  </tr>
  <tr>
    <td align="center" colspan="3"><b>Rocket.Chat Hubot adapter</b></td>
  </tr>
  <tr>
    <td>AUTH_ATTEMPTS</td>
    <td>Specifies the number of authentication attempts before running the bot. The parameters helps the container to be put on pause when, for example, the bot account is being prepared.</td>
    <td>60</td>
  </tr>
  <tr>
    <td>DEBUG</td>
    <td>Specifies whether to run Hubot in debug mode (See <a href="#debugging">Debugging</a> for more details).</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td>REQUIRED_PRIVATE_CHANNELS</td>
    <td>Comma-separated list containing the private channels the bot must be in. The check repeats at intervals of 1 second. The number of attempts is specified via <code>AUTH_ATTEMPTS</code>.</td>
    <td></td>
  </tr>
  <tr>
    <td>ROCKETCHAT_URL</td>
    <td>Domain or IP of the Rocket.Chat host.</td>
    <td>http://127.0.0.1:8006</td>
  </tr>
  <tr>
    <td>ROCKETCHAT_ROOM</td>
    <td>Comma-separated list containing the channels the bot must listen in.</td>
    <td></td>
  </tr>
  <tr>
    <td>ROCKETCHAT_USER</td>
    <td>Name of the user on whose behalf the bot works. Note, that the user <b>must</b> exist before running the adapter.</td>
    <td>meeseeks</td>
  </tr>
  <tr>
    <td>ROCKETCHAT_PASSWORD</td>
    <td>Password of the user on whose behalf the bot works.</td>
    <td>pass</td>
  </tr>
  <tr>
    <td>EXTERNAL_SCRIPTS</td>
    <td colspan="2">Comma-separated list of the packages, containing the scripts which are intended to empower Hubot. Using the parameter it's possible to install packages either from an NPM registry or from a Git repository, or a local directory (<a href="#installing-external-scripts">read more</a>).<br>
By default, the packages from the list <a href="#features">above</a> will be installed.</td>
  </tr>
  <tr>
    <td>HUBOT_NAME</td>
    <td>Programmatic name for listeners.</td>
    <td>bot</td>
  </tr>
  <tr>
    <td>LISTEN_ON_ALL_PUBLIC</td>
    <td>Respond listens in all public channels (<code>true</code> or <code>false</code>)</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td>RESPOND_TO_DM</td>
    <td>Allows specifying whether the bot can respond privately. If the environment variable is set to <code>true</code>, users may send direct messages to the bot (without mentioning its name) and expect a response from it.</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td>TZ</td>
    <td>Time zone. See all the possible values for the parameter <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">here</a>.</td>
    <td>Europe/Moscow</td>
  </tr>
  <tr>
    <td align="center" colspan="3"><b>hubot-happy-birthder</b></td>
  </tr>
  <tr>
    <td colspan="3"><code>TENOR_API_KEY</code> is the only <b>mandatory</b> parameter both in this script and in the Docker image. The script will fail if the parameter is equal to an empty string (which it is by default).<br>See the description for all the parameters related to the script in its original <a href="https://github.com/tolstoyevsky/hubot-happy-birthder">README</a>.</td>
  </tr>
  <tr>
    <td align="center" colspan="3"><b>hubot-huntflow-reloaded</b></td>
  </tr>
  <tr>
    <td colspan="3">See the description for all the parameters related to the script in its original <a href="https://github.com/tolstoyevsky/hubot-huntflow-reloaded">README</a>.</td>
  </tr>
  <tr>
    <td align="center" colspan="3"><b>hubot-redis-brain</b></td>
  </tr>
  <tr>
    <td>REDIS_URL</td>
    <td>Domain or IP of the Redis host.</td>
    <td>redis://redis:6379</td>
  </tr>
  <tr>
    <td align="center" colspan="3"><b>hubot-viva-las-vegas</b></td>
  </tr>
  <tr>
    <td colspan="3">See the description for all the parameters related to the script in its original <a href="https://github.com/tolstoyevsky/hubot-viva-las-vegas">README</a>.</td>
  </tr>
</table>

## Installing external scripts

`EXTERNAL_SCRIPTS` is a comma-separated list of the packages, containing the scripts which are intended to empower Hubot.
* To install a package from the official NPM registry, simply specify its name in the list.
* To install a package from its GitHub repository, use the following format: `git:github-username/repo-name`. In this case the script will be installed from the `master` branch. To specify a different branch follow the format: `git:github-username/repo-name@target-branch`.
* To install a package from a local directory, move the directory to `packages` and use the following format: `dir:package-name`.

## Debugging

To enable debugging the Hubot scripts set `DEBUG` to `true` via the `.env` file, run the container in interactive mode and make sure you can find a line which looks like the following: `Debugger listening on ws://127.0.0.1:9229/xxxxxxxx-xxxx-4xxx-xxxx-xxxxxxxxxxxx`.
To start debugging via [Chrome DevTools](https://nodejs.org/en/docs/guides/debugging-getting-started/):
* send an HTTP request to http://127.0.0.1:9229/json/list and copy the address stored in the `devtoolsFrontendUrl` field;
* open the address in a Chromium-based browser.

To start debugging via [Visual Studio Code](https://github.com/microsoft/vscode):
* find Open Configurations in the Debug menu;
* edit the configurations field to make it look like the following;
```json
[
  {
    "type": "node",
    "request": "attach",
    "name": "Attach to remote",
    "address": "127.0.0.1",
    "port": "9229"
  }
]
```
* (optionally) read [Remote debugging](https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_remote-debugging) for details.

The section described two possible ways of debugging the scripts. Read [Debugging Guide](https://nodejs.org/en/docs/guides/debugging-getting-started/) to get to know about other ones.

## Known issues

If you use macOS you need to modify the configuration specified in `docker-compose.yml`.

Replace `network_mode: "host"` settings with `network_mode: "container:rocketchat_rocketchat_1"` in both `hubot-rocketchat` and `redis` services, 
where `rocketchat_rocketchat_1` is the name of the running container with the Rocket.Chat server (see Rocket.Chat [README](https://github.com/tolstoyevsky/mmb/tree/master/rocketchat) for details).
