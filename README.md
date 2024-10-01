# Создание отказоустойчивой инфраструктуры веб-приложения с балансировкой нагрузки, репликацией баз данных и системой мониторинга

### Описание проекта
Этот проект представляет собой Ansible playbook для автоматизированного развертывания отказоустойчивой инфраструктуры веб-приложения. Инфраструктура включает балансировку нагрузки, репликацию базы данных MySQL и систему мониторинга с использованием Prometheus и Grafana.

### Инфраструктура проекта:
![Диаграмма без названия drawio](https://github.com/user-attachments/assets/8ab4bd73-1b81-4475-8b05-953166d9c29a)

- Балансировка нагрузки (Nginx balanser): Nginx используется для распределения нагрузки между двумя веб-серверами Apache.
- Веб-серверы (Apache servers): Два сервера Apache с PHP обеспечивают работу веб-приложения WordPress.
- База данных (MySQL master-slave): MySQL настроен в режиме master-slave репликации для обеспечения высокой доступности данных.
- Мониторинг (Remote PC): Prometheus собирает метрики с различных сервисов, а Grafana предоставляет удобный интерфейс для их визуализации.
- Логирование (Remote PC): Elasticsearch, Logstash и Kibana используются для сбора, обработки и визуализации логов.

### Стек технологий

- Ansible: Автоматизация развертывания и настройки
- Nginx: Балансировщик нагрузки
- Apache: Веб-сервер
- PHP: Язык программирования для веб-приложения
- MySQL: База данных
- Prometheus: Система мониторинга
- Grafana: Визуализация данных мониторинга
- Elasticsearch: Поиск и аналитика логов
- Kibana: Визуализация логов
- Filebeat: Агент для сбора логов

### Предварительные требования
- Несколько виртуальных машин или серверов с установленной операционной системой Ubuntu.


### Установка
1.Установите Ansible:

    sudo apt install ansible sshpass

2.Установите Git, если он еще не установлен:

    sudo apt install git
    
3.Клонируйте репозиторий:

    git clone https://github.com/q88a12/Final-project.git

4.Перейдите в директорию проекта:

    cd Final-project

5.Запустите Ansible playbook:

    ansible-playbook -i ./inventory.ini ./playbook.yml --extra-vars "variable_name=value"

### Настройка
Перед запуском playbook необходимо настроить следующие параметры в файле vars.yml

IP-адреса серверов: nginx_ip, apache_ip_1, apache_ip_2, mysql_master_ip, mysql_slave_ip, prometheus_grafana_ip, elk_ip
Пароли: mysql_root_password, mysql_replication_password, wordpress_password
Доменное имя: wordpress_url

Проверка работоспособности
# Проект: Мониторинг и резервное копирование веб-приложений

## Описание

Этот проект настраивает и проверяет работоспособность Nginx, Apache, WordPress и стека ELK (Elasticsearch, Logstash, Kibana). Также реализовано резервное копирование базы данных MySQL с помощью автоматизированных задач.

## Проверка Nginx и проксирования Apache

1. **Проверка статуса службы Nginx:**
   ```bash
   sudo systemctl status nginx
   ```

2. **Проверка доступности порта 80 на Nginx:**
   ```bash
   sudo ss -ntlp | grep :80
   ```

3. **Проверка конфигурации Nginx:**
   ```bash
   sudo nginx -t
   ```

4. **Тестирование проксирования Nginx:**
   Откройте браузер и введите адрес, настроенный в Nginx (например, `http://example.com` или IP-адрес Nginx).

5. **Проверка доступности порта 80 на Apache:**
   ```bash
   sudo ss -ntlp | grep :80
   ```

## Проверка WordPress и удаленной базы данных MySQL

1. **Открытие конфигурационного файла WordPress:**
   ```bash
   sudo nano /var/www/html/wordpress/wp-config.php
   ```

2. **Проверка подключения к MySQL:**
   ```bash
   mysql -h 192.168.1.104 -u wordpress_user -p
   ```

3. **Проверка порта 3306 на MySQL Master:**
   ```bash
   sudo ss -ntlp | grep :3306
   ```

4. **Проверка базы данных WordPress:**
   ```bash
   mysql -u root -p
   SHOW DATABASES;
   ```

## Проверка репликации MySQL (Master-Slave)

1. **Проверка состояния репликации на MySQL Slave:**
   ```bash
   mysql -u root -p
   SHOW SLAVE STATUS\G;
   ```
   Убедитесь, что:
   - `Slave_IO_Running` и `Slave_SQL_Running` имеют значение `Yes`.
   - `Last_Error` пустой.

2. **Проверка синхронизации данных:**
   - На MySQL Master создайте новую запись:
   ```bash
   mysql -u root -p
   USE wordpress;
   INSERT INTO test_table (name) VALUES ('Replication test');
   ```

   - На MySQL Slave проверьте наличие этой записи:
   ```bash
   mysql -u root -p
   USE wordpress;
   SELECT * FROM test_table;
   ```

## Проверка ELK стека (Elasticsearch, Logstash, Kibana)

1. **Проверка состояния Elasticsearch:**
   ```bash
   sudo systemctl status elasticsearch
   ```

2. **Проверка доступа к Elasticsearch:**
   ```bash
   curl -X GET http://localhost:9200/
   ```

3. **Проверка состояния Logstash:**
   ```bash
   sudo systemctl status logstash
   ```

4. **Проверка работоспособности Kibana:**
   ```bash
   sudo systemctl status kibana
   ```

5. **Проверка мониторинга:**
   - **Проверка состояния Prometheus:**
   ```bash
   sudo systemctl status prometheus
   ```

   - **Проверка доступности Prometheus:**
   Откройте Prometheus в браузере (например, `http://localhost:9090`).

   - **Проверка Grafana:**
   Откройте Grafana по адресу `http://localhost:3000`, создайте новый дашборд и добавьте панель для отображения метрик Prometheus.

## Резервное копирование

1. **Проверка наличия файлов резервного копирования:**
   ```bash
   ls -l /tmp/
   ```

2. **Проверка заданий cron:**
   ```bash
   crontab -l
   ```

---

Эта структура поможет пользователям быстро найти нужную информацию и понять, как использовать проект.
