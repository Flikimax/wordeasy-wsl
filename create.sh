# Create a WordPress website.

cd /var/www
tput setaf 4;
ls -I html 2> /dev/null
tput setaf 7;

echo "\n"; read -p "Website name: " NAME

if [ "$NAME" ]; then
    NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')

    # It is validated that the site does not exist.
    if [ ! -d "/var/www/${NAME}" ]
    then
        # Download, unzip and move WordPress.
        cd /tmp
        sudo wget https://wordpress.org/latest.tar.gz
        sudo tar -xvzf latest.tar.gz
        sudo mv wordpress /var/www/$NAME

        # Permissions.
        CURRENT_USER=$(whoami)
        sudo chown -R $CURRENT_USER:$CURRENT_USER /var/www/$NAME/
        sudo chmod -R 755 /var/www/$NAME/

        # The root user data is obtained.
        DBUSER=$(grep DB_USER /etc/fkm/fkm.conf | cut -d \' -f 4)
        DBPSW=$(grep DB_PSW /etc/fkm/fkm.conf | cut -d \' -f 4)
        DBUSER=$(echo $DBUSER | sed -e 's/DB_USER=//')
        DBPSW=$(echo $DBPSW | sed -e 's/DB_PSW=//')

        # Create a database for the web site.
        TIME=$(date +"%T")
        TIME=$(echo "$TIME" | tr : _)
        DATABASE=$(echo "$NAME" | tr . _)
        USERDB=$DATABASE
        PSW=$(cat /dev/random | tr -dc '[:alpha:]' | head -c 32)
        DATABASE="${DATABASE}_${TIME}"

        mysql -u "${DBUSER}" -p"${DBPSW}" -e "CREATE DATABASE ${DATABASE};CREATE USER '${USERDB}'@'localhost' IDENTIFIED BY '${PSW}';GRANT ALL ON ${DATABASE}.* TO '${USERDB}'@'localhost' WITH GRANT OPTION;FLUSH PRIVILEGES;"

        # The WordPress configuration file is created.
        cd /var/www/$NAME
        sudo cp wp-config-sample.php wp-config.php

        sudo sed -i 's/database_name_here/'$DATABASE'/g' wp-config.php
        sudo sed -i 's/username_here/'$USERDB'/g' wp-config.php
        sudo sed -i 's/password_here/'$PSW'/g' wp-config.php

        # Nginx VirtualHost configuration.
        echo "server {
            listen 80;
            listen [::]:80;
            root /var/www/$NAME/;
            index  index.php index.html index.htm;
            server_name $NAME;

            client_max_body_size 100M;
            autoindex off;

            location / {
                try_files \$uri \$uri/ /index.php?\$args;
            }

            location ~ \.php\$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
                fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                include fastcgi_params;
            }
        }" > /tmp/$NAME
        sudo mv /tmp/$NAME /etc/nginx/sites-available/$NAME
        sudo chown -R root:root /etc/nginx/sites-available/$NAME
        sudo chmod -R 644 /etc/nginx/sites-available/$NAME

        sudo ln -s /etc/nginx/sites-available/$NAME /etc/nginx/sites-enabled/

        # Nginx is reloaded.
        sudo service nginx reload

        # Data.
        tput setaf 4;
        echo "Database: ${DATABASE}"
        echo "Database user: ${USERDB}"
        echo "Database Password: ${PSW}"
    else
        tput setaf 1;
        echo "Website already exists"
    fi
fi
