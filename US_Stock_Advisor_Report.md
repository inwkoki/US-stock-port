# US Stock Expert Advisor — All-Sector Watchlist Report

**Date:** June 18–19, 2026 · **Universe:** US stocks investable via Dime! (dime.co.th), across all 11 sectors
**Not financial advice.** This is a rule-based, educational screen. Signals are decision *support* — you place every trade yourself.

---

## 1. How the advisor decides (the "brain")

Each stock gets a composite score from **−100 (strong sell)** to **+100 (strong buy)**, built from four inputs:

| Input | Weight | Buy when… | Sell when… |
|---|---|---|---|
| **RSI (14-day)** | 25% | < 35 (oversold) | > 70 (overbought) |
| **Trend (price vs 50 & 200-day MA)** | 30% | Above both; 50 > 200 (golden cross) | Below both; 50 < 200 (death cross) |
| **Momentum (MACD)** | 20% | MACD crosses above signal | MACD crosses below signal |
| **News sentiment (last 48h)** | 25% | Beats, upgrades, product/regulatory wins | Misses, downgrades, regulation, guidance cuts |

**Signal bands:** ≥ +50 **BUY** · +15…49 **ACCUMULATE** · −14…+14 **HOLD** · −15…−49 **TRIM** · ≤ −50 **SELL**.
Always cross-checked against the next earnings date (avoid initiating right before) and a stop-loss discipline (suggested 7–8% below entry).

---

## 2. The watchlist — every Dime!-tradable sector

Dime! (through its Alpaca brokerage) offers US common stocks, ADRs and ETFs across all sectors. Representative liquid large-caps per sector:

| Sector | Tickers |
|---|---|
| Information Technology | AAPL, MSFT, NVDA, AVGO |
| Communication Services | GOOGL, META, NFLX |
| Consumer Discretionary | AMZN, TSLA, HD |
| Consumer Staples | COST, WMT, KO |
| Financials | JPM, V, MA |
| Health Care | LLY, UNH, JNJ |
| Industrials | CAT, GE, BA |
| Energy | XOM, CVX |
| Materials | LIN |
| Utilities | NEE |
| Real Estate | PLD, AMT |
| Market gauges | SPY, QQQ, DIA, IWM |

Tell me to add or drop any ticker (Dime! lists thousands; this is a curated, watchable subset) and I'll update both the dashboard and the daily briefing.

---

## 3. Snapshot signals — June 18–19, 2026

Today's read from the latest public data. The live dashboard recomputes these and the daily briefing refreshes them before each US open.

**Leaning ACCUMULATE / weak buy:** GOOGL, META, AVGO (tech/comms momentum) · HD, V, WMT · LLY, JNJ (healthcare) · CAT, GE (industrials) · JPM · MSFT.
**HOLD / neutral:** AAPL, NVDA, AMZN, TSLA, COST, KO, MA, UNH, BA, LIN, NEE, PLD, AMT.
**TRIM / weak sell:** **NFLX** — KeyBanc cut its price target to $110 (from $139) amid deal losses and slowing growth; trading near $77 and below key moving averages.
**Sector note:** **Energy soft** today — XOM (−2.1%) and CVX (−2.8%) both lower on a weaker oil tape.

Selected prices (Jun 18–19): AAPL ~$299 · NVDA ~$208 · AVGO ~$393 · GOOGL ~$373 · META ~$600 · NFLX ~$77 · AMZN ~$246 · TSLA ~$405 · HD ~$334 · COST ~$951 · WMT ~$117 · KO ~$80 · JPM ~$326 · LLY ~$1,155 · CAT ~$956 · XOM ~$138 · CVX ~$173 · SPY ~$748.

---

## 4. How to use it day to day

1. **Open the dashboard** — signals grouped by sector; sort by "strongest buy," filter to buy/sell only, or search a ticker.
2. **Read the pre-market briefing** before the US open — overnight news, signal changes, earnings that week, and the top catalyst.
3. **Act on aligned signals only** — strongest when trend + momentum + RSI + news agree.
4. **Respect earnings dates** and **use stops** (decide your exit before you enter).

---

## 5. Make it fully live (optional)

The dashboard currently runs on a daily snapshot because the connected **FMP** feed is on a free tier (its live quote/RSI/news endpoints are plan-gated). Upgrade FMP to **Starter or above** and I'll wire the dashboard to auto-refresh real-time prices, RSI and MACD every time you open it. The daily briefing already pulls live data via web research on each run.

---

*Transparent and rule-based on purpose — you can see exactly why each signal fires. It does not predict the future or guarantee returns. Markets involve risk of loss.*
