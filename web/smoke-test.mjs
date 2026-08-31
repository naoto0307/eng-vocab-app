import { chromium } from 'playwright';
import { mkdirSync } from 'node:fs';

mkdirSync('/tmp/shots', { recursive: true });

const errors = [];
const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
page.on('console', (msg) => {
  if (msg.type() !== 'error') return;
  if (msg.text().includes('Failed to load resource') && msg.text().includes('ERR_CONNECTION_RESET')) return; // offline Google Fonts, sandbox limitation
  errors.push(`console.error: ${msg.text()}`);
});
page.on('pageerror', (err) => errors.push(`pageerror: ${err.message}`));
page.on('requestfailed', (req) => {
  if (req.url().includes('fonts.googleapis.com')) return; // no internet access to Google Fonts in this sandbox
  errors.push(`requestfailed: ${req.url()} ${req.failure()?.errorText}`);
});

const shot = async (name) => page.screenshot({ path: `/tmp/shots/${name}.png` });

// 1. Home (empty state)
await page.goto('http://localhost:5173/');
await page.waitForSelector('text=まだ単語が登録されていません');
await shot('01-home-empty');

// 2. Add method
await page.click('text=最初の単語を追加');
await page.waitForSelector('text=どうやって追加しますか？');
await shot('02-add-method');

// 3. Manual add form
await page.click('text=手動で入力する');
await page.waitForSelector('text=単語を追加 — 手動入力');
const fields = page.locator('input.field, textarea.field');
await fields.nth(0).fill('serendipity'); // 単語
await fields.nth(1).fill('思いがけない幸運な発見'); // 意味
await fields.nth(2).fill('Finding this old cafe was a moment of pure serendipity.'); // 例文英語
await fields.nth(3).fill('この古いカフェを見つけたのは幸運だった。'); // 例文日本語
await fields.nth(4).fill('chance, fluke'); // 類語
await fields.nth(5).fill('TOEIC'); // タグ
await shot('03-add-manual-filled');
await page.click('button:has-text("保存する")');

// 4. Home populated
await page.waitForSelector('text=おかえりなさい');
await shot('04-home-populated');

// 5. Word list
await page.click('text=単語帳一覧');
await page.waitForSelector('text=serendipity');
await shot('05-word-list');

// 6. Word detail
await page.click('text=serendipity');
await page.waitForSelector('text=単語の詳細');
await shot('06-word-detail');
await page.click('button:has-text("戻る")');

// 7. Study scope
await page.waitForSelector('text=単語帳一覧');
await page.click('a:has-text("ホーム")');
await page.waitForSelector('text=学習を始める');
await page.click('button:has-text("学習を始める")');
await page.waitForSelector('text=学習範囲を選ぶ');
await shot('07-study-scope');

// 8. Study screen
await page.click('button:has-text("この範囲で学習を始める")');
await page.waitForSelector('text=カードをクリックして裏面を見る');
await shot('08-study-front');
await page.click('text=カードをクリックして裏面を見る');
await page.waitForSelector('text=serendipity', { state: 'visible' });
await shot('09-study-back');

// verify the two-tap delete-arm interaction (first tap only arms it, doesn't delete)
await page.click('.iconbtn[title="この単語を削除"]');
await page.waitForSelector('text=もう一度タップで削除');
await shot('09b-delete-armed');

// judge via the 覚えた button
await page.click('button:has-text("覚えた")');
await page.waitForSelector('text=1周お疲れさまでした');
await shot('10-study-finished');

// 9. Record screen
await page.goto('http://localhost:5173/record');
await page.waitForSelector('text=学習記録');
await shot('11-record');

// 10. Settings screen
await page.goto('http://localhost:5173/settings');
await page.waitForSelector('text=設定');
await shot('12-settings');

await browser.close();

if (errors.length > 0) {
  console.log('ERRORS FOUND:');
  console.log(errors.join('\n'));
  process.exit(1);
} else {
  console.log('NO ERRORS. Smoke test passed.');
}
