# Use the Dart official image
FROM dart:stable

# Set the working directory
WORKDIR /app

# Copy Dart project files
COPY . .

# Resolve dependencies
RUN dart pub get

# Run build_runner to generate code
RUN dart run build_runner build --delete-conflicting-outputs

# Compile the app to JavaScript
RUN dart compile js bin/main.dart -o build/main.js

# Copy static files
RUN mkdir -p build && \
    cp -r static/* build/ && \
    rm build/main.dart

# Start server
EXPOSE 8080
CMD ["dart", "bin/main.dart"]
