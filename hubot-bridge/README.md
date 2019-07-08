# Hubot Bridge

_«"Hubot bridge" is a rope stretched between the hubot scripts and the Rocket.Chat database.»_ ― Friedrich Nietzsche

A service that provides interaction with the Rocket.Chat database using the REST API.

## Settings

You can set up project by using environment variables

<table>
    <tr>
        <th>NAME</th>
        <th>DESCRIPTION</th>
        <th>DEFAULT VALUE</th>
    </tr>
    <tr>
        <td>HOST</td>
        <td>Host name on which the server will be running.</td>
        <td>localhost</td>
    </tr>
    <tr>
        <td>PORT</td>
        <td>Port on which server will be launched.</td>
        <td>8000</td>
    </tr>
    <tr>
        <td>MONGODB_HOST</td>
        <td>Address of the host that hosts the Rocket.Chat database.</td>
        <td>localhost</td>
    </tr>
    <tr>
        <td>MONGODB_PORT</td>
        <td>The port where the Rocket.Chat database is located.</td>
        <td>27017</td>
    </tr>
</table>

## Deploy

### In Docker

The easiest way to deploy the project. Great for production deployment.

To deploy a project using Docker, you need to follow the instructions:

1. **Build image**. Run the following command in project root directory. This will create an docker image with the name "mongo-bridge" on your computer.
```
$ make
```

2. **Run**. Make sure the Rocket.Chat database is running and enter this command to your terminal:
```
docker run -p 8000:8000 hubot-bridge
```

In order to set up project you need to pass environment variables to your docker container. You can do it by using `-e` or `--env` flag on docker container starting. For example:
```
docker run -e MONGODB_PORT=27018 hubot-bridge
```
This line pass variable `MONGODB_PORT` with the value `27018` into container.

## Development

### Run project for development

1. **Install packages**. You need to have the following packages on your computer:
    - python (version 3.6 or higher)
    - python-pip
    - python-virtualenv (optional)
2. **Install python dependencies**.
    - Create python virtual environment and activate it. (optional)
    - Install python dependencies from `requirements.txt`
3. **Run**. `app.py`

## API

### `/locale` GET

*Getting localization settings for a specific user*

Query params:
<table>
    <tr>
        <th>Parameter</th>
        <th>Description</th>
        <th>Options</th>
    </tr>
    <tr>
        <td>user_id</td>
        <td>The string with the user ID who you need to know the localization setting</td>
        <td>Required</td>
    </tr>
</table>

## Authors

The project was made by:
- [S. Suprun](https://github.com/BehindLoader)
- [A. Maksimovich](https://github.com/ABSLord)

The project was initialized in the [seven48/hubot-mongo-bridge](https://github.com/seven48/hubot-mongo-bridge).
