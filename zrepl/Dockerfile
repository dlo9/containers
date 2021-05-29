ARG VERSION=v0.4.0
ARG ARCH=amd64

FROM alpine:3 as builder
RUN apk add --no-cache curl
RUN mkdir -p /root/usr/local/bin/
RUN curl -L -o /root/usr/local/bin/zrepl "https://github.com/zrepl/zrepl/releases/download/$VERSION/zrepl-linux-$ARCH"

FROM alpine:3 as image
COPY --from=builder /root /
ENTRYPOINT ["zrepl"]
