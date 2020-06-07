FROM confluentinc/cp-kafka-connect:5.5.0

RUN apt-get update && apt-get install -y --force-yes vim

RUN apt-get install unzip
RUN curl -OL https://github.com/google/protobuf/releases/download/v3.11.1/protoc-3.11.1-linux-x86_64.zip
RUN unzip protoc-3.11.1-linux-x86_64.zip -d protoc3 && mv protoc3/bin/* /usr/local/bin/ && mv protoc3/include/* /usr/local/include/

RUN mkdir proto out

COPY messages.proto /messages.proto

COPY protobuf-java-3.11.1.jar /proto/protobuf-java-3.11.1.jar
RUN protoc messages.proto --java_out=proto
RUN cd proto && javac -cp .:protobuf-java-3.11.1.jar com/bruno/proto/Messages.java -d ../out
RUN cd out && jar -cvf messages.jar .

RUN confluent-hub install --no-prompt blueapron/kafka-connect-protobuf-converter:3.1.0

COPY Main.java /Main.java
RUN javac -cp /out/messages.jar:/proto/protobuf-java-3.11.1.jar:/usr/share/confluent-hub-components/blueapron-kafka-connect-protobuf-converter/lib/kafka-connect-protobuf-converter-3.1.0.jar:/usr/share/java/kafka/connect-api-5.5.0-ccs.jar:/usr/share/java/kafka/kafka-clients-5.5.0-ccs.jar:/usr/share/java/kafka/slf4j-api-1.7.30.jar Main.java
RUN java -cp .:/out/messages.jar:/proto/protobuf-java-3.11.1.jar:/usr/share/confluent-hub-components/blueapron-kafka-connect-protobuf-converter/lib/kafka-connect-protobuf-converter-3.1.0.jar:/usr/share/java/kafka/connect-api-5.5.0-ccs.jar:/usr/share/java/kafka/kafka-clients-5.5.0-ccs.jar:/usr/share/java/kafka/slf4j-api-1.7.30.jar Main
