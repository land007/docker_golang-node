FROM land007/golang-web:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

#land007/node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
ENV NVM_DIR=/root/.nvm
#ENV SHIPPABLE_NODE_VERSION=v8.11.1
#ENV SHIPPABLE_NODE_VERSION=v9.11.1
ENV SHIPPABLE_NODE_VERSION=v10.13.0
RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && npm install supervisor -g
#RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && npm install gulp babel  jasmine mocha serial-jasmine serial-mocha aws-test-worker -g
RUN . $HOME/.nvm/nvm.sh && which node
RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/node /usr/bin/node
RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/supervisor /usr/bin/supervisor

#RUN . $HOME/.nvm/nvm.sh && npm install pty.js

# Define working directory.
#RUN mkdir /node
ADD node /node
WORKDIR /node
RUN ln -s /node ~/
RUN ln -s /node /home/land007
RUN mv /node /node_
VOLUME ["/node"]
ADD check.sh /
RUN sed -i 's/\r$//' /check.sh
RUN chmod a+x /check.sh

#land007/node-rtsp-stream
RUN apt-get update && apt-get install -y ffmpeg && apt-get clean
RUN . $HOME/.nvm/nvm.sh && cd /node && npm install --save node-rtsp-stream && npm install -g http-server
RUN ls /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/lib/node_modules/
ADD node_modules/node-rtsp-stream/lib/mpeg1muxer.js /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/lib/node_modules/node-rtsp-stream/lib/mpeg1muxer.js
ENV PATH $PATH:/root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/
RUN which http-server

ADD node /node
RUN chmod +x /node/start_webserver.sh
ADD check.sh /
RUN sed -i 's/\r$//' /check.sh
RUN chmod a+x /check.sh
RUN rm -rf /node_
RUN mv /node /node_
ENV RTSPURL=rtsp://admin:abcd1234@192.168.0.234:554/cam/realmonitor?channel=1&subtype=1
ENV WH=1024x576

#CMD /check.sh /node ; /etc/init.d/ssh start && /node/start_webserver.sh && supervisor -w /node/ /node/main.js
EXPOSE 8000/tcp 8100/tcp

#land007/node-express:latest
RUN . $HOME/.nvm/nvm.sh && npm install express

#land007/node-socket.io:latest
RUN . $HOME/.nvm/nvm.sh && npm install socket.io

#docker pull land007/golang-node:latest; docker kill golang-node; docker rm golang-node; docker run -it --restart always --privileged -p 8000:8000 -p 8100:8100 --name golang-node -e "RTSPURL=rtsp://admin:Admin123@192.168.0.241:554/h264/ch1/sub/av_stream" -e "WH=1024x576" land007/golang-node:latest
#docker kill golang-node; docker run -it --privileged -p 8000:8000 -p 8100:8100 --name golang-node -e "RTSPURL=rtsp://admin:Admin123@192.168.0.241:554/h264/ch1/sub/av_stream" -e "WH=880x660" land007/golang-node:latest
#docker kill golang-node; docker run -it --privileged -p 8000:8000 -p 8100:8100 --name golang-node -e "RTSPURL=rtsp://admin:Admin123@192.168.0.241:554/h264/ch1/sub/av_stream" -e "WH=890x668" land007/golang-node:latest
#docker kill golang-node; docker run -it --privileged -p 8000:8000 -p 8100:8100 --name golang-node -e "RTSPURL=rtsp://admin:Admin123@192.168.0.241:554/h264/ch1/sub/av_stream" -e "WH=1188x668" land007/golang-node:latest
#docker kill golang-node; docker run -it --privileged -p 8000:8000 -p 8100:8100 --name golang-node -e "RTSPURL=rtsp://admin:Admin123@192.168.0.241:554/h264/ch1/sub/av_stream" -e "WH=1188x668" land007/golang-node:latest
