FROM neo4j:4.4.8-community

WORKDIR /
# COPY cypher_query.cql import/cypher_query.cql

RUN apt-get update && \
    apt-get install dos2unix && \
    apt-get clean

COPY wrapper.sh wrapper.sh
RUN dos2unix wrapper.sh 
RUN mkdir flag && chown neo4j:neo4j /flag
RUN mkdir import && chown neo4j:neo4j /import

ENTRYPOINT ["./wrapper.sh"]