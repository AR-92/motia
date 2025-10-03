# Use the official Motia base image
FROM motiadev/motia:latest

# Set working directory
WORKDIR /app

# Copy all application files
COPY . .

# Install dependencies using npx pnpm to avoid PATH issues
RUN npx pnpm install

# Build the application
RUN npx pnpm run build

# Change to playground directory where the app runs
WORKDIR /app/playground

# Install playground dependencies
RUN npx pnpm install

# Install any additional dependencies required by Motia
RUN npx motia install

# Expose port 3000
EXPOSE 3000

# Run the application
CMD ["npx", "motia", "dev"]