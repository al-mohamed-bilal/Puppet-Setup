#!/bin/bash

# Installing Puppet Agent
if ! command puppet --version 2> /dev/null 1> /dev/null
then
    echo "Installing Puppet Agent..."
    # wget https://apt.puppetlabs.com/puppet8-release-$(lsb_release -cs).deb 2> /dev/null
    # dpkg -i puppet8-release-$(lsb_release -cs).deb 2> /dev/null
    # apt update 1> /dev/null 2> /dev/null
    apt install puppet-agent -y 2> /dev/null
    echo -e "\n"
    echo "Puppet Agent installed successfully"
else
    echo "Puppet Agent is already installed"
fi

# Obtaining hostname and IP address of Puppet Server
echo "Enter hostname of the Puppet Server"
read hostname
echo "Enter IP address of the puppet server"
read ip

# Adding hostname and IP address to /etc/hosts file
name_entry=`echo -e "$ip\t$hostname"`
if ! grep -q $name_entry /etc/hosts 2> /dev/null
then
    echo -e "$name_entry" >> /etc/hosts
    echo "Added hostname and IP address to /etc/hosts ..."
else
    echo "Hostname and IP entry already exists"
fi

# Adding configurations to Puppet Agent in /etc/puppetlabs/puppet/puppet.conf
echo -e "[agent]\nserver = $hostname\ncertname = `hostname -I`\nenvironment = production\nruninterval = 120m" > /etc/puppetlabs/puppet/puppet.conf
echo "Puppet Agent configuration successful"

# Starting Puppet Agent on each reboot
if ! systemctl is-enabled puppet 1> /dev/null
then
    systemctl enable puppet 1> /dev/null
    echo "Puppet Agent Enabled"
else
    echo "Puppet Agent is already enabled"
fi

# Starting Puppet Agent
if ! systemctl is-active puppet 1> /dev/null
then
    systemctl start puppet 1> /dev/null
    echo "Puppet Agent Started"
else
    echo "Puppet Agent is already running"
fi

# Adding Puppet Agent to PATH variable
export PATH=$PATH:/opt/puppetlabs/bin

echo "Puppet Agent is Successfully Running..."

