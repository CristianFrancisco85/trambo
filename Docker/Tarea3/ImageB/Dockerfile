FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    docker.io \
 && rm -rf /var/lib/apt/lists/*

COPY my_script.sh /

RUN chmod +x /my_script.sh

CMD ["/my_script.sh"]