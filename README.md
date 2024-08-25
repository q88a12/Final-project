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
1.Установите Ansible

    sudo apt install ansible

2.Установите Git, если он еще не установлен

    sudo apt install git
    
3.Клонируйте репозиторий

    git clone https://github.com/q88a12/Final-project.git

4.Перейдите в директорию проекта

    cd Final-project.git

5.Запустите Ansible playbook

    ansible-playbook -i inventory/production playbooks/main.yml --extra-vars "variable_name=value"

### Настройка

Перед запуском playbook необходимо настроить следующие параметры в файле playbook.yml:

    IP-адреса серверов: nginx_ip, apache_ip_1, apache_ip_2, mysql_master_ip, mysql_slave_ip, prometheus_grafana_ip, elk_ip

    Пароли: mysql_root_password, mysql_replication_password, wordpress_password

    Доменное имя: wordpress_url

