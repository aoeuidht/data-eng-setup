CREATE USER 'dbuser'@'%' IDENTIFIED BY 'dbuser';
GRANT ALL PRIVILEGES ON * . * TO 'dbuser'@'%';
FLUSH PRIVILEGES;
CREATE DATABASE hive CHARACTER SET utf8 COLLATE utf8_general_ci;