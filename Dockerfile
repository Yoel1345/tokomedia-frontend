FROM nginx:alpine
EXPOSE 8080
COPY build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
