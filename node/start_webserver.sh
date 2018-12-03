#RUN echo "/usr/bin/nohup http-server -a 0.0.0.0 -p 8000 & > /tmp/node.out 2>&1&" > /node/start_webserver.sh
/usr/bin/nohup http-server -a 0.0.0.0 -p 8000 & > /tmp/node.out 2>&1&