FROM alpine:latest

# Install etcd
RUN apk add --update ca-certificates openssl tar bind-tools tini bash
RUN wget https://github.com/coreos/etcd/releases/download/v3.3.8/etcd-v3.3.8-linux-amd64.tar.gz && \
    tar zxvf etcd-v3.3.8-linux-amd64.tar.gz && \
    mv etcd-v3.3.8-linux-amd64/etcd* /bin/ && \
    rm -Rf etcd-v3.3.8-linux-amd64* /var/cache/apk/*

# Copy config file
RUN mkdir -p /etc/etcd/
COPY conf.yml /etc/etcd/

# Add etcd RUN FILE
COPY run.sh /bin/
RUN chmod -R 755 /bin/run.sh


VOLUME /etcd-data

EXPOSE 2379 2380
ENV ETCDCTL_API=3

# Define default command.
ENTRYPOINT ["/sbin/tini", "--", "/bin/run.sh"]

