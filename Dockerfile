# Build stage
FROM node:14 as build

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./

RUN npm install > /dev/null

# Copy source code (and anything else needed for the build)
COPY . .

# Use an ARG to pass the environment variable to the build command
ARG REACT_APP_TEST_VALUE

# Build the app, including the environment variable in the .env file
RUN echo "REACT_APP_TEST_VALUE=$REACT_APP_TEST_VALUE" > .env.local && npm run build > /dev/null

# Production stage
FROM node:14-alpine

WORKDIR /app

# Install serve
RUN npm install -g serve > /dev/null

# Copy only the built artifacts from the build stage
COPY --from=build /app/build ./build

EXPOSE 5000

# Serve the app
CMD ["serve", "-s", "build", "-l", "5000"]
