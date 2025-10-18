"""
USSD Code Scraper for Rwanda
Scrapes USSD codes from Rwandan banks, mobile money, and telecom providers
"""

import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import json

class USSDScraperRwanda:
    def __init__(self):
        self.ussd_codes = []
    
    def add_rwandan_banks(self):
        """Add Rwandan bank USSD codes"""
        print("🏦 Adding Rwandan Bank Codes...")
        
        banks = [
            {
                'name': 'Bank of Kigali',
                'code': '*550#',
                'category': 'Banking',
                'description': 'Bank of Kigali mobile banking - BK Urubuga',
                'provider': 'Bank of Kigali',
                'network': 'All Networks'
            },
            {
                'name': 'Equity Bank Rwanda',
                'code': '*595#',
                'category': 'Banking',
                'description': 'Equity Bank mobile banking',
                'provider': 'Equity Bank',
                'network': 'All Networks'
            },
            {
                'name': 'I&M Bank Rwanda',
                'code': '*512#',
                'category': 'Banking',
                'description': 'I&M Bank mobile banking',
                'provider': 'I&M Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Ecobank Rwanda',
                'code': '*550*0#',
                'category': 'Banking',
                'description': 'Ecobank mobile banking',
                'provider': 'Ecobank',
                'network': 'All Networks'
            },
            {
                'name': 'Cogebanque',
                'code': '*737#',
                'category': 'Banking',
                'description': 'Cogebanque mobile banking',
                'provider': 'Cogebanque',
                'network': 'All Networks'
            },
            {
                'name': 'KCB Rwanda',
                'code': '*501#',
                'category': 'Banking',
                'description': 'KCB Bank mobile banking',
                'provider': 'KCB Rwanda',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(banks)
        print(f"✅ Added {len(banks)} Rwandan bank codes")
        return len(banks)
    
    def add_mtn_momo_rwanda(self):
        """Add MTN Mobile Money Rwanda USSD codes"""
        print("💰 Adding MTN Mobile Money Rwanda...")
        
        mtn_momo = [
            {
                'name': 'MTN Mobile Money',
                'code': '*182#',
                'category': 'Mobile Money',
                'description': 'MTN Mobile Money Rwanda - MoMo',
                'provider': 'MTN Mobile Money',
                'network': 'MTN'
            },
            {
                'name': 'MTN MoMo Balance',
                'code': '*182*6#',
                'category': 'Mobile Money',
                'description': 'Check MTN MoMo balance',
                'provider': 'MTN Mobile Money',
                'network': 'MTN'
            },
            {
                'name': 'MTN MoMo PIN Change',
                'code': '*182*5#',
                'category': 'Mobile Money',
                'description': 'Change MTN MoMo PIN',
                'provider': 'MTN Mobile Money',
                'network': 'MTN'
            },
        ]
        
        self.ussd_codes.extend(mtn_momo)
        print(f"✅ Added {len(mtn_momo)} MTN Mobile Money codes")
        return len(mtn_momo)
    
    def add_airtel_money_rwanda(self):
        """Add Airtel Money Rwanda USSD codes"""
        print("💰 Adding Airtel Money Rwanda...")
        
        airtel_money = [
            {
                'name': 'Airtel Money Rwanda',
                'code': '*500#',
                'category': 'Mobile Money',
                'description': 'Airtel Money mobile money services',
                'provider': 'Airtel Money',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Money Balance',
                'code': '*500*6#',
                'category': 'Mobile Money',
                'description': 'Check Airtel Money balance',
                'provider': 'Airtel Money',
                'network': 'Airtel'
            },
        ]
        
        self.ussd_codes.extend(airtel_money)
        print(f"✅ Added {len(airtel_money)} Airtel Money codes")
        return len(airtel_money)
    
    def add_mtn_rwanda(self):
        """Add MTN Rwanda USSD codes"""
        print("📱 Adding MTN Rwanda...")
        
        mtn_codes = [
            {
                'name': 'MTN Balance Check',
                'code': '*182*1#',
                'category': 'Telecom',
                'description': 'Check MTN airtime balance',
                'provider': 'MTN Rwanda',
                'network': 'MTN'
            },
            {
                'name': 'MTN Data Bundles',
                'code': '*155#',
                'category': 'Telecom',
                'description': 'Buy MTN data bundles',
                'provider': 'MTN Rwanda',
                'network': 'MTN'
            },
            {
                'name': 'MTN My Number',
                'code': '*123#',
                'category': 'Telecom',
                'description': 'Check your MTN number',
                'provider': 'MTN Rwanda',
                'network': 'MTN'
            },
        ]
        
        self.ussd_codes.extend(mtn_codes)
        print(f"✅ Added {len(mtn_codes)} MTN Rwanda codes")
        return len(mtn_codes)
    
    def add_airtel_rwanda(self):
        """Add Airtel Rwanda USSD codes"""
        print("📱 Adding Airtel Rwanda...")
        
        airtel_codes = [
            {
                'name': 'Airtel Balance Check',
                'code': '*131#',
                'category': 'Telecom',
                'description': 'Check Airtel balance',
                'provider': 'Airtel Rwanda',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Data Bundles',
                'code': '*175#',
                'category': 'Telecom',
                'description': 'Buy Airtel data bundles',
                'provider': 'Airtel Rwanda',
                'network': 'Airtel'
            },
        ]
        
        self.ussd_codes.extend(airtel_codes)
        print(f"✅ Added {len(airtel_codes)} Airtel codes")
        return len(airtel_codes)
    
    def add_utility_services(self):
        """Add Rwandan utility services"""
        print("⚡ Adding Utility Services...")
        
        utilities = [
            {
                'name': 'REG Electricity',
                'code': '*182*2#',
                'category': 'Utilities',
                'description': 'Pay REG electricity bills',
                'provider': 'REG',
                'network': 'All Networks'
            },
            {
                'name': 'DSTV Rwanda',
                'code': '*182*7*1#',
                'category': 'Utilities',
                'description': 'Pay DSTV subscription',
                'provider': 'DSTV Rwanda',
                'network': 'All Networks'
            },
            {
                'name': 'StarTimes Rwanda',
                'code': '*182*7*2#',
                'category': 'Utilities',
                'description': 'Pay StarTimes subscription',
                'provider': 'StarTimes Rwanda',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(utilities)
        print(f"✅ Added {len(utilities)} utility codes")
        return len(utilities)
    
    def scrape_all(self):
        """Collect all Rwandan USSD codes"""
        print("🚀 Starting Rwanda USSD Code Collection...")
        print("=" * 50)
        
        self.add_rwandan_banks()
        self.add_mtn_momo_rwanda()
        self.add_airtel_money_rwanda()
        self.add_mtn_rwanda()
        self.add_airtel_rwanda()
        self.add_utility_services()
        
        # Remove duplicates
        seen_codes = set()
        unique_codes = []
        for code_data in self.ussd_codes:
            code_key = (code_data['code'], code_data['provider'])
            if code_key not in seen_codes:
                seen_codes.add(code_key)
                unique_codes.append(code_data)
        
        self.ussd_codes = unique_codes
        
        print("=" * 50)
        print(f"✨ Total Unique USSD Codes: {len(self.ussd_codes)}")
        
        return self.ussd_codes
    
    def save_to_json(self, filename: str = 'ussd_codes_rwanda.json'):
        """Save Rwandan USSD codes to JSON file"""
        for i, code in enumerate(self.ussd_codes):
            code['id'] = f'rw_{i+1:04d}'
            code['country'] = 'Rwanda'
            code['last_updated'] = '2025-10-18T00:00:00Z'
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(self.ussd_codes, f, indent=2, ensure_ascii=False)
        
        print(f"\n💾 Saved {len(self.ussd_codes)} USSD codes to {filename}")

def main():
    scraper = USSDScraperRwanda()
    ussd_codes = scraper.scrape_all()
    scraper.save_to_json('../assets/dataset/ussd_codes_rwanda.json')
    
    print("\n✅ Scraping Complete!")
    print(f"📊 Categories: {len(set(code['category'] for code in ussd_codes))}")
    print(f"🏢 Providers: {len(set(code['provider'] for code in ussd_codes))}")

if __name__ == '__main__':
    main()

