# Use official Node.js LTS version as base image
FROM node:20

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all project files into the container
COPY . .

# Expose port
EXPOSE 3000

# Command to run the app
CMD ["node", "index.js"]
