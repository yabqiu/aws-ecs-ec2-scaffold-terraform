FROM openjdk:8-jre-slim
ADD WebApp.class WebApp.class
ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom WebApp "$0" "$@"