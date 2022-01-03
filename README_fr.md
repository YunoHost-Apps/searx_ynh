# Searx pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/searx.svg)](https://dash.yunohost.org/appci/app/searx) ![](https://ci-apps.yunohost.org/ci/badges/searx.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/searx.maintain.svg)  
[![Installer Searx avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=searx)

*[Read this readme in english.](./README.md)*
*[Lire ce readme en français.](./README_fr.md)*

> *Ce package vous permet d'installer Searx rapidement et simplement sur un serveur YunoHost.
Si vous n'avez pas YunoHost, regardez [ici](https://yunohost.org/#/install) pour savoir comment l'installer et en profiter.*

## Vue d'ensemble

Méta-moteur de recherche respectueux de la vie privée et bidouillable

**Version incluse :** v0.18.0~ynh1

**Démo :** https://demo.yunohost.org/searx/

## Captures d'écran

![](./doc/screenshots/Screenshot.png)

## Documentations et ressources

* Site officiel de l'app : https://searx.github.io/searx/
* Documentation officielle de l'admin : https://github.com/searx/searx/wiki
* Dépôt de code officiel de l'app : https://github.com/searx/searx
* Documentation YunoHost pour cette app : https://yunohost.org/app_searx
* Signaler un bug : https://github.com/YunoHost-Apps/searx_ynh/issues

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/searx_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/searx_ynh/tree/testing --debug
ou
sudo yunohost app upgrade searx -u https://github.com/YunoHost-Apps/searx_ynh/tree/testing --debug
```

**Plus d'infos sur le packaging d'applications :** https://yunohost.org/packaging_apps