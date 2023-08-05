FROM golang:bullseye AS builder
ARG XRAY_UI_REPO="https://github.com/MODSBOTS-GCP/radepa-x-ui"
RUN git clone ${XRAY_UI_REPO} --depth=1
WORKDIR /go/radepa-x-ui
RUN go build -a -ldflags "-linkmode external -extldflags '-static' -s -w"

FROM alpine
LABEL org.opencontainers.image.authors="https://github.com/jvdi"
COPY --from=builder /go/radepa-x-ui /usr/local/bin/radepa-x-ui

ENV TZ=Asia/Tehran
RUN apk add --no-cache ca-certificates tzdata 

ARG TARGETARCH
COPY --from=teddysun/xray /usr/bin/xray /usr/local/bin/bin/xray-linux-${TARGETARCH}
COPY --from=teddysun/xray /usr/share/xray/ /usr/local/bin/bin/

VOLUME [ "/etc/radepa-x-ui" ]
WORKDIR /usr/local/bin
CMD [ "radepa-x-ui" ]
