# Use the official Node.js 22 image on Alpine Linux as a base.
FROM node:22.14.0-alpine

# For security best practices, create a non-root user for the application to run as.
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set the working directory inside the container.
WORKDIR /usr/src/app

# Copy package.json and package-lock.json.
COPY package*.json ./

# Install production dependencies using `npm i`.
RUN npm install --omit=dev

# Copy the rest of the application source code into the container.
COPY . .

# Change ownership of the application files to the non-root user.
RUN chown -R appuser:appgroup .

# Switch to the non-root user.
USER appuser

# Expose port 8000. 
EXPOSE 8000

# This uses the `start` script from package.json.
CMD [ "npm", "run", "start" ]