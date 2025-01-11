# Usar a imagem oficial do PHP com FPM
FROM php:8.1-fpm

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Instalar extensões do PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir o diretório de trabalho
WORKDIR /var/www/html

# Copiar o arquivo de configuração PHP
COPY ./php.ini /usr/local/etc/php/

# Garantir que as permissões estejam corretas
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expor a porta 9000 para PHP-FPM
EXPOSE 9000

# Comando de inicialização
CMD ["php-fpm"]
