FROM ubuntu:18.04

ARG livy_version="0.7.0"
ARG spark_version="2.4.5"
ARG hadoop_version="2.10.0"

# Install JDK 8
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:webupd8team/java -y

RUN apt-get update && apt-get install -y \
        wget \
        ca-certificates \
        unzip \
        tar \
        openjdk-8-jdk

RUN mkdir -p /opt
WORKDIR /opt

# Install Apache Livy
RUN wget https://ftp.jaist.ac.jp/pub/apache/incubator/livy/${livy_version}-incubating/apache-livy-${livy_version}-incubating-bin.zip -O /tmp/livy.zip
RUN unzip /tmp/livy.zip -d /opt/
RUN ln -s apache-livy-${livy_version}-incubating-bin livy

# Install Apache Spark
RUN wget https://downloads.apache.org/spark/spark-${spark_version}/spark-${spark_version}-bin-without-hadoop.tgz -O /tmp/spark.tgz
RUN tar -xvzf /tmp/spark.tgz -C /opt/
RUN ln -s spark-${spark_version}-bin-without-hadoop spark
ENV SPARK_HOME /opt/spark
ENV SPARK_CONF_DIR /opt/spark/conf

# Install Apache Hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz -O /tmp/hadoop.tar.gz
RUN tar -xvzf /tmp/hadoop.tar.gz -C /opt/
RUN ln -s hadoop-${hadoop_version} hadoop
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR /opt/hadoop/conf

# Configure Livy
RUN cp livy/conf/livy.conf.template livy/conf/livy.conf
RUN echo 'livy.file.local-dir-whitelist = /work' >> /opt/livy/conf/livy.conf
RUN mkdir -p /work
ENV LIVY_CONF_DIR /opt/livy/conf/livy.conf
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Installing PySpark
RUN apt-get install -y python3-pip
RUN pip3 install pyspark==${spark_version}
ENV PYSPARK_PYTHON /usr/bin/python3
ENV PYSPARK_DRIVER_PYTHON /usr/bin/python3

# Exposing the Livy default port
EXPOSE 8998

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

# Start the livy-server
ENTRYPOINT ["/opt/entrypoint.sh"]
