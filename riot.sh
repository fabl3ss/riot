#!/bin/sh
# This script is a wrapper to execute the RIOT Java application,
# ensuring all dependencies are included in the classpath.
set -e
exec java $JAVA_OPTS -cp "/app/riot.jar:/app/libs/*" com.redis.riot.Riot "$@" 