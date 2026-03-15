ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_ARCH
ARG BUILD_VERSION

RUN apk add --no-cache \
    nodejs \
    npm \
    && npm install --global --omit=dev node-hp-scan-to

# Register as an s6-overlay service so s6 (PID 1) manages the process
RUN mkdir -p /etc/services.d/hp_scan
COPY run.sh /etc/services.d/hp_scan/run
RUN chmod a+x /etc/services.d/hp_scan/run
