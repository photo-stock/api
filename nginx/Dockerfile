FROM nginx:1.27-alpine


RUN rm -rf /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf

RUN apk add --no-cache iputils bash busybox-extras

CMD ["sh", "-c", "while :; do sleep 1; done"]
