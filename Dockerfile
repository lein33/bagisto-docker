# Imagen base oficial de PHP con Apache
FROM php:8.3-apache

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Instalar extensiones necesarias de PHP
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    zip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    && docker-php-ext-install pdo pdo_mysql zip gd
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && docker-php-ext-install gd
RUN apt-get install -y libmagickwand-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick
    RUN docker-php-ext-configure intl && docker-php-ext-install intl

    # other extensions install
    RUN docker-php-ext-install bcmath calendar exif gmp mysqli pdo pdo_mysql zip
    
    # installing composer
    COPY --from=composer:2.7 /usr/bin/composer /usr/local/bin/composer
    
    # installing node js
    COPY --from=node:23 /usr/local/lib/node_modules /usr/local/lib/node_modules
    COPY --from=node:23 /usr/local/bin/node /usr/local/bin/node
    RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
    
    # installing global node dependencies
    RUN npm install -g npx
# Habilitar el módulo de reescritura de Apache
RUN a2enmod rewrite

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Clonar Bagisto desde GitHub (puedes cambiar esto por una copia local si ya lo tienes)
RUN git clone https://github.com/bagisto/bagisto.git .

# Instalar dependencias PHP con Composer
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Copiar archivo .env de ejemplo y configurarlo
RUN cp .env.example .env

# Generar la clave de la aplicación y configurar entorno de producción
RUN php artisan key:generate && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# Cambiar permisos necesarios
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Variables de entorno (ajusta si usas Railway Env Vars)
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV APP_URL=https://your-domain.railway.app

# Railway expone el puerto 8080
EXPOSE 8080

# Cambiar el puerto por defecto de Apache a 8080 (requerido por Railway)
RUN sed -i 's/80/8080/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# Comando para ejecutar Apache en primer plano
CMD ["apache2-foreground"]
