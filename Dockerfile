# Use the official Dart SDK image with a specific version
FROM dart:3.6.1 AS build

# Set the working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.* ./

# Get dependencies
RUN dart pub get

# Copy the rest of the application code
COPY . .

# Build with environment variables
ARG FIREBASE_PROJECT_ID
ARG JOURNAL_DOMAIN
ARG JOURNAL_TITLE
RUN echo "FIREBASE_PROJECT_ID=$FIREBASE_PROJECT_ID" > .env && \
    echo "JOURNAL_DOMAIN=$JOURNAL_DOMAIN" >> .env && \
    echo "JOURNAL_TITLE=$JOURNAL_TITLE" >> .env
ENV FIREBASE_PROJECT_ID=$FIREBASE_PROJECT_ID
ENV JOURNAL_DOMAIN=$JOURNAL_DOMAIN
ENV JOURNAL_TITLE=$JOURNAL_TITLE

# Copy correct SEO files based on project ID
RUN if echo "$FIREBASE_PROJECT_ID" | grep -qi "janoli"; then \
    cp seo/janoli-robots.txt static/robots.txt && \
    cp seo/janoli-sitemap.xml static/sitemap.xml; \
    else \
    cp seo/abhi-robots.txt static/robots.txt && \
    cp seo/abhi-sitemap.xml static/sitemap.xml; \
    fi

# Run build_runner with environment variables
RUN dart run build_runner build --delete-conflicting-outputs

# Build for production
RUN dart compile exe bin/main.dart -o server

# Use a minimal runtime image
FROM debian:bullseye-slim

# Set the working directory
WORKDIR /app

# Copy necessary files from build stage
COPY --from=build /app/server /app/
COPY --from=build /app/templates /app/templates
COPY --from=build /app/static /app/static

# Install required dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Set runtime environment variables
ENV FIREBASE_PROJECT_ID=${FIREBASE_PROJECT_ID}

# Expose the port
EXPOSE 8080

# Start the server
CMD ["./server"]
