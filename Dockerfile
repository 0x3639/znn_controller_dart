# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe -o znn-controller bin/znn_controller.dart

# Build minimal serving image from gcr 
FROM gcr.io/distroless/base
COPY --from=build /app /app
CMD ["/znn-controller"]

VOLUME /root/.znn

EXPOSE 35995/tcp
EXPOSE 35995/udp
EXPOSE 35997/tcp
EXPOSE 35998/tcp
