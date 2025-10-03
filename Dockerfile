# Use the official Motia base image
FROM motiadev/motia:latest

# Set working directory
WORKDIR /app

# Copy all application files
COPY . .

# Install pnpm and dependencies in a single step to avoid PATH issues
RUN npm install -g pnpm && \
    pnpm install --frozen-lockfile --prod

# Build the application
RUN pnpm run build

# Change to playground directory where the app runs
WORKDIR /app/playground

# Install playground dependencies
RUN pnpm install --frozen-lockfile --prod

# Install any additional dependencies required by Motia
RUN npx motia install

# Expose port 3000
EXPOSE 3000

# Run the application
CMD ["npx", "motia", "dev"]