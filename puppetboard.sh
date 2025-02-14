#!/bin/bash

# Declaring the directory of  Virtual Environment
venv_dir="/etc/puppetboard/puppetboard-venv"

echo "Creating Virtual Environment..."

# Installing python3 and other dependencies to install Puppetboard
if ! command -v python3 1> /dev/null
then
    apt install python3 -y 2> /dev/null
    apt install python3-dev -y 2> /dev/null
    apt install libpq-dev -y 2> /dev/null
    apt install python3-pip -y 2> /dev/null
    apt install python3-venv -y 2> /dev/null
    echo "Installed Python successfully"
else
    echo "Python is already installed"
fi

# Creating Virtual Environment to install Puppetboard
if [ ! -d $venv_dir ]
then
    mkdir -p $venv_dir
    python3 -m venv $venv_dir
    echo "Successfully created the virtual environment $venv_dir"
else
    echo "$venv_dir Virtual Environment already exists"
fi

# Activating the Virtual Environment
source "$venv_dir/bin/activate"
echo "Sucessfully activated Virtual Environment"

# Installing Puppetboard package
pip3 install puppetboard 1> /dev/null 2> /dev/null
echo "Successfully installed Puppetboard"

# Moving to the application directory
python_version=python`python3 --version | cut -d " " -f2 | cut -d "." -f1,2`
cd "$venv_dir/lib/$python_version/site-packages/puppetboard"

# Changing PuppetDB hostname in default_settings.py
echo "Enter hostname of PuppetDB"
read hostname
sed -i "/PUPPETDB_HOST/c\PUPPETDB_HOST = '$hostname'" default_settings.py
echo "Successfully changed PuppetDB hostname in  default_settings.py"

# Generating the secret key for running of Puppetboard
key=$(python3 -c "import secrets;print(secrets.token_hex(16))")
sed -i "/SECRET_KEY/c\SECRET_KEY = '$key'" default_settings.py
echo "Successfully added the secret key to default_settings.py"

# Running Puppetboard 
echo "Running Puppetboard..."
echo "Copy paste the below URL in your web browser"
echo "http://`hostname`:5000"
flask run --host=0.0.0.0 1> /dev/null 2> /dev/null
