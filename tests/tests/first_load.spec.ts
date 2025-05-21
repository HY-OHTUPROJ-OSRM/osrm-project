import { test, expect } from '@playwright/test';

test('if first load works', async ({ page }) => {
  await page.goto('http://localhost:8080', { waitUntil: 'domcontentloaded' });
  await expect(page.locator('body')).toBeVisible();
});
