# MediaWiki

<p align="center">
    <img src="logo.svg" width="400">
</p>

MediaWiki is one of the most famous wiki engines. It's best known for being used as a base for [Wikipedia](http://wikipedia.org).

<table>
  <tr>
    <td align="center" colspan="2"><b>MediaWiki</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="https://mediawiki.org/wiki/MediaWiki_1.35">1.35</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>20 Sep 2020</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>8004</td>
  </tr>
  <tr>
    <td>Data volume</td>
    <td>
        <code>/srv/mediawiki/deleted:/var/www/w/deleted</code><br>
        <code>/srv/mediawiki/images:/var/www/w/images</code>
    </td>
  </tr>
  <tr>
    <td valign="top">Base image</td>
    <td><a href="https://hub.docker.com/_/alpine">Official Docker image</a> based on <a href="https://alpinelinux.org/posts/Alpine-3.13.0-released.html">Alpine 3.13</a></td>
  </tr>
</table>

## Features

* Nginx [1.18.0](http://nginx.org/en/CHANGES-1.18) and PHP [7.4.15](http://php.net/ChangeLog-7.php#7.4.15).
* The [Cite](https://www.mediawiki.org/wiki/Extension:Cite) extension which allows creating references as footnotes on a page, using `<ref>` and `<references />` tags.
* The [MobileFrontend](https://www.mediawiki.org/wiki/Extension:MobileFrontend) extension which provides a mobile view.
* The [SyntaxHighlight](https://mediawiki.org/wiki/Extension:SyntaxHighlight) extension which provides rich formatting of source code using the `<syntaxhighlight>` tag.
* The [Translate](https://mediawiki.org/wiki/Extension:Translate) extension which allows managing multilingual wikis in a sensible way. The extension assumes that the translatable source page is in the wiki's default language. However, administrators can change a specific page's language setting, using the "Special:PageLanguage" page (see the details [here](https://mediawiki.org/wiki/Manual:$wgPageLanguageUseDB)).
* The [Universal Language Selector](https://mediawiki.org/wiki/Extension:UniversalLanguageSelector) extension which allows selecting a language and configuring its support in an easy way. Note that the extension is a dependency for Translate (see above), so be careful when removing it.
* The [VisualEditor](https://mediawiki.org/wiki/Extension:VisualEditor) extension which allows editing pages as rich content.

## Configuration

`docker-compose.yml` supports the following parameters.

| Parameter | Description | Default |
| --- | --- | --- |
| PORT                    | Port wiki is available on | 8004 |
| WG_SITENAME             | Wiki name | My KB |
| WG_META_NAMESPACE       | [Name](https://mediawiki.org/wiki/Manual:$wgMetaNamespace) used for the project namespace | My_KB |
| WG_PROTOCOL             | Protocol which is used for accessing wiki (`http` and `https`) | `http` |
| WG_SERVER               | [Domain or IP](https://mediawiki.org/wiki/Manual:$wgServer) of the wiki host | 127.0.0.1:8004 |
| WG_EMERGENCY_CONTACT    | Wiki [admin email address](https://mediawiki.org/wiki/Manual:$wgEmergencyContact) | username@domain.com |
| WG_PASSWORD_SENDER      | [Password reminder email address](https://mediawiki.org/wiki/Manual:$wgPasswordSender) | username@domain.com |
| WG_DB_SERVER            | [Database server host](https://mediawiki.org/wiki/Manual:$wgDBserver) | 127.0.0.1:33061 |
| WG_DB_NAME              | [Database name](https://mediawiki.org/wiki/Manual:$wgDBname) | knowledge_base |
| WG_DB_USER              | [Database user](https://mediawiki.org/wiki/Manual:$wgDBuser) | root |
| WG_DB_PASSWORD          | [Database password](https://mediawiki.org/wiki/Manual:$wgDBpassword) | cusdeb |
| ALLOW_ACCOUNT_CREATION  | Allows users to create accounts (`true` and `false`) | `true` |
| ALLOW_ACCOUNT_EDITING   | Allows users to edit their accounts (`true` and `false`) | `true` |
| ALLOW_ANONYMOUS_READING | Allows users to read wiki anonymously (`true` and `false`). If the parameter is `false`, wiki is **private** | `false` |
| ALLOW_ANONYMOUS_EDITING | Allows users to edit wiki anonymously (`true` and `false`) | `true` |

## How to create an administrator

Administrators are wiki users who are members of the "sysop" user group (see details [here](https://mediawiki.org/wiki/Manual:Administrators)). An administrator can be created, using the [createAndPromote.php](https://mediawiki.org/wiki/Manual:CreateAndPromote.php) script:

1. Run `docker exec` on a running MediaWiki container.
2. Run `php7 maintenance/createAndPromote.php --sysop <username> <password>` inside the container.

## How to register custom namespaces

First, create the file `config/namespaces.php` and add the following contents to it:

```php
define("NS_ESSAYS", 3000); // This MUST be even.
define("NS_ESSAYS_TALK", 3001); // This MUST be the following odd integer.

// Add namespaces.
$wgExtraNamespaces[NS_ESSAYS] = "Essays";
$wgExtraNamespaces[NS_ESSAYS_TALK] = "Essays_talk";

$wgRestrictDisplayTitle = false;
```

Then, rebuild the Docker image and re-run the container. After this you will get two custom namespaces: `Essays` and `Essays_talk`. Read the official documentation devoted to [registering custom namespaces](https://mediawiki.org/wiki/Manual:Using_custom_namespaces) to know more about the topic.

## How to modify php.ini

In order to modify a [php.ini](https://php.net/manual/en/configuration.file.php) parameter, use the environment variable the name of which consists of `PHP_INI_` and the name of the parameter. For example, to change the [post_max_size](https://php.net/manual/en/ini.core.php#ini.post-max-size) parameter, pass the `PHP_INI_post_max_size` environment variable to the container.

## How to change logo

Provide a square logo named `kblogo.png` which is 135x135px or 150x150px.
