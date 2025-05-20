// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests', // or './e2e/tests'
  use: {
    headless: true,
  },
});

