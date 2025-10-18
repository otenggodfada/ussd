# USSD Code Scraper for Ghana

This script scrapes USSD codes from various Ghanaian services including banks, telecom providers, utilities, and government services.

## Installation

```bash
# Install Python dependencies
pip install -r requirements.txt
```

## Usage

```bash
# Run the scraper
python ussd_scraper.py
```

This will:
1. Scrape USSD codes from multiple categories
2. Save the data to `../assets/dataset/ussd_codes_ghana.json`
3. Display statistics about the scraped codes

## Output

The scraper generates a JSON file with USSD codes including:
- Bank services (GCB, Absa, Ecobank, Fidelity, etc.)
- Mobile Money (MTN, Vodafone, AirtelTigo)
- Telecom services (Balance, Data, Credit)
- Utilities (ECG, Water, DSTV, GoTV)
- Government services (Ghana Card, NHIS, SSNIT)

## Categories

- **Banking** - Bank mobile banking services
- **Mobile Money** - Mobile money transfers
- **Telecom** - Airtime, data, and mobile services
- **Utilities** - Electricity, water, and entertainment
- **Government** - Government services
- **Entertainment** - TV subscriptions

## Customization

You can add more USSD codes by editing the `ussd_scraper.py` file and adding them to the respective scraping methods.

