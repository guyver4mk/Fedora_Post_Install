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
