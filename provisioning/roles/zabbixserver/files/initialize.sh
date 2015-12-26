#!/bin/sh

echo 'Creating a database...'
mysqladmin -u root --default-character-set=utf8 create zabbix
echo "grant all on zabbix.* to 'zabbix'@'localhost' identified by 'zabbix';" | mysql -u root zabbix


echo 'Importing initial data...'
mysql -u root zabbix < /usr/share/zabbix-mysql/schema.sql
mysql -u root zabbix < /usr/share/zabbix-mysql/images.sql
mysql -u root zabbix < /usr/share/zabbix-mysql/data.sql
