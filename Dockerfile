FROM golang:1.20  as building-stage

RUN mkdir /build
COPY ./*.go ./*.mod ./*.sum /build

COPY ./Makefile /build

WORKDIR /build

RUN make

FROM fluent/fluent-bit:2.0.9

LABEL maintainer="Denis Zheleztsov"

COPY --from=building-stage /build/out_rabbitmq.so  /fluent-bit/bin/
COPY ./conf/fluent-bit.conf /fluent-bit/etc

EXPOSE 2020

CMD [ "/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf", "-e", "/fluent-bit/bin/out_rabbitmq.so" ]
