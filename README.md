# Data Eng Setup
这个 Repo 用来搭建给 Data Eng 提供服务的平台,包括:


- [x] 多节点 HDFS
- [x] Hive
- [x] Spark
- [x] Jupyter Notebook + Pyspark
- [ ] Superset
- [ ] Airflow
- [ ] Kerberos
- [ ] Ranger

### Requirements

一台能够运行 ansible 的 Windows/Mac/Linux 设备, 下文用 $P0 代替

四台服务器,配置见下一节

### 服务器配置

|介绍 | 要求 |
|-----|---------|
|数量 | 4 |
|操作系统 | Ubuntu 2404 |
|磁盘 | 大小随意,取决于需要存储多少数据 |
|网络  | 固定 IP 且能够访问互联网(用于下载/安装所需要的软件) |

四台服务器其中一台用作 NameNode ($nn0), 其余三台用作 DataNode($dn0 - $dn2).

### 前期准备

#### 准备需要的软件包
##### 克隆本仓库,放置在 $P0 随便哪个目录下, 下文用 $path 表示该目录

##### 下载以下文件, 储存到 $path/dist 目录下
|url | 本地文件 |
|-----|-------------|
| https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz | dist/hadoop-3.3.6.tar.gz |
| https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz  | dist/apache-hive-3.1.3-bin.tar.gz |
| https://dlcdn.apache.org/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz | dist/spark-3.5.1-bin-hadoop3.tgz |

##### 修改 hosts 文件, ansible_inventory.ini
将 config/hosts 和 ansible_inventory.ini 的 $nn0, $dn0, $dn1, $dn2 替换为服务器的 ip 地址.

如果你有更多的 datanode, 需要在以上两个文件中,增加对应的服务器列表.同时将需要安装 jupyterlab/pyspark 的 ip 地址列表,写到 pyspark 里面.

##### workers
修改下列文件,将 workers 列表写入文件:
```
config/opt/hadoop-3.3.6/etc/hadoop/workers
config/opt/spark-3.5.1-bin-hadoop3/conf/workers
```


##### [可选] 生成 ssh-key
如果不是生产环境, 这一步可以忽略.
使用 ssh-keygen 生成一对 ssh 密钥,替换掉 `config/id_rsa` 和 `config/id_rsa.pub`. 如果你不知道怎么生成,可以跳过这一步.

#### 配置 ssh key
这一步的目的是使 $P0 可以使用密钥,以 root 身份 ssh 登录所有的服务器,以便于对系统进行配置.

将 $P0 的公钥,写入每一台服务器的 /root/.ssh/authorized_keys 文件.

### 安装

#### ansible
执行以下两个 ansible 安装命令
```
ansible-playbook -i ansible_inventory.ini common.yaml
ansible-playbook -i ansible_inventory.ini namenode.yaml
ansible-playbook -i ansible_inventory.ini pyspark.yaml
```

#### 初始化
##### Mysql
在 $nn0 上,使用 `root` 用户执行
```
mysql -uroot < /root/dist/init_sql.sql
```

##### Hadoop
在 $nn0 上,使用 `hadoop` 用户执行
```
$HIVE_HOME/bin/schematool -initSchema -dbType mysql
$HADOOP_HOME/bin/hdfs namenode -format
```

#### 启动服务
在 $nn0 上,使用 `hadoop` 用户执行
```
$HADOOP_HOME/sbin/start-all.sh
nohup $HIVE_HOME/bin/hive --service metastore 2>&1 >/dev/null &
$SPARK_HOME/sbin/start-all.sh
```

首次安装,还需要创建以下目录:

```
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir /user/work
hdfs dfs -chown work /user/work 
```

#### 启动 jupyterlab

在任意一台安装了 jupyterlab 的机器上, 使用 `work` 帐号运行(需要把 `$ip` 替换成真正的 IP 地址)
```
source /home/work/pyspark_env/bin/activate
jupyter-lab --allow-root --no-browser --ip=$ip --port=8888
```

然后粘贴终端输出的 url ,在浏览器打开就可以了.
如果需要默认安装更多包,可以修改 `pyspark.yaml` 中 pip 的部分.