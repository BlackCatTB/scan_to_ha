ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_ARCH
ARG BUILD_VERSION

RUN apk add --no-cache \
    nodejs \
    npm \
    && npm install --global --omit=dev node-hp-scan-to

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
