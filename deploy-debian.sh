# deploy script tested on Debian Wheezy 7.8

apt-get -y install php5 php5-dev php5-xcache apache2 phpmyadmin mysql-server libmysqld-dev libmysqlclient-dev git swig cmake
apt-get -y install avahi-daemon libnss-mdns
apt-get -y build-dep openbabel
apt-get -y remove libeigen2-dev
apt-get -y install libeigen3-dev

cd ~
git clone --recursive https://github.com/mwojcikowski/discus-deploy.git discus-deploy
cd discus-deploy
./compile_ob
cd openbabel-build && make install && cd ..
./compile_mychem
cd mychem-build && make install && cd ..

ldconfig
mysql -u root -p < mychem/src/mychemdb.sql
echo "CREATE USER 'discus'@'localhost' IDENTIFIED BY 'discusvm'; GRANT ALL PRIVILEGES ON *.* TO 'discus'@'localhost'; FLUSH PRIVILEGES;" | mysql -u root -p

ln -s ~/discus-deploy/disucs-php.ini /etc/php5/apache2/conf.d/99-disus-php.ini
service apache2 restart

# Note: DiSCuS is installed in root www directory
rm -rf /var/www
mkdir /var/www
cd /var/www
git clone https://github.com/mwojcikowski/discus.git .
chmod 777 /var/www
