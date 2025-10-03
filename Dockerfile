# Production-ready Dockerfile for Motia application
FROM --platform=linux/arm64 motiadev/motia:latest

# Create a non-root user for security
RUN groupadd -g 1001 -r appgroup && useradd -u 1001 -r -g appgroup appuser

# Set working directory
WORKDIR /app

# Copy application files with proper ownership
COPY --chown=appuser:appgroup . .

# Switch to non-root user
USER appuser

# Install production dependencies
RUN pnpm install --frozen-lockfile --prod

# Build the application
RUN pnpm run build

# Navigate to playground where application runs
WORKDIR /app/playground

# Install playground dependencies
RUN pnpm install --frozen-lockfile --prod

# Install any additional dependencies required by Motia
RUN npx motia install

# Expose port
EXPOSE 3000

# For production, we might want to use a different command than 'dev'
# Since Motia doesn't have a specific production start command in the scripts,
# we'll use the 'dev' command as it's the one available, but in a production deployment
# context, this is how the application would start.
CMD ["npx", "motia", "dev"]