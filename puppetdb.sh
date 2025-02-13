#!/bin/bash

# Installing postgresql database
if ! command psql -version 1> /dev/null 2> /dev/null
then
    echo "Installing Postgresql Databasse..."
    apt install postgresql postgresql-contrib -y 2> /dev/null
    echo "Postgresql Database Installed"
else
    echo "Postgresql Database already installed"
fi

# Configuring Postgresql Database
echo "Configuring Postgresql Database..."
sudo -u postgres psql <<EOF 1> /dev/null 2> /dev/null	
CREATE DATABASE puppetdb;
CREATE USER puppetdb WITH PASSWORD 'puppetdb@123';
GRANT ALL PRIVILEGES ON DATABASE puppetdb TO puppetdb;
ALTER DATABASE puppetdb OWNER TO puppetdb;
\c puppetdb
CREATE EXTENSION pg_trgm;
\q
EOF
echo "Postgresql Database configured succesfully"

# Configuring pg_hba.conf in /etc/postgrsql/<version>/main/pg_hba.conf
line1=`echo -e "local\tall\tpuppetdb\tmd5"`
line2=`echo -e "host\tall\tpuppetdb\t127.0.0.1/32\tmd5"`
line3=`echo -e "host\t all\tpuppetdb\t::1/128\tmd5"`

if !  grep -xF "$line1" /etc/postgresql/`psql -V | awk '{print $3}' | cut -d . -f1`/main/pg_hba.conf
then
    echo "$line1" >> /etc/postgresql/`psql -V | awk '{print $3}' | cut -d . -f1`/main/pg_hba.conf
fi

if ! grep -xF "$line2" /etc/postgresql/`psql -V | awk '{print $3}' | cut -d . -f1`/main/pg_hba.conf
then
    echo "$line2" >> /etc/postgresql/`psql -V | awk '{print $3}' | cut -d . -f1`/main/pg_hba.conf
fi

if ! grep -xF "$line3" /etc/postgresql/`psql -V | awk '{print $3}' | cut -d . -f1`/main/pg_hba.conf
then
    echo "$line3" >> /etc/postgresql/`psql -V | awk '{print $3}' | cut -d . -f1`/main/pg_hba.conf
fi

# Installing PuppetDB
if ! command puppetdb version 1> /dev/null 2> /dev/null
then
    echo "Installing PuppetDB..."
    apt install puppetdb puppetdb-termini -y 2> /dev/null
    echo "PuppetDB Installed"
else
    echo "PuppetDB already installed"
fi

# Adding Database Configuration to PuppetDB in /etc/puppetlabs/puppetdb/conf.d/database.ini
echo -e "[database]\nsubname = //localhost:5432/puppetdb\nusername = "puppetdb"\npassword = "puppetdb@123"" > /etc/puppetlabs/puppetdb/conf.d/database.ini
echo "Database Configuration added to database.ini"

# Adding PuppetDB URL in /etc/puppetlabs/puppet/puppetdb.conf
echo -e "[main]\nserver_urls = https://`hostname -I | awk '{print $1}'`:8081" > /etc/puppetlabs/puppet/puppetdb.conf
echo "PuppetDB URL added to puppetdb.conf"

# Setting up SSL and Configuring /etc/puppetlabs/puppetdb/conf.d/jetty.ini
echo "Copying SSL directories..."
mkdir -p /etc/puppetlabs/puppetdb/ssl
cp /etc/puppetlabs/puppet/ssl/certs/ca.pem /etc/puppetlabs/puppetdb/ssl/
cp /etc/puppetlabs/puppet/ssl/certs/`hostname -I | awk '{print $1}'`.pem /etc/puppetlabs/puppetdb/ssl/
mv /etc/puppetlabs/puppetdb/ssl/`hostname -I | awk '{print $1}'`.pem /etc/puppetlabs/puppetdb/ssl/certificate.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/`hostname -I | awk '{print $1}'`.pem /etc/puppetlabs/puppetdb/ssl/
mv /etc/puppetlabs/puppetdb/ssl/`hostname -I | awk '{print $1}'`.pem /etc/puppetlabs/puppetdb/ssl/private.pem
chown -R puppetdb:puppetdb /etc/puppetlabs/puppetdb/ssl

echo "Configuring jetty.ini..."
echo -e "[jetty]\nhost = 0.0.0.0\nport = 8080\nssl-host = 0.0.0.0 \nssl-port = 8081\nssl-key =  /etc/puppetlabs/puppetdb/ssl/private.pem\nssl-cert = /etc/puppetlabs/puppetdb/ssl/certificate.pem\nssl-ca-cert = /etc/puppetlabs/puppetdb/ssl/ca.pem" > /etc/puppetlabs/puppetdb/conf.d/jetty.ini
echo "jetty.ini successfully configured"

# Starting PuppetDB on each reboot
if ! systemctl is-enabled puppetdb 1> /dev/null 2> /dev/null
then
    systemctl enable puppetdb 1> /dev/null 2> /dev/null
    echo "PuppetDB Enabled"
else
    echo "PuppetDB is already enabled"
fi

# Starting Puppet Server
if ! systemctl is-active puppetdb 1> /dev/null 2> /dev/null
then
    echo "Staring PuppetDB..."
    systemctl start puppetdb 1> /dev/null 2> /dev/null
    echo "PuppetDB Started"
else
    echo "PuppetDB is already running"
fi

echo "PuppetDB is running successfully..."


