## P2P 端口映射工具
通过 UDP hole punching 实现两个 NAT 网络后主机之间端口映射的临时快捷脚本

依赖关系处理挺麻烦，所以设计上仅支持 docker 方式使用, [Docker Hub Image](https://hub.docker.com/r/imfms/p2p-port-mapping)

原理

- 通过 [delthas/proxypunch](https://github.com/delthas/proxypunch) 实现 UDP hole punching 功能, 映射 UDP 协议端口
  该库依赖delthas自己的服务器，如果作者服务器停止运行的话本工具也随之无法使用
- 通过 [xtaci/kcptun](https://github.com/xtaci/kcptun) 在UDP协议上模拟 TCP 协议

------

### 交互式操作

直接复制粘贴到命令行中即可

#### Server

```shell
sh <(cat << "EOF"
set -e
field() { echo -n "\${$1:$2}: " 1>&2; CONTENT=$(head -n 1); echo ${CONTENT:-$2}; }

PUNCH_UDP_PORT=$(field PUNCH_UDP_PORT 55555)
OPEN_SERVICE_IP=$(field OPEN_SERVICE_IP docker.host)
OPEN_SERVICE_PORT=$(field OPEN_SERVICE_PORT )
KCPTUN_ARGUMENTS=$(field KCPTUN_ARGUMENTS/可选)

set -x
docker run -it --rm --add-host=docker.host:host-gateway \
    -e PUNCH_UDP_PORT=$PUNCH_UDP_PORT \
    -e OPEN_SERVICE_IP=docker.host \
    -e OPEN_SERVICE_PORT=$OPEN_SERVICE_PORT \
    -e KCPTUN_ARGUMENTS="$KCPTUN_ARGUMENTS" \
    imfms/p2p-port-mapping tcp-server.sh

EOF
)

```

#### Client

```shell
sh <(cat << "EOF"
set -e
field() { echo -n "\${$1:$2}: " 1>&2; CONTENT=$(head -n 1); echo ${CONTENT:-$2}; }

PUNCH_UDP_HOST=$(field PUNCH_UDP_HOST)
PUNCH_UDP_PORT=$(field PUNCH_UDP_PORT 55555)
LOCAL_OPEN_PORT=$(field LOCAL_OPEN_PORT 55555)
KCPTUN_ARGUMENTS=$(field KCPTUN_ARGUMENTS/可选)

set -x
docker run -it --rm \
    -e PUNCH_UDP_HOST=$PUNCH_UDP_HOST \
    -e PUNCH_UDP_PORT=$PUNCH_UDP_PORT \
    -e LOCAL_OPEN_PORT=$LOCAL_OPEN_PORT \
    -e KCPTUN_ARGUMENTS="$KCPTUN_ARGUMENTS" \
    -p $LOCAL_OPEN_PORT:$LOCAL_OPEN_PORT \
    imfms/p2p-port-mapping tcp-client.sh

EOF
)

```

### 命令式操作

手动替换变量后执行

#### Server

```shell
docker run -it --rm --add-host=docker.host:host-gateway \
    -e PUNCH_UDP_PORT=$PUNCH_UDP_PORT \
    -e OPEN_SERVICE_IP=docker.host \
    -e OPEN_SERVICE_PORT=$OPEN_SERVICE_PORT \
    -e KCPTUN_ARGUMENTS="" \
    imfms/p2p-port-mapping tcp-server.sh
```

#### Client

```shell
docker run -it --rm \
    -e PUNCH_UDP_HOST=$PUNCH_UDP_HOST \
    -e PUNCH_UDP_PORT=$PUNCH_UDP_PORT \
    -e LOCAL_OPEN_PORT=$LOCAL_OPEN_PORT \
    -e KCPTUN_ARGUMENTS="" \
    -p $LOCAL_OPEN_PORT:$LOCAL_OPEN_PORT \
    imfms/p2p-port-mapping tcp-client.sh
```

