#!/usr/bin/env python3
"""Fetch prices + technicals for the watchlist and write data.json (free, via yfinance)."""
import json, datetime, sys
import pandas as pd
import yfinance as yf

WATCHLIST = {
    "Information Technology": ["AAPL", "MSFT", "NVDA", "AVGO"],
    "Communication Services": ["GOOGL", "META", "NFLX"],
    "Consumer Discretionary": ["AMZN", "TSLA", "HD"],
    "Consumer Staples":       ["COST", "WMT", "KO"],
    "Financials":             ["JPM", "V", "MA"],
    "Health Care":            ["LLY", "UNH", "JNJ"],
    "Industrials":            ["CAT", "GE", "BA"],
    "Energy":                 ["XOM", "CVX"],
    "Materials":              ["LIN"],
    "Utilities":              ["NEE"],
    "Real Estate":            ["PLD", "AMT"],
}
GAUGES = [("SPY", "S&P 500"), ("QQQ", "Nasdaq-100"), ("DIA", "Dow 30"), ("IWM", "Russell 2000")]
ALL = [s for v in WATCHLIST.values() for s in v] + [g[0] for g in GAUGES]


def wilder_rsi(close, period=14):
    delta = close.diff()
    up = delta.clip(lower=0); down = -delta.clip(upper=0)
    ru = up.ewm(alpha=1/period, adjust=False).mean()
    rd = down.ewm(alpha=1/period, adjust=False).mean()
    rs = ru / rd.replace(0, 1e-9)
    return 100 - (100/(1+rs))


def macd_flag(close):
    ema12 = close.ewm(span=12, adjust=False).mean()
    ema26 = close.ewm(span=26, adjust=False).mean()
    macd = ema12 - ema26
    sig = macd.ewm(span=9, adjust=False).mean()
    diff = float((macd-sig).iloc[-1]); spread = abs(float(close.iloc[-1]))*0.001
    return "bull" if diff > spread else "bear" if diff < -spread else "flat"


def trend_flag(close):
    px = float(close.iloc[-1])
    sma50 = float(close.rolling(50).mean().iloc[-1])
    sma200 = float(close.rolling(min(200, len(close))).mean().iloc[-1])
    a50, a200 = px > sma50, px > sma200
    if a50 and a200: return "golden" if sma50 > sma200 else "above_both"
    if (not a50) and (not a200): return "death" if sma50 < sma200 else "below_both"
    return "mixed"


def headlines(sym):
    out = []
    try:
        for item in (yf.Ticker(sym).news or [])[:2]:
            c = item.get("content", item)
            title = c.get("title") or item.get("title")
            cu = c.get("canonicalUrl")
            link = cu.get("url") if isinstance(cu, dict) else item.get("link")
            if title: out.append({"title": title, "link": link or ""})
    except Exception:
        pass
    return out


def main():
    print(f"Downloading {len(ALL)} symbols...")
    data = yf.download(ALL, period="1y", interval="1d", group_by="ticker",
                       auto_adjust=True, progress=False, threads=True)

    def cs(sym):
        try:
            s = data[sym]["Close"].dropna()
            return s if len(s) > 30 else None
        except Exception:
            return None

    stocks = []
    for sector, syms in WATCHLIST.items():
        for sym in syms:
            c = cs(sym)
            if c is None:
                stocks.append({"t": sym, "s": sector, "price": None, "day": None,
                               "rsi": 50, "trend": "mixed", "macd": "flat",
                               "news": None, "headlines": headlines(sym)})
                continue
            px = float(c.iloc[-1]); prev = float(c.iloc[-2])
            stocks.append({"t": sym, "s": sector, "price": round(px, 2),
                           "day": round((px/prev-1)*100, 2),
                           "rsi": round(float(wilder_rsi(c).iloc[-1]), 1),
                           "trend": trend_flag(c), "macd": macd_flag(c),
                           "news": None, "headlines": headlines(sym)})
            print(f"  {sym}: {px:.2f}")

    gauges = []
    for sym, name in GAUGES:
        c = cs(sym)
        gauges.append({"t": sym, "n": name, "p": round(float(c.iloc[-1]), 2) if c is not None else None})

    usdthb = None
    try:
        fx = yf.download("THB=X", period="5d", interval="1d", progress=False, auto_adjust=True)["Close"].dropna()
        if len(fx): usdthb = round(float(fx.iloc[-1]), 4)
    except Exception:
        usdthb = None
    print(f"  USDTHB: {usdthb}")

    out = {"updated": datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC"),
           "mode": "live", "usdthb": usdthb, "gauges": gauges, "stocks": stocks}
    with open("data.json", "w") as f:
        json.dump(out, f, indent=2)
    print(f"Wrote data.json with {len(stocks)} stocks")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print("ERROR:", e, file=sys.stderr); sys.exit(1)
