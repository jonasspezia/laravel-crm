FROM php:8.1-fpm

# Etapa 2: Instalar extensões e dependências do PHP
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl

# Etapa 3: Instalar extensões do PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Etapa 4: Configurar o diretório de trabalho
WORKDIR /var/www

# Etapa 5: Instalar o Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

# Etapa 6: Copiar arquivos da aplicação
COPY . /var/www

# Etapa 7: Configurar permissões
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage

# Etapa 8: Instalar dependências do Composer
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Etapa 9: Expor a porta 9000 e iniciar o PHP-FPM
EXPOSE 9000
CMD ["php-fpm"]
