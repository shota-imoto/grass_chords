FROM nginx:stable

RUN rm -f /etc/nginx/conf.d/*

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf"]
