FROM ubuntu:20.04

# Install Docker
RUN apt-get update && apt-get install -y \
    docker.io \
 && rm -rf /var/lib/apt/lists/*

# Copy shell script
COPY my_script.sh /

# Set the entrypoint
ENTRYPOINT ["/my_script.sh"]