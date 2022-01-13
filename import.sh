# Import a WordPress website.

cd /var/www
tput setaf 4;
ls -I html 2> /dev/null
tput setaf 7;

echo "\n"; read -p "Website name: " NAME

if [ "$NAME" ]; then
    NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')

    # It validates that the site exists.
    if [ -d "/var/www/${NAME}" ]
    then
        cd /var/www/${NAME}
        tput setaf 4;
        ls *.zip 2> /dev/null
        tput setaf 7;
        
        echo "\n"; read -p ".zip name: " ZIP

        # Validates that the .zip exists.
        if [ -f "/var/www/${NAME}/${ZIP}" ]
        then
            # Remove wp-content
            sudo rm -r wp-content
            # Unzip
            sudo unzip -o ${ZIP}

            # Permissions.
            CURRENT_USER=$(whoami)
            sudo chown -R www-data:$CURRENT_USER wp-content
            sudo chmod -R 775 wp-content
            

            # The root user data is obtained.
            # DBUSER=$(grep DB_USER /etc/fkm/fkm.conf | cut -d \' -f 4)
            # DBPSW=$(grep DB_PSW /etc/fkm/fkm.conf | cut -d \' -f 4)
            # DBUSER=$(echo $DBUSER | sed -e 's/DB_USER=//')
            # DBPSW=$(echo $DBPSW | sed -e 's/DB_PSW=//')
            
            # DB data is obtained from the website.
            DATABASE=$(grep DB_NAME wp-config.php | cut -d \' -f 4)
            DBUSER=$(grep DB_USER wp-config.php | cut -d \' -f 4)
            DBPSW=$(grep DB_PASSWORD wp-config.php | cut -d \' -f 4)
            SQLFILE=$(echo "${ZIP%.*}")

            # Import database
            mysql -u "${DBUSER}" -p"${DBPSW}" --one-database $DATABASE < "$SQLFILE.sql"

            # Update of siteurl and home
            URL=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')
            # NAME==$(echo "$NAME" | tr . _)
            wp option update siteurl "http://${URL}" --allow-root
            wp option update home "http://${URL}" --allow-root

            # Disposal of waste.
            sudo rm $SQLFILE.sql
        else
            tput setaf 1;
            echo ".zip does not exist"
        fi
    else
        tput setaf 1;
        echo "Website does not exist"
    fi
fi