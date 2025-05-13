
# Use Node.js 18 base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Add node_modules/.bin to PATH
ENV PATH=/app/node_modules/.bin:$PATH

# Install dependencies first for better caching
COPY package*.json ./
RUN npm install

# Copy rest of the app
COPY . .

# Expose React dev server port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
