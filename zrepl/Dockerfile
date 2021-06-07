FROM --platform=$BUILDPLATFORM alpine:3 as builder

ARG ZREPL_VERSION
ARG TARGETARCH
ARG TARGETVARIANT
ENV TARGET="$TARGETARCH$TARGETVARIANT"

RUN apk add --no-cache curl
RUN mkdir -p /root/usr/local/bin/
RUN curl -L --fail -o /root/usr/local/bin/zrepl "https://github.com/zrepl/zrepl/releases/download/$ZREPL_VERSION/zrepl-linux-$TARGET" && \
	chmod +x /root/usr/local/bin/zrepl

FROM alpine:3 as image
LABEL org.opencontainers.image.url=https://github.com/dlo9/containers/tree/main/zrepl \
      org.opencontainers.image.documentation=https://github.com/dlo9/containers/tree/main/zrepl/README.md \
      org.opencontainers.image.source=https://github.com/dlo9/containers/tree/main/zrepl/Dockerfile \
      org.opencontainers.image.version=$ZREPL_VERSION \
      org.opencontainers.image.title=zrepl \
      org.opencontainers.image.authors=dlo9 \
      org.opencontainers.image.description="A containerized version of zrepl"

# Create runtime directories
# https://zrepl.github.io/configuration/misc.html
RUN mkdir -p /var/run/zrepl/stdinserver && chmod -R 0700 /var/run/zrepl

# Dependencies:
#   zfs: Obvious reasons
#   gcompat: For /lib64/ld-linux-x86-64.so.2
RUN apk --no-cache add gcompat zfs
COPY --from=builder /root /
ENTRYPOINT ["zrepl"]
CMD ["daemon"]
