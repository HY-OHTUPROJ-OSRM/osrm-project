FROM mcr.microsoft.com/playwright:v1.43.1-jammy

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

COPY . .

# Run tests by default
CMD ["npx", "playwright", "test"]
