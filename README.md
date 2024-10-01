# Создание отказоустойчивой инфраструктуры веб-приложения с балансировкой нагрузки, репликацией баз данных и системой мониторинга

## Описание проекта

Этот проект представляет собой Ansible playbook для автоматизированного развертывания отказоустойчивой инфраструктуры веб-приложения. Включает в себя балансировку нагрузки, репликацию базы данных MySQL и систему мониторинга с использованием Prometheus и Grafana.

## Инфраструктура проекта

![Диаграмма инфраструктуры](https://github.com/user-attachments/assets/8ab4bd73-1b81-4475-8b05-953166d9c29a)

- **Балансировка нагрузки (Nginx)**: Используется для распределения нагрузки между двумя веб-серверами Apache.
- **Веб-серверы (Apache)**: Два сервера Apache с PHP для работы веб-приложения WordPress.
- **База данных (MySQL master-slave)**: Настроена в режиме репликации для обеспечения высокой доступности данных.
- **Мониторинг**: Prometheus собирает метрики с различных сервисов, а Grafana визуализирует их.
- **Логирование**: Elasticsearch, Logstash и Kibana используются для обработки и визуализации логов.

## Стек технологий

- **Ansible**: Автоматизация развертывания и настройки
- **Nginx**: Балансировщик нагрузки
- **Apache**: Веб-сервер
- **PHP**: Язык программирования для веб-приложения
- **MySQL**: Система управления базами данных
- **Prometheus**: Система мониторинга
- **Grafana**: Визуализация данных мониторинга
- **Elasticsearch**: Поиск и аналитика логов
- **Kibana**: Визуализация логов
- **Filebeat**: Агент для сбора логов

## Предварительные требования

- Несколько виртуальных машин или серверов с установленной операционной системой Ubuntu.

## Установка

1. Установите Ansible:
   ```bash
   sudo apt install ansible sshpass
   ```

2. Установите Git (если не установлен):
   ```bash
   sudo apt install git
   ```

3. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/q88a12/Final-project.git
   ```

4. Перейдите в директорию проекта:
   ```bash
   cd Final-project
   ```

5. Запустите Ansible playbook:
   ```bash
   ansible-playbook -i ./inventory.ini ./playbook.yml --extra-vars "variable_name=value"
   ```

## Настройка

Перед запуском playbook необходимо настроить следующие параметры в файле `vars.yml`:

- **IP-адреса серверов**: `nginx_ip`, `apache_ip_1`, `apache_ip_2`, `mysql_master_ip`, `mysql_slave_ip`, `prometheus_grafana_ip`, `elk_ip`
- **Пароли**: `mysql_root_password`, `mysql_replication_password`, `wordpress_password`
- **Доменное имя**: `wordpress_url`

Также в директории `inventory` находится файл `hosts.ini`, где необходимо определить логины, пароли и IP-адреса серверов:

```ini
nginx_load_balancer ansible_host=<IP_ADDRESS>
apache_server_1 ansible_host=<IP_ADDRESS>
apache_server_2 ansible_host=<IP_ADDRESS>
mysql_master ansible_host=<IP_ADDRESS>
mysql_slave ansible_host=<IP_ADDRESS>

[apache_servers]
apache_server_1
apache_server_2

[localhost]
localhost ansible_connection=local
```

## Проверка работоспособности

### Проверка Nginx и проксирования Apache

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

### Проверка WordPress и удаленной базы данных MySQL

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

### Проверка репликации MySQL (Master-Slave)

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

### Проверка ELK стека (Elasticsearch, Logstash, Kibana)

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

5. **Проверка состояния Prometheus:**
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
