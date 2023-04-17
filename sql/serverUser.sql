CREATE USER 'hauto'@'%' IDENTIFIED BY '/answer4321';
GRANT ALL PRIVILEGES ON hauto.* to 'hauto'@'%';
GRANT SHOW_ROUTINE, SET_USER_ID ON *.* TO 'hauto'@'%'; # 추가해야함 1/5
FLUSH PRIVILEGES;
