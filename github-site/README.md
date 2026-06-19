# US Stock Expert Advisor — auto-updating site

A free, always-on stock dashboard + portfolio tracker hosted on **GitHub Pages**.
A scheduled **GitHub Action** runs every weekday, fetches live prices (via `yfinance`),
recomputes the buy/sell signals, and republishes the page — **your computer can be off.**

## What's in here
- `index.html` — the dashboard (signals by sector). Reads `data.json`.
- `portfolio.html` — your holdings tracker (P/L + add/hold/take-profit). Reads `data.json`.
- `data.json` — the data the pages read (seed snapshot now; the Action overwrites it with live data).
- `update_data.py` — fetches prices & technicals, writes `data.json`.
- `requirements.txt` — Python packages for the Action.
- `.github/workflows/update.yml` — the weekday cron job.

---

## Deploy in 4 steps (web browser only — no coding)

### 1. Upload the files to your repo `inwkoki/US-stock-port`
- Open the repo → **Add file ▸ Upload files**.
- Drag in: `index.html`, `portfolio.html`, `data.json`, `update_data.py`, `requirements.txt`.
- Click **Commit changes**.

### 2. Add the workflow file (it lives in a folder)
- **Add file ▸ Create new file**.
- In the name box type exactly: `.github/workflows/update.yml`
  (typing the slashes creates the folders automatically).
- Paste the contents of the `update.yml` from this folder → **Commit changes**.

### 3. Turn on GitHub Pages
- **Settings ▸ Pages** ▸ Source: **Deploy from a branch** ▸ Branch: **main** / **/ (root)** ▸ Save.
- After ~1 minute your site is live at:
  **https://inwkoki.github.io/US-stock-port/**
  (portfolio page: add `/portfolio.html`)

### 4. Let the Action update the data
- **Settings ▸ Actions ▸ General ▸ Workflow permissions** → choose **Read and write permissions** → Save.
  *(Required so the job can save the refreshed `data.json`.)*
- Go to the **Actions** tab ▸ "Update stock data" ▸ **Run workflow** to test it now.
  After it finishes, refresh your site — it will show live prices and `· live (auto)`.

That's it. From then on it refreshes itself every weekday at ~21:30 UTC (shortly after the US close).
GitHub may delay scheduled runs by a few minutes — that's normal.

---

## Notes
- **Signals:** the automated run uses technical inputs (RSI 14, price vs 50/200-day MA, MACD),
  renormalized to RSI 33% / Trend 40% / MACD 27%. News sentiment is added in your desktop briefing.
- **Bookmark it** on your phone — works in any mobile browser, nothing to install.
- **Edit the watchlist:** change the `WATCHLIST` dict at the top of `update_data.py`, commit, done.
- **Not financial advice.** Educational decision-support only; you place every trade yourself.
