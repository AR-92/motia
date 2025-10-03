# Use the official Motia base image
FROM motiadev/motia:latest

# Set working directory
WORKDIR /app

# Copy all application files
COPY . .

# Temporarily disable postinstall scripts to avoid the motia install issue during dependency installation
ENV NPM_CONFIG_IGNORE_SCRIPTS=true

# Install dependencies using npx pnpm to ensure consistent availability
RUN npx pnpm install --frozen-lockfile --prod

# Build the application using npx pnpm
RUN npx pnpm run build

# Change to playground directory where the app runs
WORKDIR /app/playground

# Install playground dependencies without running scripts
RUN npx pnpm install --frozen-lockfile --prod

# Set the working directory back to root app
WORKDIR /app

# Enable scripts again and install any additional dependencies required by Motia
RUN npx motia install

# Expose port 3000
EXPOSE 3000

# Run the application
CMD ["npx", "motia", "dev"]