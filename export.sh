# Export a WordPress website.

cd /var/www
tput setaf 4;
ls -I html 2> /dev/null
tput setaf 7;

read -p "Website name: " NAME

if [ "$NAME" ]; then
    NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')

    # It validates that the site exists.
    if [ -d "/var/www/${NAME}" ]
    then
        cd /var/www/${NAME}
        ORIGINNAME=$NAME
        NAME=$(echo "$NAME" | tr . _)
        DATE=$(date +"%y_%m_%d_%H_%M") 

        # The root user data is obtained.
        DBUSER=$(grep DB_USER /etc/fkm/fkm.conf | cut -d \' -f 4)
        DBPSW=$(grep DB_PSW /etc/fkm/fkm.conf | cut -d \' -f 4)
        DBUSER=$(echo $DBUSER | sed -e 's/DB_USER=//')
        DBPSW=$(echo $DBPSW | sed -e 's/DB_PSW=//')

        # DB data is obtained from the website.
        DATABASE=$(grep DB_NAME wp-config.php | cut -d \' -f 4)

        # Export DB.
        touch $HOME/${DATE}_${NAME}.sql
        mysqldump -u "${DBUSER}" -p"${DBPSW}" $DATABASE > $HOME/${DATE}_${NAME}.sql
        sudo mv $HOME/${DATE}_${NAME}.sql .

        # Permissions.
        CURRENT_USER=$(whoami)
        sudo chown -R www-data:$CURRENT_USER ${DATE}_${NAME}.sql
        sudo chmod -R 775 ${DATE}_${NAME}.sql

        # ZIP
        sudo zip -r ${DATE}_${NAME}.zip wp-content ${DATE}_${NAME}.sql

        # Permissions.
        sudo chown -R www-data:$CURRENT_USER ${DATE}_${NAME}.zip
        sudo chmod -R 775 ${DATE}_${NAME}.zip

        # Disposal of waste.
        sudo rm ${DATE}_${NAME}.sql

        tput setaf 2;
        echo "Successful"
        tput setaf 7;
        echo "Your file is: /var/www/${ORIGINNAME}/${DATE}_${NAME}.zip"
    else
        tput setaf 1;
        echo "Website does not exist"
    fi
fi