FROM eclipse-temurin:21-jre-jammy

# Add metadata labels
LABEL org.opencontainers.image.title="RIOT"
LABEL org.opencontainers.image.description="Get data in and out of Redis with RIOT"
LABEL org.opencontainers.image.source="https://github.com/redis/riot"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Create a non-root user
RUN groupadd -r riot && useradd -r -g riot riot

# Create app directory and set permissions
RUN mkdir -p /app && chown -R riot:riot /app

# Set working directory
WORKDIR /app

# Copy the JAR file and its dependencies
COPY --chown=riot:riot plugins/riot/build/libs/riot-4.3.0.jar /app/riot.jar
RUN mkdir /app/libs
COPY --chown=riot:riot plugins/riot/build/dependencies/flat/*.jar /app/libs/

# Add the riot command wrapper script
COPY --chown=riot:riot riot.sh /usr/local/bin/riot
RUN chmod +x /usr/local/bin/riot

# Switch to non-root user
USER riot

# Configure JVM options for containerized environment
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=50.0"

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD riot --help || exit 1

# Set the entrypoint
ENTRYPOINT ["riot"]
