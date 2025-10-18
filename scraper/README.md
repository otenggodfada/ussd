# USSD Code Scrapers (Multi-Country)

This directory contains scrapers for USSD codes from various countries. Currently supports Ghana and USA.

## Available Scrapers

### Ghana Scraper (`ussd_scraper.py`)
Scrapes USSD codes from various Ghanaian services including banks, telecom providers, utilities, and government services.

**Categories:**
- Banking (GCB, Absa, Ecobank, Fidelity, etc.)
- Mobile Money (MTN, Vodafone, AirtelTigo)
- Telecom services (Balance, Data, Credit)
- Utilities (ECG, Water, DSTV, GoTV)
- Government services (Ghana Card, NHIS, SSNIT)

### USA Scraper (`ussd_scraper_usa.py`)
Collects USSD/MMI codes for US mobile networks.

**Categories:**
- Device Info (IMEI, device diagnostics)
- Call Management (call forwarding, waiting, caller ID)
- Account Management (balance checks, refills)
- Customer Service (carrier support)

**Carriers:**
- AT&T
- T-Mobile
- Verizon
- Sprint
- Boost Mobile
- Cricket Wireless
- Metro by T-Mobile

## Installation

```bash
# Install Python dependencies
pip install -r requirements.txt
```

## Usage

```bash
# Run Ghana scraper
python ussd_scraper.py

# Run USA scraper
python ussd_scraper_usa.py
```

Each scraper will:
1. Collect USSD codes for the respective country
2. Save data to `../assets/dataset/ussd_codes_{country}.json`
3. Display statistics about the collected codes

## Adding a New Country

To add support for a new country:

1. **Create a new scraper file** (e.g., `ussd_scraper_kenya.py`)
2. **Follow the existing structure:**
   - Class name: `USSDScraper{Country}`
   - Methods for each category/provider
   - `scrape_all()` method to collect all codes
   - `save_to_json()` to save with format `ussd_codes_{country}.json`

3. **Update the app:**
   - Add the country to `USSDDataService.getAvailableCountries()` in `lib/utils/ussd_data_service.dart`
   - Add the JSON file path mapping in `getOfflineUSSDData()`
   - The app will automatically handle the new country

4. **JSON Format:**
```json
{
  "id": "{country_code}_{number}",
  "name": "Service Name",
  "code": "*123#",
  "category": "Category Name",
  "description": "Service description",
  "provider": "Provider Name",
  "network": "Network Name",
  "country": "Country Name",
  "last_updated": "2025-10-18T00:00:00Z"
}
```

## Categories

Standard categories (extend as needed):
- **Banking** - Bank mobile banking services
- **Mobile Money** - Mobile money and digital payments
- **Telecom** - Airtime, data, and mobile services
- **Utilities** - Electricity, water, and entertainment
- **Government** - Government services
- **Device Info** - Device diagnostics (USA)
- **Call Management** - Call features (USA)
- **Account Management** - Carrier account management
- **Customer Service** - Support contacts

## Notes

- USSD usage varies significantly by region
- Ghana/Africa: Heavy USSD use for mobile money, banking, utilities
- USA/Developed markets: Limited USSD, mainly MMI codes and carrier management
- Some countries may have very few USSD codes available

