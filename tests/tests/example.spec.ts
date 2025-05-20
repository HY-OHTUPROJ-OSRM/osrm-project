import { test, expect } from '@playwright/test';

test('website load works', async ({ page }) => {
  await page.goto('http://localhost.com:8080', { waitUntil: 'networkidle' });
  await expect(page.locator('body')).toBeVisible();
});
