echo "Process:\n"
echo "1. Start"
echo "2. Restart"
echo "3. Stop"
echo "4. Status\n"

echo -n "Select process: "
read PROCESS

if [ "$PROCESS" ]; then
    if [ $PROCESS -eq 1 ]; then
        tput setaf 2;
        sudo service nginx start
        sudo service mysql start
        sudo service php7.4-fpm start
    elif [ $PROCESS -eq 2 ]; then
        tput setaf 4;
        sudo service nginx restart
        sudo service mysql restart
        sudo service php7.4-fpm restart
    elif [ $PROCESS -eq 3 ]; then
        tput setaf 4;
        sudo service nginx stop
        sudo service mysql stop
        sudo service php7.4-fpm stop
    elif [ $PROCESS -eq 4 ]; then
        tput setaf 2;
        sudo service nginx status
        tput setaf 4;
        sudo service mysql status
        tput setaf 2;
        sudo service php7.4-fpm status
    else
        tput setaf 1;
        echo "Invalid option"
    fi
fi
