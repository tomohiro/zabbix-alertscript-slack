Zabbix Alert Script for Slack
================================================================================


Usage
--------------------------------------------------------------------------------

TBD


Development
--------------------------------------------------------------------------------

### Initialize the database for Zabbix

Create a database:

```
$ mysqladmin -u root --default-character-set=utf8 create zabbix
$ echo "grant all on zabbix.* to 'zabbix'@'localhost' identified by 'zabbix';" | mysql -u root zabbix
```

Import the initial data:

```
$ mysql -u root zabbix < /usr/share/zabbix-mysql/schema.sql
$ mysql -u root zabbix < /usr/share/zabbix-mysql/images.sql
$ mysql -u root zabbix < /usr/share/zabbix-mysql/data.sql
```


Acknowledgements
--------------------------------------------------------------------------------

- [ZabbixからSlackへちょっとリッチな通知をする - Qiita](http://qiita.com/bageljp@github/items/20be937ca3bb92100e8f)
- [bageljp/zabbix-slack](https://github.com/bageljp/zabbix-slack)


LICENSE
--------------------------------------------------------------------------------

&copy; 2015 Tomohiro TAIRA.

This project is licensed under the MIT license. See [LICENSE](LICENSE) for details.
