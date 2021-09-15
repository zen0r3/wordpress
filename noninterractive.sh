#!/usr/bin/bash

#NON INTERRACTIVE LOL

#set username mysql and password for root
echo "Setting Database : "
usera=LolUserWordpress
echo "Setting Database : "
passworda=passwood12315131
echo "Settting Database : "
namedb=wpdb

sudo apt update

clear

sudo apt upgrade -y

clear

sudo apt install apache2 apache2-utils -y

clear

sudo ufw allow in "Apache"
sudo apt install mysql-client mysql-server -y
sudo apt install php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

clear

sudo echo "<?php 
phpinfo();
?>" > /var/www/html/info.php

wget -c https://raw.githubusercontent.com/zen0r3/yes/1d61c5e4fe680e3348aa64e0f0c36cf5217cb419/php.ini

wget -c http://wordpress.org/latest.tar.gz

tar -xzvf latest.tar.gz
sudo mv wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

#aptitude -y install expect

sudo mysqladmin -u root password "$passworda"
sudo mysql -u root -p"$passworda" -e "UPDATE mysql.user SET Password=PASSWORD('$passworda') WHERE User='root'"
sudo mysql -u root -p"$passworda" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$passworda" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$passworda" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$passworda" -e "FLUSH PRIVILEGES"


sudo mysql -u 'root' -p$passworda << MYSQLSCRIPT
CREATE DATABASE $namedb;
CREATE USER '$usera'@'%' IDENTIFIED WITH mysql_native_password BY '$passworda';
GRANT ALL ON $namedb.* TO '$usera'@'%';
FLUSH PRIVILEGES;
MYSQLSCRIPT


sudo mysql -u 'root' -p$passworda <<MYSQLSCRIPT
CREATE DATABASE wp_myblog;
CREATE USER 'wpuser'@'%' IDENTIFIED WITH mysql_native_password BY '$passworda';
GRANT ALL ON wp_myblog.* TO 'wpuser'@'%';
FLUSH PRIVILEGES;
MYSQLSCRIPT


sudo rm -rf /var/www/html/index.html
sudo mv /var/www/html/wp-config-sample.php .
mv wp-config-sample.php wp-config.php

sed -i bak -e "s/database_name_here/$namedb/" wp-config.php
sed -i bak -e "s/username_here/$usera/" wp-config.php
sed -i bak -e "s/password_here/$passworda/" wp-config.php

sudo mv wp-config.php /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo chown root:root php.ini
sudo mv php.ini /etc/php/7.4/apache2/

/etc/init.d/apache2 restart
/etc/init.d/mysql restart

sudo find /var/www -type d -exec chmod 775 {} \;
sudo find /var/www -type f -exec chmod 644 {} \;


rm -rf wordpress/
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
clear
echo -e "INSTALLATION COMPLETE\n"
echo 
echo The username is $usera password is $passworda  db name is $namedb > credentials.txt
ip=$(curl -s ifconfig.me)
echo -e "Website URL is:\nhttp://$ip"
echo -e "\nCheck PHPInfo here:\nhttp://$ip/info.php"
