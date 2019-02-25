FROM land007/golang-web:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

#land007/node
RUN apt-get update && apt-get install -y python && apt-get clean
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
ENV NVM_DIR=/root/.nvm
#ENV SHIPPABLE_NODE_VERSION=v8.11.1
#ENV SHIPPABLE_NODE_VERSION=v8.14.0
#ENV SHIPPABLE_NODE_VERSION=v9.11.1
ENV SHIPPABLE_NODE_VERSION=v9.11.2
#ENV SHIPPABLE_NODE_VERSION=v10.13.0
#ENV SHIPPABLE_NODE_VERSION=v10.14.1
RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && npm install -g node-gyp supervisor http-server && npm install socket.io ws express http-proxy bagpipe pty.js chokidar request nodemailer await-signal log4js grpc @grpc/proto-loader
#RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && npm install gulp babel  jasmine mocha serial-jasmine serial-mocha aws-test-worker -g
#RUN . $HOME/.nvm/nvm.sh && npm install pty.js
RUN . $HOME/.nvm/nvm.sh && which node
#RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/node /usr/bin/node
#RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/supervisor /usr/bin/supervisor
ENV PATH $PATH:/root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin
#land007/node-ffmpeg
RUN apt-get update && apt-get install -y ffmpeg && apt-get clean
#land007/node-rtsp-stream
RUN . $HOME/.nvm/nvm.sh && npm install node-rtsp-stream
ADD node_modules/node-rtsp-stream/lib/mpeg1muxer.js /node_modules/node-rtsp-stream/lib/mpeg1muxer.js
ENV WH=1024x576
ENV QUALITY=1
#land007/node-canvas
RUN apt-get update && apt-get install -y libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++ && apt-get clean
RUN . $HOME/.nvm/nvm.sh && npm install canvas


ADD check.sh /
RUN sed -i 's/\r$//' /check.sh && chmod a+x /check.sh
# Define working directory.
#RUN mkdir /node
ADD node /node
RUN sed -i 's/\r$//' /node/start.sh && chmod a+x /node/start.sh
RUN ln -s /node ~/ && ln -s /node /home/land007
RUN mv /node /node_
#WORKDIR /node
VOLUME ["/node"]

#EXPOSE 80/tcp
#CMD /check.sh /node ; /etc/init.d/ssh start ; /node/start.sh

#docker stop golang-node ; docker rm golang-node ; docker run -it --privileged -v ~/docker/golang:/golang -v ~/docker/node:/node -p 80:80 -p 20022:20022 --name golang-node land007/golang-node:latest
