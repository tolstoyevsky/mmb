# coturn

coturn is a free open source implementation of TURN and STUN Server.

<table>
  <tr>
    <td align="center" colspan="2"><b>coturn</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="https://github.com/coturn/coturn/wiki/Downloads">4.5.0.7</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>11 Dec 2017</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>3478</td>
  </tr> 
  <tr>
    <td>TLS port</td>
    <td>5349</td>
  </tr> 
  <tr>
    <td valign="top">Base images</td>
    <td>
        cusdeb/alpine3.7:armhf (for armhf port)<br>
        cusdeb/alpine3.7:amd64 (for amd64 port)
    </td>
  </tr>
</table>

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter | Description | Default |
| --- | --- | --- |
| PORT        | Port coturn listens on                                                                                          | 3478   |
| TLS_PORT    | TLS port coturn listens on                                                                                      | 5349   |
| AUTH_SECRET | Secret string to prevent unauthorized usage of the TURN server and it is <b>highly recommended</b> to change it | secret |
