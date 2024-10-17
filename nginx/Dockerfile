FROM nginx:1.27-alpine


RUN rm -rf /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf

RUN apt-get update && apt-get install -y iputils-ping netcat

CMD ["sh", "-c", "while :; do sleep 1; done"]
