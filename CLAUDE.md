# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Robot Framework automation suite for e-commerce functional and regression testing on siman.com. Tests cover checkout flows across multiple countries (SV, GT, CR, NI), user types (guest, new, recurrent), and delivery/cart combinations. Uses SeleniumLibrary for browser automation and RequestsLibrary for Mailsac OTP email API integration.

## Commands

### Setup
```bash
pip install -r requirements.txt
```

### Run Tests
```bash
# Full execution with XRay payload, Allure report, and dashboard update
python run_and_report.py sandbox
python run_and_report.py prod

# Test execution + basic reporting only (no XRay/Allure)
python run_tests.py sandbox
python run_tests.py prod

# Single suite directly
robot -d results/sandbox tests/regression/flujos_checkout_guest_user.robot

# Syntax check without executing
robot --dryrun tests/

# Run by tag
robot --include delivery_siman tests/

# Parallel execution
pabot --processes 4 --outputdir results/regression tests/regression/
```

### Generate Reports (after test run)
```bash
python generate_detailed_report.py
python export_test_reports.py
```

## Architecture

### Directory Structure
```
resources/
  libraries/    # Custom Python libraries (ApiUtils.py, CustomLibrary.py)
  locators/     # UI selectors organized by page module (prefer id= selectors)
  keywords/     # Reusable keyword libraries grouped by domain
  variables/    # Global config, URLs, and test data

tests/
  regression/         # Checkout scenario matrix (cart type × user type)
  new_user_test/      # Template-based new user flows
  api_otp/            # OTP API retrieval validation

configs/              # env_prod.yaml / env_sandbox.yaml
results/              # Auto-generated: executions/, dashboards/, allure-results/, xray/
```

### Keyword Layer

- **`browser_keywords.resource`** — Browser setup (Chrome/Firefox, headless in CI), URL construction by environment+cart+country. Country codes here are **lowercase** (sv/gt/cr/ni).
- **`checkout_keywords.resource`** — Full checkout workflow: `Login Checkout`, `Fill User Form`, `Send OTP Email`, `Create New Adress In Checkout`, `Select Split Delivery`, `Select Payment Method`, `Finish Purchase`.
- **`general_keywords.resource`** — Reusable UI helpers, email generation, Yopmail/Mailsac login helpers.
- **`mailsac_keywords.resource`** / **`catchmail_keywords.resource`** — REST API calls to Mailsac for OTP retrieval (up to 36 attempts × 5s retry).
- **`locators/*.resource`** — All selectors in one place per module.
- **`resources/libraries/`** — Custom Python libraries imported by keywords.

### Test Flow

Each test: open browser → `Open Browser To Checkout` (cart type + lowercase country) → `Login Checkout` (uppercase country + user type) → OTP if new/recurrent → fill address → select delivery → `Select Payment Method` → `Finish Purchase` → `Close Browser` teardown.

### Key Variables

- **`environment.resource`** — `${BROWSER}`, `${TIMEOUT}`, `${HEADLESS}`, `${CI}`, `${MAILSAC_API_KEY}`, `${ENVIRONMENT}`. `${CI}` reads `%{CI=false}`; when `true` browser launches with `--headless=new`.
- **`checkout_urls.resource`** — Cart URLs keyed by environment + cart type. Available cart types: `small`, `small_mk`, `big`, `split_siman`, `split_siman_mk`, `split_st_bt_mk`, `split_st_moto`, `split_bt_moto`, `split_st_bt_moto`, `split_mk_moto`, `split_st_bt_mk_moto`.
- **`testdata.resource`** — Test user fields (name, DUI, phone), `${EMAIL_RECURRENT}=robotsiman@mailsac.com`.

### Multi-Country / Multi-User Pattern

`Open Browser To Checkout` takes the cart type, the country and an optional channel (`online` by default, or `instore`), and fails if that combination has no URL. Country is case-insensitive in `Open Browser To Checkout`, `Login Checkout` and `Fill User Form`. User type (`guest_user`/`new_user`/`recurrent_user`) controls whether OTP flow runs — guest skips OTP entirely, new user sends OTP to a freshly generated random email, recurrent user sends OTP to `${EMAIL_RECURRENT}`.

### Notable Behaviors

- **Production guard:** on production accounts (`siman.myvtex.com`, `*.siman.com`) `Select Payment Method` and `Click Payment Submit Button` end the test in SKIP once the purchase button is reached, unless run with `--variable ALLOW_REAL_ORDERS:True`. Sandbox SV uses the QA account `simanqa`, where purchases are not blocked.
- **SV shipping form:** on `simanqa` and `siman` the `#ship-*` selects are hidden and the visible ones have no id; `Select Address Level` handles both forms. Municipio is `San Salvador Centro` and distrito `San Salvador`.
- **Instore workspaces:** the cart loads, but `seller-code-guard-lock` blocks the Continue button until a seller code is provided.
- `Select Split Method` silently remaps `Motocity` pickup to `Florely` — intentional workaround for a pickup point naming difference.
- `Finish Purchase verify` performs a full VTEX admin login to extract the order number; `no_verify` only waits for the VTEX login input to appear.
- Tests use `CSC-XXXX` tags (e.g., `[Tags] CSC-8202`) so `run_tests.py` can generate XRay Server payloads keyed by those IDs.
- `run_and_report.py` vs `run_tests.py`: both run tests, but only `run_and_report.py` generates the Allure report and XRay payload.

### CI (GitHub Actions)

`.github/workflows/robot-ci.yml` runs on push to `main` and on `workflow_dispatch` (environment input defaults to `sandbox`). Sets `CI=true` so browser runs headless. Publishes Allure + Robot reports to GitHub Pages via `gh-pages` branch.
