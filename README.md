# Puppet-Setup
The Puppet-Setup repo helps to install and configure Puppet Server, Puppet Agent, PuppetDB and PuppetBoard. The below given are steps to setup Puppet Server, Puppet Agent, PuppetDB, PuppetBoard.

## Puppet Server Setup
Puppet Server must be installed and configured on a Linux system (Debian is better). Follow the below steps to setup and configure Puppet Server in your system.
1. Add Puppet Repository to our Linux Repo use the below command to do so.

```
wget https://apt.puppet.com/puppet8-release-$(lsb_release -cs).deb
dpkg -i puppet8-release-$(lsb_release -cs).deb
apt update -y
```

2. Use the below command to clone this repository into your local system (Puppet Server System).

```
git clone https://github.com/al-mohamed-bilal/Puppet-Setup.git
```
3. Move to Puppet-Setup directory and give execute permissions to the puppetserver.sh script inside the Puppet-Setup directory.

```
chmod +x puppetserver.sh
```

4. Run the puppetserver.sh script using below command.

```
. puppetserver.sh
```

## Puppet Agent Setup
Puppet Agent can be installed and configured on a Windows based, Linux based or Mac based system. Follow the below steps to setup and configure Puppet Agent in your system.
1. Add Puppet Repository to our debian Repo use the below command to do so.

```
wget https://apt.puppet.com/puppet8-release-$(lsb_release -cs).deb
dpkg -i puppet8-release-$(lsb_release -cs).deb
apt update -y
```

2. Use the below command to clone this repository into your local system (Puppet Agent System).

```
git clone https://github.com/al-mohamed-bilal/Puppet-Setup.git
```
3. Move to Puppet-Setup directory and give execute permissions to the puppetagent.sh script inside the Puppet-Setup directory.

```
chmod +x puppetagent.sh
```

4. Run the puppetagent.sh script using below command.

```
. puppetagent.sh
```

## PuppetBoard Setup
PuppetBoard can be installed on Puppet Server system (follow step 2 and 3 directly) or a seperate system (follow step 1 to 3).
1. Use the below command to clone this repository into your local system (Puppet Agent System).

```
git clone https://github.com/al-mohamed-bilal/Puppet-Setup.git
```

2. Move to Puppet-Setup directory and give execute permissions to the puppetboard.sh script inside the Puppet-Setup directory.

```
chmod +x puppetboard.sh
```

3. Run the puppetboard.sh script using below command.

```
. puppetboard.sh
```
