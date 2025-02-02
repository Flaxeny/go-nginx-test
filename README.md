# Go + Nginx + Docker

Этот репозиторий демонстрирует три различных способа настройки и запуска Go-приложения с Nginx:
1. **Локальный запуск Go и Nginx на Linux**
2. **Запуск через Docker и Docker Compose**
3. **Запуск Go-приложения локально, а Nginx — на удаленном сервере**

---

## 1. Локальный запуск Go и Nginx на Linux

### **1.1 Установка Go**
Если у вас не установлен Go, установите его:
```sh
sudo apt update && sudo apt install -y golang
```

### **1.2 Запуск Go-приложения**

1. Склонируйте репозиторий:
   ```sh
   git clone https://github.com/Flaxeny/go-nginx-test.git
   cd go-nginx-test
   ```

2. Запустите Go-приложение:
   ```sh
   go run main.go
   ```
   Оно будет работать на `http://localhost:8080`.

### **1.3 Настройка и запуск Nginx**

1. Установите Nginx:
   ```sh
   sudo apt update
   sudo apt install -y nginx
   ```

2. Создайте конфигурацию для Nginx:
   ```sh
   sudo nano /etc/nginx/sites-available/go_app
   ```
(конфигурационный файл nginx.conf находится в корневой папке)

   Добавьте следующее содержимое:
   ```nginx
   server {
       listen 80;
       server_name localhost;

       location / {
           proxy_pass http://127.0.0.1:8080;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       }
   }
   ```

3. Создайте символическую ссылку:
   ```sh
   sudo ln -s /etc/nginx/sites-available/go_app /etc/nginx/sites-enabled/
   ```

4. Проверьте конфигурацию и перезапустите Nginx:
   ```sh
   sudo nginx -t
   sudo systemctl restart nginx
   ```

Теперь приложение доступно на `http://localhost` через Nginx.

---

## 2. Запуск через Docker и Docker Compose

### **2.1 Установка Docker и Docker Compose**
```sh
sudo apt update
sudo apt install -y docker.io docker-compose
```

### **2.2 Сборка и запуск контейнеров**

1. Склонируйте репозиторий и перейдите в директорию проекта:
   ```sh
   git clone https://github.com/Flaxeny/go-nginx-test.git
   cd go-nginx-test
   ```

2. Запустите контейнеры:
   ```sh
   docker-compose up --build -d
   ```

3. Проверьте запущенные контейнеры:
   ```sh
   docker ps
   ```

4. Перейдите в браузере на `http://localhost`, чтобы увидеть `Hello, World!`.

5. Для остановки контейнеров:
   ```sh
   docker-compose down
   ```

---

## 3. Запуск Go локально, а Nginx — на удаленном сервере

### **3.1 Локальный запуск Go-приложения**

1. Склонируйте репозиторий и запустите приложение:
   ```sh
   git clone https://github.com/Flaxeny/go-nginx-test.git
   cd go-nginx-test
   go run main.go
   ```

Приложение запустится на `http://localhost:8080`.

2. Настройте туннелирование для удаленного сервера (замените `remote_server_ip` на IP вашего сервера):
   ```sh
   ssh -R 8080:localhost:8080 root@remote_server_ip
   ```

### **3.2 Настройка Nginx на удаленном сервере**

1. Подключитесь к серверу через SSH и установите Nginx:
   ```sh
   ssh root@remote_server_ip
   sudo apt update
   sudo apt install -y nginx
   ```

2. Настройте Nginx:
   ```sh
   sudo nano /etc/nginx/sites-available/go_app
   ```
(конфигурационный файл  лежит в nginx.conf расположенном в папке v2)

   Добавьте:
   ```nginx
   server {
       listen 80;
       server_name remote_server_ip;

       location / {
           proxy_pass http://127.0.0.1:8080;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       }
   }
   ```

3. Создайте символическую ссылку и перезапустите Nginx:
   ```sh
   sudo ln -s /etc/nginx/sites-available/go_app /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

4. Разрешите входящий HTTP-трафик:
   ```sh
   sudo ufw allow 80/tcp
   sudo ufw reload
   ```

Теперь Go-приложение работает локально, а Nginx проксирует запросы на удаленном сервере.

---



