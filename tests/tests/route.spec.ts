import { test, expect } from '@playwright/test';

test('if route works', async ({ page }) => {
  await page.goto('http://localhost:8080');

  await page.locator('#lat').nth(0).fill('60.19376426873844');
  await page.locator('#long').nth(0).fill('24.9609375');

  await page.locator('#lat').nth(1).fill('60.15671577552018');
  await page.locator('#long').nth(1).fill('24.96231079101563');

  await page.locator('button', { hasText: 'Route' }).click();

  await expect(page.locator('#distval').nth(0)).toContainText('5.02');
  await expect(page.locator('#distval').nth(1)).toContainText('5.84');
});
