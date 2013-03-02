# ipublic large test server
# ssh -i ~/ec2/AWS-dan.thomas-me.com/ipublic-key.pem root@50.19.95.156

### Following instructions to set up Amazon machine instance 
# CentOS 5.x, m1.large instance
# ami-38e41251 (see http://brianbirkinbine.com/entropy/amazon-ec2-ami-centos-5.5-base-install-32bit-64bit-s3-ebs-10gb-pv-grub-ami-eb807682-ami-caf107a3-ami-01996f68-ami-38e41251)

## Purpose
# This script prepares an Amazon CentOS 5.x instance suitable to run OpenMedia stand-alone
# It sets up the linux environment, creates an application account and installs and configures the following:
# Apache
# curl - later version required than availble through yum
# git - later version required than availble through yum
# spidermonkey
# erlang - later version required than availble through yum
# couchdb 1.2
# geocouch
# Ruby on Rails - ruby-1.8.7-p174 and Rails 3.x
# proj.4
# gdal

## Prerequesites
# 1. Start Amazon EC2 instance: CentOS 64 bit using ami-38e41251
# 2. Create an EBS volume, assign to /dev/sdf and attach to instance

## Post processing
# 1. Configure geocouch
# 2. Edit the couchdb inialization file, configure to listen on all ports:
# 2.1 vi /usr/local/etc/couchdb/local.ini # set couch to listen on 0.0.0.0
# 3. Edit the couchdb file to have database and log files point to EBS volume
# 3. Restart couchdb
# 3.1 service couchdb restart
# 4. Add public key to iPublic application account
# 4.1 /home/username/.ssh/authorized_keys
# 5. Change settings to allow wheel group to run commands
# 5.1 visudo
# 6. Configure Apache with Passenger

### Add EBS store to server instance
cat /proc/partitions
mkdir /ebs
mke2fs -F -j /dev/sdf
mount /dev/sdf /ebs

### Update the system and install environment dependencies
yum update -y
yum install -y gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel yum install libicu-devel curl-devel git nmap httpd

### Configure and start Apache
chkconfig --level 345 httpd on
service httpd start

### Install curl
cd /usr/local/src
wget http://curl.haxx.se/download/curl-7.20.1.tar.gz
tar -xvzf curl-7.20.1.tar.gz
cd curl-7.20.1
./configure --prefix=/usr/local
make && make install

### Install GIT
cd /usr/local/src
wget http://kernel.org/pub/software/scm/git/git-1.7.5.1.tar.bz2
tar xvf git-1.7.5.1.tar.bz2
cd git-1.7.5.1
./configure
make && make install

### Install Spider Monkey
cd /usr/local/src
wget http://ftp.mozilla.org/pub/mozilla.org/js/js-1.8.0-rc1.tar.gz
tar xvzf js-1.8.0-rc1.tar.gz
cd js/src
make BUILD_OPT=1 -f Makefile.ref
make BUILD_OPT=1 JS_DIST=/usr/local -f Makefile.ref export

### Install Erlang
cd /usr/local/src
wget http://erlang.org/download/otp_src_R13B04.tar.gz
tar xvzf otp_src_R13B04.tar.gz
cd otp_src_R13B04
./configure && make && make install

### Install CouchDB
cd /usr/local/src
wget http://www.eng.lsu.edu/mirrors/apache//couchdb/1.0.2/apache-couchdb-1.0.2.tar.gz
tar xvzf apache-couchdb-1.0.2.tar.gz
cd apache-couchdb-1.0.2
./configure
make && make install
cd /usr/local/src
mv apache-couchdb-1.0.2 couchdb

groupadd couchdb
adduser -r --home /usr/local/var/lib/couchdb -M --shell /bin/bash --comment "CouchDB Administrator" couchdb
chown -R couchdb.couchdb /usr/local/var/lib/couchdb /usr/local/var/log/couchdb
ln -s /usr/local/etc/rc.d/couchdb /etc/init.d/couchdb
mkdir /ebs/couchdb
mkdir /ebs/couchdb/logs
chown -R couchdb.couchdb /ebs/couchdb

chkconfig --add couchdb
chkconfig --level 345 couchdb on


# Download GeoCouch and follow install instructions
cd /usr/local/src
git clone http://github.com/couchbase/geocouch.git geocouch

service couchdb start
curl http://127.0.0.1:5984
netstat -nap  ## verify port 

### Install Ruby on Rails
# Up-to-date ruby
cd /usr/local/src
wget ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p174.tar.gz
tar xvzf ruby-1.8.7-p174.tar.gz
cd ruby-1.8.7-p174
./configure --with-openssl-dir=/usr/lib64/openssl
make && make install

# Ruby Gems
cd /usr/local/src
wget http://rubyforge.org/frs/download.php/74849/rubygems-1.8.2.tgz
tar xvzf rubygems-1.8.2.tgz
cd rubygems-1.8.2
/usr/local/src/ruby-1.8.7-p174/ruby setup.rb

# Rails
gem install rails

### Install Proj.4 and GDAL

# http://trac.osgeo.org/proj/
cd /usr/local/src
wget http://download.osgeo.org/proj/proj-4.7.0.tar.gz
tar xvzf proj-4.7.0.tar.gzproj-4.7.0.tar.gz
cd proj-4.7.0.tar.gzproj-4.7.0
./configure && make && make install

cd /usr/local/src
wget http://download.osgeo.org/gdal/gdal-1.8.0.tar.gz
tar xvzf gdal-1.8.0.tar.gz
cd gdal-1.8.0

# following is minimal configuration that includes shape file support
./configure  --prefix=/usr/local \
             --with-threads \
             --with-ogr \
             --with-geos \
             --without-libtool \
             --with-libz=internal \
             --with-libtiff=internal \
             --with-geotiff=internal \
             --without-gif \
             --without-pg \
             --without-grass \
             --without-libgrass \
             --without-cfitsio \
             --without-pcraster \
             --without-netcdf \
             --without-png \
             --without-jpeg \
             --without-gif \
             --without-ogdi \
             --without-fme \
             --without-hdf4 \
             --without-hdf5 \
             --without-jasper \
             --without-ecw \
             --without-kakadu \
             --without-mrsid \
             --without-jp2mrsid \
             --without-bsb \
             --without-grib \
             --without-mysql \
             --without-ingres \
             --without-xerces \
             --without-expat \
             --without-odbc \
             --without-curl \
             --without-sqlite3 \
             --without-dwgdirect \
             --without-panorama \
             --without-idb \
             --without-sde \
             --without-perl \
             --without-php \
             --without-ruby \
             --without-python \
             --without-ogpython \
             --with-hide-internal-symbols

### Security
# See also: http://articles.slicehost.com/2008/1/30/centos-setup-page-1

# create application account
groupadd ipublic
adduser -m ipublic -g ipublic

# create group and user account
groupadd developers
adduser -m glappen -g developers
usermod -a -G wheel glappen
mkdir /home/glappen/.ssh
touch /home/glappen/.ssh/authorized_keys  # add public key here
chmod 700 /home/glappen/.ssh
chmod 600 /home/glappen/.ssh/authorized_keys
chown -R glappen:developers /home/glappen/.ssh

# generate the key
# mkdir ~/.ssh
# ssh-keygen -t rsa
# scp ~/.ssh/id_rsa.pub demo@123.45.67.890:/home/username/

# move the key into ~/.ssh folder on server and set permissions
# mkdir /home/username/.ssh
# mv /home/username/id_rsa.pub /home/username/.ssh/authorized_keys
# chown -R username:developers /home/username/.ssh
# chmod 700 /home/username/.ssh
# chmod 600 /home/username/.ssh/authorized_keys

# add user to wheel group
#usermod -a -G wheel username
# enable wheel group members to sudo
#visudo 


# login
ssh username@123.45.67.890



