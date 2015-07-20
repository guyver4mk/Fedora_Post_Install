#!bin/bash

echo "Adding User to Sudoers"
echo "$1	ALL=(ALL)	NOPASSWD: ALL" >> /etc/sudoers.d/$1

echo "Ensuring system is up to date"
dnf -y update

echo "Install Preliminary Packages"
dnf install --nogpgcheck -y wget kernel-devel sox git

# Add RPMForge Repo
dnf install -y --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-22.noarch.rpm

# Cleanup Unnecessary Packages
dnf remove -y rhythmbox evolution empathy firefox

# Download and Install Google Chrome Repo & Browser
echo "Installing Google Chrome"
cd /home/$1/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
dnf install -y google-chrome-stable_current_x86_64.rpm
rm -f google-chrome-stable_current_x86_64.rpm

# Download and Install Sublime Text 3
cd /home/$1/Downloads
echo "Downloading Sublime Text 3 build 3083"
wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3083_x64.tar.bz2

echo "Extracting Sublime Text 3"
tar -xvf sublime_text_3_build_3083_x64.tar.bz2
rm -f sublime_text_3_build_3083_x64.tar.bz2
echo "Installing Sublime Text 3"
mv sublime_text_3 /opt

chown -Rf $1:$1 /opt/sublime_text_3
chmod -Rf 655 /opt/sublime_text_3

cd /opt/sublime_text_3
cp sublime_text.desktop /usr/share/applications

# Install Java JRE and JDK
dnf install -y java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-headless.x86_64 java-1.8.0-openjdk-devel.x86_64

# Install Apache
echo "Installing Apache"
dnf install -y httpd

# Configure Apache
echo "Configuring Apache"
systemctl start httpd.service
systemctl enable httpd.service

# Override Firewall-cmd in Apache
echo "Applying Firewall Rules for Apache"
firewall-cmd --set-default-zone=public
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

# Install MySQL
## Get Fedora 22 Release Repo Info RPM ##
echo "Installing MySQL"
echo "Installing Fedora 22 Release Repo Info RPM"
wget http://dev.mysql.com/get/mysql-community-release-fc22-5.noarch.rpm
dnf install -y --nogpgcheck mysql-community-release-fc22-5.noarch.rpm

# Install MySQL Server
echo "Instaling MySQL Server"
dnf install -y mysql-community-server

# Start MySQL
echo "Starting MySQL Service"
systemctl start mysql.service 

# Enable MySQL on Startup
echo "Configuring MySQL to start on Boot"
systemctl enable mysql.service

# Change MySQL Root Password
echo "Securing MySQL Root Password"
mysqladmin -u root password lem0nade

# Amend Firewall Rules for MySQL
echo "Applying Firewall Rules for MySQL"
firewall-cmd --permanent --zone=public --add-service=mysql

# Install PHP
echo "Instaling PHP"
dnf install -y php php-mysql

# Restart Apache
echo "Restarting Apache to Activate PHP"
systemctl restart httpd.service

echo "Creating PHPINFO File"
echo "<?php echo phpinfo(); ?>" >> /var/www/html/info.php

echo "One Last Restart of Apache... For Luck"
systemctl restart httpd.service

# Install Ruby, Rails and Gems
echo "Install RVM"
echo "Installing Gems"
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -L get.rvm.io | bash -s stable

echo "Making RVM Available"
echo "PATH=$PATH:/usr/local/rvm/bin" > /home/$1/.bash_profile

source /home/$1/.bash_profile

echo "Installing Ruby and Libraries"
dnf install -y ruby patch libyaml-devel glibc-headers autoconf gcc-c++ glibc-devel patch readline-devel zlib-devel libffi-devel openssl-devel automake libtool bison sqlite-devel ruby-doc ruby-devel rubygems

rvm reload
rvm install 2.2
rvm use 2.2 --default
echo "Default Ruby Environment is now:" && ruby --version

echo "Installing Gems"
echo "Cloning Repo"
git clone http://github.com/rubygems/rubygems
mv rubygems /usr/local/bin

echo "Installing gems"
cd /usr/local/bin/rubygems
ruby setup.rb --no-document

chown -Rf $1:$1 /usr/local/bin/rubygems
chmod -Rf 655 /usr/local/bin/rubygems

echo "PATH=$PATH:/usr/local/bin/rubygems/bin" > /home/$1/.bashrc
source /home/$1/.bashrc


echo "Installing Capistrano"
gem install capistrano

#Installing Composer
echo "Installing composer Globally"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
chown -f $1:$1 /usr/local/bin/composer
chmod +x /usr/local/bin/composer


# Move Yum Meta Data to dnf
echo "Migrating YUM Meta-Data"
dnf install -y python-dnf-plugins-extras-migrate && dnf-2 migrate

#Install IDA
echo "Installing IDA"
cd /home/$1/Downloads
wget https://out7.hex-rays.com/files/idademo68_linux.tgz
tar -xvf idademo68_linux.tgz
chown -Rf $1:$1 idademo68
rm -f idademo68_linux.tgz

#Clean Up Post install
echo "All Products and Applications installed successfully!"
echo "Software Installed as follows;"
composer --version
echo " "
gem --version
echo " "
ruby --version
echo " "
cap --version
echo " "
php --version | grep "(cli) (built"
echo " "
mysql --version
echo " "
/opt/sublime_text_3/sublime_text --version
echo " "
python --version
echo " "
gcc --version | grep "gcc (GCC)"
echo " "
c++ --version | grep "c++ (GCC)"
echo " "
exit
