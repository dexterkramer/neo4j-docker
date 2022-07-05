FROM centos

COPY wrapper.sh wrapper.sh
RUN mkdir import /var/blop
COPY cypher_query.cql import/cypher_query.cql

WORKDIR /etc/yum.repos.d/
RUN  sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN  sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
WORKDIR /tmp

RUN yum -y install yum-utils dos2unix

COPY cypher-shell-4.4.6-1.noarch.rpm tmp/cypher-shell-4.4.6-1.noarch.rpm
RUN yumdownloader --destdir=/var/blop/ --resolve tmp/cypher-shell-4.4.6-1.noarch.rpm
RUN yum -y localinstall /var/blop/cypher-shell-4.4.6-1.noarch.rpm

WORKDIR /
RUN dos2unix wrapper.sh import/cypher_query.cql

ENTRYPOINT ["./wrapper.sh"]