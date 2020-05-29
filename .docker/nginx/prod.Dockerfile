# NPM dependencies.
FROM node:12 AS npm-build

WORKDIR /var/www/html

COPY package.json package-lock.json webpack.mix.js /var/www/html/
COPY resources /var/www/html/resources/
COPY public /var/www/html/public/

RUN npm ci
RUN npm run production

# Nginx production.
FROM nginx:1.17

COPY .docker/nginx/nginx_template_prod.conf /etc/nginx/conf.d/default.conf
COPY --chown=www-data --from=npm-build /var/www/html/public/ /var/www/html/public/
COPY --chown=www-data . /var/www/html
