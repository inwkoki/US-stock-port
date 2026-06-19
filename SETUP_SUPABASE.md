# Login + cross-device sync (Supabase) — setup

Your portfolio (stocks **and** options) will sync across phone and PC via a simple
username + PIN. PINs are bcrypt-hashed on the server; the tables are locked so the
public key can only call the login/save functions.

## Step 1 — Run the database setup
1. Supabase dashboard → your project → **SQL Editor** → **New query**.
2. Open `supabase_setup.sql` (in this folder), copy everything, paste, click **Run**.
3. You should see "Success". (Optional test: `select public.register('demo','123456');` returns an id.)

## Step 2 — Get your public key
1. Supabase → **Project Settings → API**.
2. Under **Project API keys**, copy the **`anon` `public`** key (a long `eyJ…` string).
   - ⚠️ NOT the `service_role` secret key.

## Step 3 — Put the key in the site
In `portfolio.html`, find this line near the bottom:

```js
const SUPABASE_ANON_KEY = "PASTE_YOUR_ANON_PUBLIC_KEY_HERE";
```

Replace the placeholder with your anon key, save, and upload the updated
`portfolio.html` to your repo (same way as before). The project URL is already set to
`https://mvagebjizddemohhelta.supabase.co`.

*(Or just paste the anon key to Claude and it will embed it and upload for you.)*

## Step 4 — Use it
- Open `https://port.080342.xyz/portfolio.html`.
- First time: type a username + PIN → **Create account**.
- After that: **Log in** on any device → your holdings appear everywhere.
- Add stocks and options; everything saves to the cloud automatically (and a local
  copy is kept as offline backup).

## Notes
- **Security:** username+PIN is convenient but not bank-grade. Use a 6+ digit PIN you
  don't reuse, since the free tier has no brute-force throttling. Only your holdings
  list is stored — no money or broker access.
- **Options:** ×100 multiplier per contract. Long P/L = (current − premium); sold/short
  P/L = (premium − current). Enter the current option price per share to update P/L.
- **Not financial advice** — decision-support only.
