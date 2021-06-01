FROM --platform=$BUILDPLATFORM alpine:3 as builder

ARG ZREPL_VERSION
ARG TARGETARCH
ARG TARGETVARIANT
ENV TARGET="$TARGETARCH$TARGETVARIANT"

RUN apk add --no-cache curl
RUN mkdir -p /root/usr/local/bin/
RUN curl -L --fail -o /root/usr/local/bin/zrepl "https://github.com/zrepl/zrepl/releases/download/$ZREPL_VERSION/zrepl-linux-$TARGET"

FROM alpine:3 as image
COPY --from=builder /root /
ENTRYPOINT ["zrepl"]
