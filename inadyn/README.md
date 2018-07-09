# inadyn

inadyn (stands for Internet Automated Dynamic DNS Client) is a dynamic DNS client with SSL/TLS support.

<table>
  <tr>
    <td align="center" colspan="2"><b>inadyn</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="https://github.com/troglobit/inadyn/blob/master/ChangeLog.md#v21---2016-12-04">2.1</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>04 Dec 2016</td>
  </tr>
  <tr>
    <td>Volume</td>
    <td>inadyn.conf</td>
  </tr>
  <tr>
    <td valign="top">Base images</td>
    <td>
        cusdeb/alpine3.7:armhf (for armhf port)<br>
        alpine:3.7 (for amd64 port)
    </td>
  </tr>
</table>

## Installation

Read the [Getting Started](https://github.com/tolstoyevsky/mmb#getting-started) section to learn how to install this or other services.

## Configuration

Specify account credentials of the target DDNS provider in `inadyn.conf` before running the container. Look at the [example](https://github.com/troglobit/inadyn#configuration) to learn how to do that.
