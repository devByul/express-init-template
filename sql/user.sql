CREATE USER 'hauto'@'localhost' IDENTIFIED BY 'hauto';
GRANT ALL PRIVILEGES ON hauto.* to 'hauto'@'localhost';
GRANT SHOW_ROUTINE, SET_USER_ID ON *.* to 'hauto'@'localhost';
CREATE USER 'hauto'@'%' IDENTIFIED BY 'hauto';
GRANT ALL PRIVILEGES ON hauto.* to 'hauto'@'%';

CREATE USER 'hauto'@'192.168.10.57' IDENTIFIED BY 'hauto';
GRANT ALL PRIVILEGES ON hauto.* to 'hauto'@'192.168.10.57';
CREATE USER 'hauto'@'192.168.10.27' IDENTIFIED BY 'hauto';
GRANT ALL PRIVILEGES ON hauto.* to 'hauto'@'192.168.10.27';
GRANT SHOW_ROUTINE, SET_USER_ID ON *.* to 'hauto'@'192.168.10.27';

FLUSH PRIVILEGES;