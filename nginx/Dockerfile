FROM nginx:stable

RUN rm -f /etc/nginx/conf.d/default.conf
RUN rm -rf /etc/nginx/conf.d
RUN rm -f /etc/nginx/nginx.conf

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./mime.types /etc/nginx/mime.types

CMD ["/usr/sbin/nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf"]
