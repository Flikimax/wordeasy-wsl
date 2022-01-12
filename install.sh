# Install Nginx HTTP Server
sudo apt update
sudo apt install nginx

sudo service nginx stop
sudo service nginx start

# # Install MariaDB Server
sudo apt install mariadb-server mariadb-client

sudo service mysql stop
sudo service mysql start

sudo mysql_secure_installation

# Validation for the database user name.
ROOT="root"
IFUSER=0
while [ "$IFUSER" -eq 0 ]
do
    read -p "Root user name for the database: " USERNAME
    USERNAMELOWER=$(echo "$USERNAME" | tr '[:upper:]' '[:lower:]')

    if [ "$USERNAME" ]; then
        if [ "$USERNAMELOWER" != "$ROOT" ]; then
            IFUSER=1
        else
            tput setaf 1;
            echo "Root user name for the database is not allowed"
            tput setaf 7;
        fi

    else
        tput setaf 1;
        echo "Root user name for the database empty"
        tput setaf 7;
    fi
done

read -p "Root password for the database: " USERPASSWORD

# Create user as root.
sudo mysql -u "root" -p"${USERPASSWORD}" -e "CREATE USER '${USERNAME}'@'localhost' IDENTIFIED BY '${USERPASSWORD}';GRANT ALL PRIVILEGES ON *.* TO '${USERNAME}'@'localhost' WITH GRANT OPTION;CREATE USER '${USERNAME}'@'%' IDENTIFIED BY '${USERPASSWORD}';GRANT ALL PRIVILEGES ON *.* TO '${USERNAME}'@'%' WITH GRANT OPTION;FLUSH PRIVILEGES;"

# Create configuration file.
sudo mkdir -p /etc/fkm

echo "# Database configuration
DB_USER=${USERNAME}
DB_PSW=${USERPASSWORD}
" > /tmp/fkm.conf
sudo mv /tmp/fkm.conf /etc/fkm/fkm.conf
sudo chown -R root:root /etc/fkm/fkm.conf
sudo chmod -R 644 /etc/fkm/fkm.conf


# Install PHP and Related Modules
sudo apt install php-fpm php-common php-mysql php-gmp php-curl php-intl php-mbstring php-xmlrpc php-gd php-xml php-cli php-zip

sudo service php7.4-fpm stop
sudo service php7.4-fpm start

# WP-CLI
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Install ZIP
sudo apt install zip
sudo apt install unzip