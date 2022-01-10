# Delete a WordPress website.
read -p "Name of the website to be deleted: " NAME

if [ "$NAME" ]; then
    NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')

    # It validates that the site exists.
    if [ -d "/var/www/${NAME}" ]
    then
        # The root user data is obtained.
        DBUSER=$(grep DB_USER /etc/fkm/fkm.conf | cut -d \' -f 4)
        DBPSW=$(grep DB_PSW /etc/fkm/fkm.conf | cut -d \' -f 4)
        DBUSER=$(echo $DBUSER | sed -e 's/DB_USER=//')
        DBPSW=$(echo $DBPSW | sed -e 's/DB_PSW=//')

        # DB data is obtained from the website.
        USER=$(grep DB_USER /var/www/${NAME}/wp-config.php | cut -d \' -f 4)
        PSW=$(grep DB_PASSWORD /var/www/${NAME}/wp-config.php | cut -d \' -f 4)
        DATABASE=$(grep DB_NAME /var/www/${NAME}/wp-config.php | cut -d \' -f 4)

        # The user and the database are deleted.
        mysql -u "${DBUSER}" -p"${DBPSW}" -e "REVOKE ALL PRIVILEGES, GRANT OPTION FROM '${USER}'@'localhost';DROP USER '${USER}'@'localhost';DROP DATABASE ${DATABASE};"

        # The configuration files in Nginx are deleted.
        sudo rm -r /etc/nginx/sites-available/$NAME
        sudo rm -r /etc/nginx/sites-enabled/$NAME

        # Nginx is reloaded.
        sudo service nginx reload

        # Delete the WordPress folder.
        sudo rm -r /var/www/$NAME
        
        tput setaf 4;
        echo "Site successfully removed"
    else
        tput setaf 1;
        echo "Website does not exist"
    fi
fi
