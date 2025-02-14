#!/bin/bash

# Chaning hostname of Puppet Server as its IP Address
hostname="server-`hostname -I | awk '{print $1}'`"
hostnamectl hostname $hostname

# Installing Puppet Server
if ! command puppetserver --version 1> /dev/null 2> /dev/null
then
    echo "Installing Puppet Server..."
    # wget https://apt.puppetlabs.com/puppet8-release-$(lsb_release -cs).deb 2> /dev/null
    # dpkg -i puppet8-release-$(lsb_release -cs).deb 2> /dev/null
    # apt update 1> /dev/null 2> /dev/null
    apt install puppetserver -y 2> /dev/null
    echo "Puppet Server successfully installed"
else
    echo "Puppet Server already installed"
fi

# Adding hostname and IP address to /etc/hosts file
name_entry=`echo -e "`hostname -I | awk '{print $1}'`\t$hostname"`
if ! grep -q $name_entry /etc/hosts 2> /dev/null
then
    echo -e "$name_entry" >> /etc/hosts
    echo "Added hostname and IP address to /etc/hosts ..."
else
    echo "Hostname and IP entry already exists"
fi

# Adding configurations to Puppet Server in /etc/puppetlabs/puppet/puppet.conf
echo -e "[main]\nserver = $hostname\ncertname = $hostname\nenvironment = production\nreports = puppetdb\n\n[master]\nautosign = true\nreport = true\nstoreconfigs = true\nstoreconfigs_backend = puppetdb" > /etc/puppetlabs/puppet/puppet.conf
echo "Puppet Server configured successfully"

# Starting Puppet Server on each reboot
if ! systemctl is-enabled puppetserver 1> /dev/null 2> /dev/null
then
    systemctl enable puppetserver 1> /dev/null 2> /dev/null
    echo "Puppet Server Enabled"
else
    echo "Puppet Server is already enabled"
fi

# Starting Puppet Server
if ! systemctl is-active puppetserver 1> /dev/null 2> /dev/null
then
    echo "Staring Puppet server..."
    systemctl start puppetserver 1> /dev/null 2> /dev/null
    echo "Puppet Server Started"
else
    echo "Puppet Server is already running"
fi

# Allowing Puppet Agents to access Puppet Server by configuring firewall
if ! command ufw --version 2> /dev/null 1> /dev/null
then
    echo "Installing Firewall..."
    apt install ufw -y 2> /dev/null
    echo -e "\n"
    echo "Firewall installed successfully"
    ufw enable 1> /dev/null 2> /dev/null
    echo "Firewall activated"
    ufw allow 8140/tcp 1> /dev/null 2> /dev/null
    echo "Traffic allowed through port 8140..."
else
    echo "Firewall is already installed"
    ufw enable 1> /dev/null 2> /dev/null
    echo "Firewall activated"
    ufw allow 8140/tcp 1> /dev/null 2> /dev/null
    echo "Traffic allowed through port 8140..."
fi

# Adding Puppet Server to PATH variable
export PATH=$PATH:/opt/puppetlabs/bin

echo "Puppet Server is Successfully Running..."
