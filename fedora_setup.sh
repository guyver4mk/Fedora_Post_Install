echo "Ensuring system is up to date"
yum -y update

echo "Install Preliminary Packages"
yum install --nogpgcheck -y wget kernel-devel sox git

# Add RPMForge Repo
dnf install -y --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-22.noarch.rpm

# Cleanup Unnecessary Packages
dnf remove rhythmbox evolution empathy firefox

# Download and Install Google Chrome Repo & Browser
echo "Installing Google Chrome"
cd /home/ciaran/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
dnf install google-chrome-stable_current_x86_64.rpm

# Download and Install Sublime Text 3
cd /home/ciaran/Downloads
echo "Downloading Sublime Text 3 build 3083"
wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3083_x64.tar.bz2

echo "Extracting Sublime Text 3"
tar -xvf sublime_text_3_build_3083_x64.tar.bz2

echo "Installing Sublime Text 3"
mv sublime_text_3 /opt

chown -Rf ciaran:ciaran /opt/sublime_text_3
chmod -Rf 655 /opt/sublime_text_3

cd /opt/sublime_text_3
cp sublime.desktop /usr/share/applications

# Install Java JRE and JDK
dnf install -y java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-headless.x86_64 java-1.8.0-openjdk-devel.x86_64


# Install Ruby, Rails and Gems
echo "Install RVM"
echo "Installing Gems"
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -L get.rvm.io | bash -s stable

echo "Making RVM Available"
source /home/ciaran/.bash_profile

echo "Installing Ruby and Libraries"
dnf install -y ruby patch libyaml-devel glibc-headers autoconf gcc-c++ glibc-devel patch readline-devel zlib-devel libffi-devel openssl-devel automake libtool bison sqlite-devel ruby-rdoc ruby-devel rubygems

rvm reload
rvm install 2.2
rvm use 2.2 --default
echo "Default Ruby Environment is now:" && ruby --version

echo "Installing Gems"
echo "Cloning Repo"
git clone http://github.com/rubygems/rubygems

echo "Installing gems"
cd rubygems
ruby setup.rb --no-document

echo "Installing Capistrano"
gem install capistrano

# Move Yum Meta Data to dnf
echo "Migrating YUM Meta-Data"
dnf install -y python-dnf-plugins-extras-migrate && dnf-2 migrate
