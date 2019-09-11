FROM fluent/fluentd:v1.7-1
USER root
WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.3.0/bin:$PATH

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        build-base \
        ruby-dev \
    && echo 'gem: --no-document' >> /etc/gemrc \
    && gem install fluent-plugin-prometheus \
    && gem install fluent-plugin-rewrite-tag-filter \
    && gem install fluent-plugin-record-modifier \
    && apk del .build-deps \
    && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

# Copy configuration files
COPY ./fluent.conf /fluentd/etc/

# Environment variables
ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"
ENV FLUENT_UID=0

# Run Fluentd
CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF $FLUENTD_OPT
