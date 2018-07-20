#!/bin/bash
if [[ "${1:0:1}" != '-' && "x$1" != "x/bin/etcd" ]]; then
  exec $@
fi

NODE_NAME=${HOSTNAME}

echo -n "$(date +%F\ %T) I | Running "
/bin/etcd --version

# lock file to make sure we're not running multiple containers on the same volume
LOCK_FILE=/etcd-data/ctr.lck

IPADD=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`

CONF="
name: ${HOSTNAME}                                                          
\ndata-dir: /data                                                           
\nlisten-client-urls: http://${IPADD}:2379,http://127.0.0.1:2379             
\nadvertise-client-urls: http://${IPADD}:2379,http://127.0.0.1:2379            
\nlisten-peer-urls: http://${IPADD}:2380                                         
\ninitial-advertise-peer-urls: http://${IPADD}:2380
\ninitial-cluster-token: etcd-cluster-token                                       
\ninitial-cluster-state: new
"

echo -e $CONF > /etc/etcd/conf.yml

ARGS="--config-file=/etc/etcd/conf.yml" 

exec flock -xn $LOCK_FILE /bin/etcd $ARGS

