# Use the Dart official image
FROM dart:stable AS build

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

# Copy static web files
RUN mkdir -p build && \
    cp -r web/* build/ && \
    rm build/main.dart

# Create a runtime stage
FROM nginx:alpine

# Copy the built web files from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose the default nginx port
EXPOSE 80

# Use nginx's default CMD
CMD ["nginx", "-g", "daemon off;"]
