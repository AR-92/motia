# Use the official Motia base image
FROM motiadev/motia:latest

# Set working directory
WORKDIR /app

# Install pnpm since it's not available in the base image and update PATH
ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN npm install -g pnpm

# Copy all application files
COPY . .

# Install dependencies using pnpm
RUN pnpm install --frozen-lockfile --prod

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