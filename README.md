# Docker-file

## etcd

version: 3.3.8

启用集群需在run.sh的conf变量中添加对应的配置，推荐discovery
修改完discovery后，删除etcd使用的/data目录，重新选举下
