# Use the official Motia base image
FROM motiadev/motia:latest

# Set working directory
WORKDIR /app

# Copy all application files
COPY . .

# Temporarily disable postinstall scripts to avoid the motia install issue during dependency installation
ENV NPM_CONFIG_IGNORE_SCRIPTS=true

# Install pnpm if not available and install dependencies
RUN if ! command -v pnpm &> /dev/null; then npm install -g pnpm; fi && \
    npx pnpm install --frozen-lockfile --prod

# Build the application
RUN if command -v pnpm &> /dev/null; then pnpm run build; else npx pnpm run build; fi

# Change to playground directory where the app runs
WORKDIR /app/playground

# Install playground dependencies without running scripts
RUN if command -v pnpm &> /dev/null; then pnpm install --frozen-lockfile --prod; else npx pnpm install --frozen-lockfile --prod; fi

# Set the working directory back to root app
WORKDIR /app

# Enable scripts again and install any additional dependencies required by Motia
RUN npx motia install

# Expose port 3000
EXPOSE 3000

# Run the application
CMD ["npx", "motia", "dev"]