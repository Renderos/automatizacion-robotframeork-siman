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
# With environment config loading and auto-report generation
python run_and_report.py sandbox
python run_and_report.py prod

# Test execution only
python run_tests.py sandbox
python run_tests.py prod

# Direct robot command (single suite or file)
robot -d results/sandbox tests/regression/flujos_checkout_guest_user.robot
robot --dryrun tests/   # syntax check without executing

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
  locators/     # UI selectors organized by page module (ID-based selectors)
  keywords/     # Reusable keyword libraries grouped by domain
  variables/    # Global config, URLs, and test data

tests/
  regression/         # 30+ checkout scenario combinations
  new_user_test/      # Template-based new user flows
  api_otp/            # OTP API retrieval validation

configs/              # env_prod.yaml / env_sandbox.yaml
results/              # Auto-generated: executions/, dashboards/, exports/
```

### Keyword Layer Organization

- **`browser_keywords.resource`** — Browser setup (Chrome/headless), URL construction, multi-country base URL routing
- **`checkout_keywords.resource`** — End-to-end checkout workflow: login, address form, OTP, delivery selection, payment, order completion
- **`general_keywords.resource`** — Reusable UI interactions, email generation, Yopmail/Mailsac login helpers
- **`mailsac_keywords.resource`** / **`catchmail_keywords.resource`** — REST API calls to Mailsac for OTP retrieval with retry logic (up to 36 attempts × 5s)
- **`locators/*.resource`** — All selectors in one place per module; use `id=` locators for stability

### Test Flow

Each test follows: open browser → open checkout URL (by cart type) → login by user type → OTP verification if needed → fill address (country-specific) → select delivery → select payment → finish purchase → `Close Browser` teardown.

### Key Variables (`resources/variables/`)

- **`environment.resource`** — `${BROWSER}`, `${TIMEOUT}`, `${HEADLESS}`, `${MAILSAC_API_KEY}`, `${ENVIRONMENT}`
- **`checkout_urls.resource`** — Cart URLs by type (small_ticket, big_ticket, split_siman, split_mk, split_moto) and country
- **`testdata.resource`** — Test user data (name, DUI, NIT, phone, document types), recurrent user email

### Multi-Country / Multi-User Pattern

`browser_keywords.resource` has `Set Base URL For Country` that routes by country code (sv/gt/cr/ni). `checkout_keywords.resource` has `Fill User Form` with country-specific branches for different document/address fields. User type (guest/new/recurrent) is passed as an argument and controls whether OTP flow runs.

### CI Detection

The `${CI}` variable reads `%{CI=false}` from the environment. When `true`, the browser is launched in headless mode with `--no-sandbox` and `--disable-gpu` flags automatically.

### Results & Reporting

`run_and_report.py` creates timestamped directories under `results/executions/YYYY/MM/`. It generates `output.xml`, `log.html`, `report.html`, updates `results/dashboards/data/execution_history.json`, and exports JSON/CSV/Markdown to `results/exports/`.
