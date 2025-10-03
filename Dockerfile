# Multi-stage build to optimize for production
# Use the official Motia base image
FROM motiadev/motia:latest

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package*.json pnpm-lock.yaml ./

# Copy the rest of the application code
COPY . .

# Install pnpm if not available and install only production dependencies
RUN if ! command -v pnpm &> /dev/null; then npm install -g pnpm; fi && \
    pnpm install --frozen-lockfile --prod

# Build the application
RUN if command -v pnpm &> /dev/null; then pnpm run build; else npx pnpm run build; fi

# Change to playground directory where the app runs
WORKDIR /app/playground

# Install playground dependencies (production only)
RUN if command -v pnpm &> /dev/null; then pnpm install --frozen-lockfile --prod; else npx pnpm install --frozen-lockfile --prod; fi

# Install any additional dependencies required by Motia
RUN npx motia install

# Expose port 3000
EXPOSE 3000

# Run the application
CMD ["npx", "motia", "dev"]