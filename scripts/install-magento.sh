#!/bin/bash
echo "Install Magento on Apache Webroot."
echo "Please run as sudo" 

if [ $# -eq 0 ]; then 
  echo "Usage: install-magento.sh <path to Magento zip archive>"
  exit 1
fi 
magento_archive="$1" 

test ! -e $magento_archive && echo "Magento archive $magento_archive not found." && exit 1

echo "Unzip magento archive $magento_archive" 
unzip $magento_archive

read -p "Enter name for store database: " database_name

echo "Create Database $database_name (enter SQL root pass)" 
mysql -u root -p -e "create database $database_name;"

read -p "Do you want to install the sample store? (y/n)? " yn
case $yn in 
  [yY]* )
  read -e -p "Path to sample store zip archive: " sample_store
  test ! -e $sample_store && echo "sample store archive $sample_store not found." && exit 1
  echo "Install sample store ...";
  mkdir sampledata 
  unzip $sample_store -d sampledata 
  cp -au sampledata/magento-sample-data*/skin magento
  cp -au sampledata/magento-sample-data*/media magento 
  echo "Insert sample data into database $database_name (enter SQL root pass)" 
  mysql -u root -p $database_name < sampledata/magento-sample-data*/magento_sample_data_*.sql
  rm -r sampledata 
  ;; 
esac

read -p "Enter name for store webroot: " store_name 

echo "Move magento folder to $store_name" 
mv magento /var/www/html/$store_name 

echo "Set permissions for $store_name" 
chown -R www-data /var/www/html/$store_name 
find /var/www/html/$store_name  -type d -exec chmod 700 {} \;
find /var/www/html/$store_name  -type f -exec chmod 600 {} \;
echo "Done. Open localhost/$store_name in browser and proceed installation script"
