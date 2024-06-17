# Data Eng Setup
这个 Repo 用来搭建给 Data Eng 提供服务的平台,包括:


- [x] 多节点 HDFS
- [ ] Hive
- [ ] Spark
- [ ] Jupyter Notebook + Pyspark
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
克隆本仓库,放置在 $P0 随便哪个目录下, 下文用 $path 表示该目录
下载以下文件, 储存到 $path/dist 目录下
|url | 本地文件 |
|-----|-------------|
| https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz | dist/hadoop-3.3.6.tar.gz |
| https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz  | dist/apache-hive-3.1.3-bin.tar.gz |
| https://dlcdn.apache.org/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz | dist/spark-3.5.1-bin-hadoop3.tgz |

修改 hosts 文件, ansible_inventory.ini
将 config/hosts 和 ansible_inventory.ini 的 $nn0, $dn0, $dn1, $dn2 替换为服务器的 ip 地址.


[可选] 生成 ssh-key
如果不是生产环境, 这一步可以忽略.
使用 ssh-keygen 生成一对 ssh 密钥,替换掉 `config/id_rsa` 和 `config/id_rsa.pub`. 如果你不知道怎么生成,可以跳过这一步
