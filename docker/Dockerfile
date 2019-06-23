FROM openjdk:8-jre-slim
ADD App.class App.class
ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom App "$0" "$@"