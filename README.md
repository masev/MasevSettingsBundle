MasevSettingsBundle
===================

Masev SettingsBundle introduce a settings system into eZ Publish 5.x, administration is possible thanks to an interface in legacy admin.
All settings are injected in Symfony container as a parameter.

![Screenshot of the UI](https://raw.githubusercontent.com/masev/MasevSettingsBundle/master/ui.png)

## Install

### Step 1: Download MasevSettingsBundle using composer

Add MasevSettingsBundle in your composer.json:

```js
{
    "require": {
        "masev/settings-bundle": "dev-master"
    }
}
```

Now tell composer to download the bundle by running the command:

``` bash
$ php composer.phar update masev/settings-bundle
```

Composer will install the bundle to your project's `vendor/masev/settings-bundle` directory.

### Step 2: Enable the bundle

Enable the bundle in the kernel:

``` php
<?php
// ezpublish/AppKernel.php

public function registerBundles()
{
    $bundles = array(
        // ...
        new Masev\SettingsBundle\MasevSettingsBundle(),
    );
}
```

### Step 3: Configuration

Edit your application config file to provide connections informations to your storage and to list the bundle wich contains configurable parameters.

Mysql example :
```yaml
# ezpublish/config/config.yml
masev_settings:
    mysql:
        host: 127.0.0.1
        user: root
        password: root
        dbname: mysettings
    bundles: [ ... ]
```
 * bundles : list of bundles that will contains configurable settings

 For Mysql Storage you need to initialize the setting table with the following query :

```sql
CREATE TABLE `masev_settings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(255) NOT NULL DEFAULT '',
  `scope` varchar(255) NOT NULL DEFAULT 'default',
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier_scope` (`identifier`,`scope`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
```

### Step 4: Declaring configurable settings

In your bundle, create a file name settings.xml in the folder <bundle_dir>/Resources/config/.

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<settings xmlns="http://william-pottier.fr/schema/settings"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://william-pottier.fr/schema/settings https://raw.github.com/wpottier/WizadSettingsBundle/master/Resources/schema/settings-1.0.xsd">

    <parameter key="email.sender_name">
        <name>Email sender name</name>
        <default>Me</default>
    </parameter>

    <parameter key="email.sender_email">
        <name>Email sender address</name>
        <default>me@my-site.com</default>
    </parameter>

</settings>
```