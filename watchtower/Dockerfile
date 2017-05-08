FROM centurylink/ca-certs
MAINTAINER Fabrizio Steiner <stffabi@users.noreply.github.com>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL com.centurylinklabs.watchtower=true \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/v2tec/docker-watchtower" \
      org.label-schema.version="$VERSION" \
      org.label-schema.schema-version="1.0"

COPY watchtower /
ENTRYPOINT ["/watchtower"]