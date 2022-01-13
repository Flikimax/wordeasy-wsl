# WordEasy WSL

Automates the installation of the packages required for WordPress on WSL to work.

In addition to this it facilitates the creation and removal of websites by running simple commands.

# Stack

- **Nginx**
- **MariaDB**
- **PHP 7.4**
- **WP-CLI**
- **ZIP**

# Requirements

- [Ubuntu 20.04 on WSL](https://ubuntu.com/wsl)
- Windows hosts access

# User's guide

## Installation

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

## Create

To create a new site run the following command:

```bash
sh create.sh
```

Type the name of the new site.

**Important:** The new site must have a **top-level domain (TLD).**

Example: **example.com**, where **.com** is the **(TLD)**

## Export

To export  a WordPress site run the command:

```bash
sh export.sh
```

Type the name of the site you want to export.

This will generate a zip file containing the wp-content and the database sql file.

**Note:** It goes without saying that the site must be previously created.

## Import

Importing a WordPress site requires the zip file to be located in the root of the site '/var/www/example.com/'.

Run de command:

```bash
sh import.sh
```

Type the name of the site where you want to import your zip file and then type the name of the zip file to import.

**Note:** It goes without saying that the site must be previously created.

## Delete

To delete a site run the following command: 

```bash
sh delete.sh
```

Type the name of the site you want to delete.