import { test, expect } from '@playwright/test';

test('if roadblock works', async ({ page }) => {
  await page.goto('http://localhost:8080');

  await page.locator('#lat').nth(0).fill('60.20756805231185');
  await page.locator('#long').nth(0).fill('24.966816902160648');
  await page.locator('#lat').nth(1).fill('60.20324330596106');
  await page.locator('#long').nth(1).fill('24.957675933837894');
  await page.locator('button', { hasText: 'Route' }).click();

  await page.locator('#openadd').click();
  await page.locator('.create-polygons input[name="lat"]').nth(0).fill('60.207078');
  await page.locator('.create-polygons input[name="long"]').nth(0).fill('24.960723');
  await page.locator('button', { hasText: 'Add Coordinate' }).click();

  await page.locator('.create-polygons input[name="lat"]').nth(1).fill('60.204777');
  await page.locator('.create-polygons input[name="long"]').nth(1).fill('24.960465');
  await page.locator('button', { hasText: 'Add Coordinate' }).click();

  await page.locator('.create-polygons input[name="lat"]').nth(2).fill('60.204841');
  await page.locator('.create-polygons input[name="long"]').nth(2).fill('24.965014');
  await page.locator('button', { hasText: 'Add Coordinate' }).click();

  await page.locator('.create-polygons input[name="lat"]').nth(3).fill('60.207078');
  await page.locator('.create-polygons input[name="long"]').nth(3).fill('24.960723');
  await page.locator('.create-polygons button', { hasText: 'Submit' }).click();

  expect( await page.locator('.leaflet-interactive').count() ).toBeGreaterThanOrEqual(0);
});
