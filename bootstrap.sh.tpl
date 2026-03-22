#!/bin/bash

# 1. Оновлення списку пакетів та встановлення вебсервера Apache2
apt-get update
apt-get install -y apache2

# 2. Налаштування кастомного TCP порту (8080)
# Terraform автоматично замінить ${web_port} на 8080 під час розгортання
sed -i "s/Listen 80/Listen ${web_port}/" /etc/apache2/ports.conf

# 3. Створення та конфігурування DocumentRoot
# Згідно з варіантом 6, шлях: /var/www/site_06
DOC_ROOT="/var/www/site_06"
mkdir -p $DOC_ROOT

# 4. Створення сторінки index.html
cat <<EOF > $DOC_ROOT/index.html
<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Лабораторна 3 - Варіант 6</title>
</head>
<body>
    <h1>Вітаю! Це вебсервер для Лабораторної №3.</h1>
    <p>Виконав: Зозуля Віктор (Варіант 6)</p>
    <p>Сервіс успішно налаштовано за допомогою Terraform та Cloud-Init!</p>
</body>
</html>
EOF

# 5. Надання прав доступу системному користувачу Apache (www-data)
chown -R www-data:www-data $DOC_ROOT
chmod -R 755 $DOC_ROOT

# 6. Налаштування віртуального хосту (VirtualHost) та
# 7. Модифікація для запобігання помилки '403 Forbidden'
# Згідно з варіантом 6, ServerName: var6.local
cat <<EOF > /etc/apache2/sites-available/var6.conf
<VirtualHost *:${web_port}>
    ServerName var6.local
    DocumentRoot $DOC_ROOT

    # Надаємо права доступу до директорії, щоб уникнути 403 Forbidden
    <Directory $DOC_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
EOF

# 8. Активація змін та перезапуск служби
a2ensite var6.conf
a2dissite 000-default.conf
systemctl restart apache2