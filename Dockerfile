FROM alpine:latest

COPY ./output/goraftd /app/goraftd
WORKDIR /app

CMD ["./goraftd"]