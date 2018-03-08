# Aruba RTLS collector
## Description
This simple scripts are used for collecting RTLS information from Aruba wireless controller. Received data are stored in database.

This project is still in proof of concept phase. It is not suitable for production use !!!

## Blacklisting MAC address ranges
There you can download complete MAC address registry https://regauth.standards.ieee.org/standards-ra-web/pub/view.html#registries. 
After that, insert data to table "mac_registry". If you want to blacklist some organization, just simply add correct name to table "organization_blacklist" for example:
```sql
insert into organization_blacklist values(NULL,"Cisco Systems Inc");
```
It will automaticaly insert all MAC ranges associated with that organization into table "mac_blacklist"

