# Description

Automates the installation of the packages required for WordPress on WSL to work.

In addition to this it facilitates the creation and removal of websites by running simple commands.

# Stack

- **Nginx**
- **MariaDB**
- **PHP 7.4**

# Requirements

- [Ubuntu 20.04 on WSL](https://ubuntu.com/wsl)
- Windows hosts access

# Installation

- Download the repository in $HOME (/home/user/).
- Run the **install.sh** script.

```bash
sh install.sh
```

*If you want to open your database in software such as DBeaver, do not disable remote root login in the MariaDB options.*

- Run the **processes.sh** script option 4 and verify the status of the services.

```bash
sh processes.sh
```

- Run the **create.sh** script and then type the name of the web site.

```bash
sh create.sh
```

- [Creates a local domain in Windows](https://flikimax.com/crea-un-dominio-local-para-tu-aplicacion-windows).
- To delete a website run the [delete.sh](http://delete.sh/) script.

```bash
sh delete.sh
```