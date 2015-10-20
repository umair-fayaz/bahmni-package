#!/bin/bash

#create bahmni user and group if doesn't exist
USERID=bahmni
GROUPID=bahmni
/bin/id -g $GROUPID 2>/dev/null
[ $? -eq 1 ]
groupadd bahmni

/bin/id $USERID 2>/dev/null
[ $? -eq 1 ]
useradd -g bahmni bahmni

mkdir -p /opt/bahmni-lab/uploaded-files
mkdir -p /home/bahmni/uploaded-files/elis

#create links
ln -s /opt/bahmni-lab/etc /etc/bahmni-lab
ln -s /opt/bahmni-lab/bin/bahmni-lab /etc/init.d/bahmni-lab
ln -s /opt/bahmni-lab/run /var/run/bahmni-lab
ln -s /opt/bahmni-lab/bahmni-lab /var/run/bahmni-lab/bahmni-lab
ln -s /opt/bahmni-lab/log /var/log/bahmni-lab
ln -s /opt/bahmni-lab/uploaded-files/elis /home/bahmni/uploaded-files/elis

#create a database if it doesn't exist.  TODO: define the dependency on pgsql client
(cd /opt/bahmni-lab/migrations && scripts/initDB.sh bahmni-base.dump)
(cd /opt/bahmni-lab/migrations/liquibase/ && /opt/bahmni-lab/migrations/scripts/migrateDb.sh)


chkconfig --add bahmni-lab

# permissions
chown -R bahmni:bahmni /opt/bahmni-lab
chown -R bahmni:bahmni /var/log/bahmni-lab
chown -R bahmni:bahmni /var/run/bahmni-lab
chown -R bahmni:bahmni /etc/init.d/bahmni-lab
chown -R bahmni:bahmni /etc/bahmni-lab
