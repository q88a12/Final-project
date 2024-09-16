#!/bin/bash

# MySQL backup script

PATH=$PATH:/usr/local/bin

DIR=`date +"%Y-%m-%d"`
DATE=`date +"%Y%m%d"`
MYSQL='mysql --skip-column-names -u {{ mysql_backup_user }} -p{{ mysql_backup_password }}'
MYSQLDUMP='mysqldump --single-transaction --routines --events --triggers --master-data=2 -u {{ mysql_backup_user }} -p{{ mysql_backup_password }}'

for db in `$MYSQL -e "SHOW DATABASES LIKE '%\_db'"`; do
    mkdir -p $DIR/$db
    $MYSQLDUMP --databases $db | gzip -1 > $DIR/$db/$db.sql.gz
    if [ $? -ne 0 ]; then
        echo "Ошибка резервного копирования базы данных $db"
        exit 1
    fi

    for table in `$MYSQL -D $db -e "SHOW TABLES"`; do
        $MYSQLDUMP --skip-lock-tables --no-create-info $db $table | gzip -1 > $DIR/$db/$table.sql.gz
        if [ $? -ne 0 ]; then
            echo "Ошибка резервного копирования таблицы $table базы данных $db"
            exit 1
        fi
    done
done

# Удалить резервные копии старше 7 дней
find $DIR -mtime +7 -delete

echo "Резервное копирование MySQL завершено"
