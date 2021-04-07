FROM nginx

RUN apt update

ADD nginx.conf /etc/nginx/template/nginx.conf
ADD docker_entrypoint.sh docker_entrypoint.sh

ENTRYPOINT ["./docker_entrypoint.sh"]
