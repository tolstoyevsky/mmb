# Parsoid

Parsoid is a bidirectional runtime wikitext parser. It works in tandem with the [VisualEditor](https://mediawiki.org/wiki/Extension:VisualEditor) extension.

<table>
  <tr>
    <td align="center" colspan="2"><b>Parsoid</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="https://mediawiki.org/wiki/Parsoid/Releases#0.10.0_(released_Dec_5,_2018)">0.10.0</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>05 Dec 2018</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>8005</td>
  </tr> 
  <tr>
    <td valign="top">Base image</td>
    <td><code>cusdeb/alpine3.7-node:amd64</code></td>
  </tr>
</table>

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter | Description | Default |
| --- | --- | --- |
| PORT            | Port the Parsoid server listens on | 8005 |
| PARSOID_DOMAIN  | Domain of the Parsoid host (the value must be equal to the `PARSOID_DOMAIN` parameter from the [MediaWiki](https://github.com/tolstoyevsky/mmb/tree/master/mediawiki) Docker image) | parsoid |
| MW_API_ENDPOINT | URL of the MediaWiki API endpoint | http://127.0.0.1:8004/api.php |
| LOGGING_LEVEL   | Logging level (`fatal`, `error`, `warn`, `info`, `debug` and `trace`) | `info` |
| DEBUG_MODE      | Debug mode (`true` and `false`) | `false` |
