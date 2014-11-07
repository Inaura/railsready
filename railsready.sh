sudo -i
sudo apt-get -y update
sudo apt-get -y install zsh nodejs
sudo apt-get -y install zlib1g-dev libreadline6-dev libyaml-dev ruby-dev
sudo apt-get -y install wget curl build-essential clang bison openssl zlib1g libxslt1.1 libssl-dev libxslt1-dev libxml2 libffi-dev libyaml-dev libxslt-dev autoconf libc6-dev libreadline6-dev zlib1g-dev libcurl4-openssl-dev libtool
sudo apt-get -y install libpq-dev
#remove original ruby
sudo apt-get -y remove ruby
apt-get -y install apache2-mpm-worker
apt-get -y install apache2-threaded-dev
apt-get -y install libapr1-dev
apt-get -y install libaprutil1-dev
cd /tmp
wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz
tar -xvzf ruby-2.1.3.tar.gz
cd ruby-2.1.3/
./configure --prefix=/usr/local
make
sudo make install
gem update --system --no-ri --no-rdoc
gem install bundler passenger rails--no-ri --no-rdoc -f
sudo locale-gen en_GB.UTF-8
passenger-install-apache2-module --auto

rm  /etc/apache2/sites-enabled/000-default.conf

chown www-data /vagrant/
ln -s /vagrant /var/www/inaura
chown www-data /var/www/inaura

echo "LoadModule passenger_module /usr/local/lib/ruby/gems/2.1.0/gems/passenger-4.0.53/buildout/apache2/mod_passenger.so" >> /etc/apache2/apache2.conf
echo "  PassengerRoot /usr/local/lib/ruby/gems/2.1.0/gems/passenger-4.0.53" >> /etc/apache2/apache2.conf
echo "  PassengerRuby  /usr/local/bin/ruby" >> /etc/apache2/apache2.conf
echo "ServerName \"localhost\"" >> /etc/apache2/apache2.conf

echo "<VirtualHost *:3000>
    DocumentRoot /var/www/inaura/public
    <Directory /var/www/inaura/public>
      Options Indexes FollowSymLinks
      AllowOverride None
      Require all granted
    </Directory>
</VirtualHost>" >> /etc/apache2/sites-available/inaura.conf

ln -s /etc/apache2/sites-available/inaura.conf /etc/apache2/sites-enabled/inaura.conf
echo "Listen 3000" >>/etc/apache2/ports.conf


cd /var/www/inaura
bundle install

apachectl -k restart

