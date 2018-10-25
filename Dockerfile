FROM xataz/alpine:3.7

LABEL description="sickrage based on alpine" \
      tags="latest" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="201806190432" \
      commit="807c5ae37ecd5af7483f06459c94788ee9db483d"

ENV WEBROOT="/" \
    UID="991" \
    GID="991"

RUN export BUILD_DEPS="py2-pip" \
    && apk add -U python \
                git \
                s6 \
                su-exec \
                unrar \
                libmediainfo \
                mediainfo \
                ${BUILD_DEPS} \
    && git clone https://github.com/SickChill/SickChill.git /SickRage \
    && apk del ${BUILD_DEPS} \
    && rm -rf /var/cache/apk/* ~/.pip/cache/*

COPY rootfs /
RUN chmod +x /usr/local/bin/startup /etc/s6.d/*/*

VOLUME ["/config"]
EXPOSE 8081

ENTRYPOINT ["/usr/local/bin/startup"]
CMD ["/bin/s6-svscan", "/etc/s6.d"]
