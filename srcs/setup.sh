mkdir /etc/nginx/certificate
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -out /etc/nginx/certificate/nginx-certificate.crt -keyout /etc/nginx/certificate/nginx.key
tar -xvf ./srcs/phpMyAdmin-5.1.0-all-languages.tar.xz
mv phpMyAdmin-5.1.0-all-languages /var/www/html/
tar -xvf ./srcs/wordpress-5.7-fr_FR.tar
mv wordpress /var/www/html/wordpress
cp ./srcs/Marvinpng.png ./var/www/html/Marvinpng.png

if [ "$autoindex" == "off" ]
then
	cp ./srcs/default_off ./etc/nginx/sites-available/default
	echo "Starting without auto index"
else
	cp ./srcs/default_on ./etc/nginx/sites-available/default
	echo "Starting with auto index"
fi

cp ./srcs/config.inc.php /var/www/html/phpMyAdmin-5.1.0-all-languages/config.inc.php
cp ./srcs/index.html /var/www/html/index.html
cp ./srcs/wp-config.php /var/www/html/wordpress/wp-config.php
chown -R www-data:www-data /var/www/html/phpMyAdmin-5.1.0-all-languages
chmod 660 /var/www/html/phpMyAdmin-5.1.0-all-languages/config.inc.php
service mysql start
service php7.3-fpm start
service nginx start

#setup mysql

echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

bash