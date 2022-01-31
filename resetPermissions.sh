# Permissions are restored 
CURRENT_USER=$(whoami)
sudo chown -R www-data:$CURRENT_USER /var/www/
sudo chmod -R 775 /var/www/