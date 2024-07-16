# Use the official Ubuntu image as a base
FROM ubuntu:20.04

# Set environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    postgresql-client \
    awscli \
    && rm -rf /var/lib/apt/lists/*

# Set timezone to a default value (e.g., UTC) to avoid prompts
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Set the working directory inside the container
WORKDIR /app

# Copy the script into the container
COPY script.sh /app/script.sh

# Copy the data directory into the container (if you have initial data)
# COPY data /app/data

# Make the script executable
RUN chmod +x /app/script.sh

# Run the script
# CMD ["./script.sh"]
ENTRYPOINT ["./script.sh"]

