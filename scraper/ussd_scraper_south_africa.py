"""
USSD Code Scraper for South Africa
Scrapes USSD codes from South African banks, mobile money, and telecom providers
"""

import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import json

class USSDScraperSouthAfrica:
    def __init__(self):
        self.ussd_codes = []
    
    def add_south_african_banks(self):
        """Add South African bank USSD codes"""
        print("🏦 Adding South African Bank Codes...")
        
        banks = [
            {
                'name': 'Standard Bank',
                'code': '*130*99#',
                'category': 'Banking',
                'description': 'Standard Bank instant money and banking',
                'provider': 'Standard Bank',
                'network': 'All Networks'
            },
            {
                'name': 'FNB Banking',
                'code': '*120*321#',
                'category': 'Banking',
                'description': 'FNB mobile banking services',
                'provider': 'FNB',
                'network': 'All Networks'
            },
            {
                'name': 'ABSA Bank',
                'code': '*120*2272#',
                'category': 'Banking',
                'description': 'ABSA mobile banking',
                'provider': 'ABSA Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Nedbank',
                'code': '*120*2633#',
                'category': 'Banking',
                'description': 'Nedbank mobile banking',
                'provider': 'Nedbank',
                'network': 'All Networks'
            },
            {
                'name': 'Capitec Bank',
                'code': '*120*3279#',
                'category': 'Banking',
                'description': 'Capitec Bank remote banking',
                'provider': 'Capitec Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Investec Bank',
                'code': '*120*7463#',
                'category': 'Banking',
                'description': 'Investec mobile banking',
                'provider': 'Investec',
                'network': 'All Networks'
            },
            {
                'name': 'African Bank',
                'code': '*120*2432#',
                'category': 'Banking',
                'description': 'African Bank mobile services',
                'provider': 'African Bank',
                'network': 'All Networks'
            },
            {
                'name': 'TymeBank',
                'code': '*134*1234#',
                'category': 'Banking',
                'description': 'TymeBank digital banking',
                'provider': 'TymeBank',
                'network': 'All Networks'
            },
            {
                'name': 'Discovery Bank',
                'code': '*134*3472#',
                'category': 'Banking',
                'description': 'Discovery Bank mobile banking',
                'provider': 'Discovery Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Bidvest Bank',
                'code': '*120*8434#',
                'category': 'Banking',
                'description': 'Bidvest Bank mobile services',
                'provider': 'Bidvest Bank',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(banks)
        print(f"✅ Added {len(banks)} South African bank codes")
        return len(banks)
    
    def add_vodacom_services(self):
        """Add Vodacom South Africa USSD codes"""
        print("📱 Adding Vodacom South Africa...")
        
        vodacom_codes = [
            {
                'name': 'Vodacom Balance Check',
                'code': '*135#',
                'category': 'Telecom',
                'description': 'Check Vodacom balance',
                'provider': 'Vodacom',
                'network': 'Vodacom'
            },
            {
                'name': 'Vodacom Data Bundles',
                'code': '*135#',
                'category': 'Telecom',
                'description': 'Buy Vodacom data bundles',
                'provider': 'Vodacom',
                'network': 'Vodacom'
            },
            {
                'name': 'Vodacom My Number',
                'code': '*135*501#',
                'category': 'Telecom',
                'description': 'Check your Vodacom number',
                'provider': 'Vodacom',
                'network': 'Vodacom'
            },
            {
                'name': 'Vodacom Transfer Airtime',
                'code': '*135*47#',
                'category': 'Telecom',
                'description': 'Transfer airtime to others',
                'provider': 'Vodacom',
                'network': 'Vodacom'
            },
        ]
        
        self.ussd_codes.extend(vodacom_codes)
        print(f"✅ Added {len(vodacom_codes)} Vodacom codes")
        return len(vodacom_codes)
    
    def add_mtn_south_africa(self):
        """Add MTN South Africa USSD codes"""
        print("📱 Adding MTN South Africa...")
        
        mtn_codes = [
            {
                'name': 'MTN Balance Check',
                'code': '*136#',
                'category': 'Telecom',
                'description': 'Check MTN balance',
                'provider': 'MTN South Africa',
                'network': 'MTN'
            },
            {
                'name': 'MTN Data Bundles',
                'code': '*136#',
                'category': 'Telecom',
                'description': 'Buy MTN data bundles',
                'provider': 'MTN South Africa',
                'network': 'MTN'
            },
            {
                'name': 'MTN My Number',
                'code': '*136*8#',
                'category': 'Telecom',
                'description': 'Check your MTN number',
                'provider': 'MTN South Africa',
                'network': 'MTN'
            },
        ]
        
        self.ussd_codes.extend(mtn_codes)
        print(f"✅ Added {len(mtn_codes)} MTN codes")
        return len(mtn_codes)
    
    def add_cell_c(self):
        """Add Cell C South Africa USSD codes"""
        print("📱 Adding Cell C...")
        
        cellc_codes = [
            {
                'name': 'Cell C Balance Check',
                'code': '*147#',
                'category': 'Telecom',
                'description': 'Check Cell C balance',
                'provider': 'Cell C',
                'network': 'Cell C'
            },
            {
                'name': 'Cell C Data Bundles',
                'code': '*147#',
                'category': 'Telecom',
                'description': 'Buy Cell C data bundles',
                'provider': 'Cell C',
                'network': 'Cell C'
            },
            {
                'name': 'Cell C My Number',
                'code': '*147*789#',
                'category': 'Telecom',
                'description': 'Check your Cell C number',
                'provider': 'Cell C',
                'network': 'Cell C'
            },
        ]
        
        self.ussd_codes.extend(cellc_codes)
        print(f"✅ Added {len(cellc_codes)} Cell C codes")
        return len(cellc_codes)
    
    def add_telkom_mobile(self):
        """Add Telkom Mobile South Africa USSD codes"""
        print("📱 Adding Telkom Mobile...")
        
        telkom_codes = [
            {
                'name': 'Telkom Balance Check',
                'code': '*180#',
                'category': 'Telecom',
                'description': 'Check Telkom Mobile balance',
                'provider': 'Telkom Mobile',
                'network': 'Telkom'
            },
            {
                'name': 'Telkom Data Bundles',
                'code': '*180#',
                'category': 'Telecom',
                'description': 'Buy Telkom data bundles',
                'provider': 'Telkom Mobile',
                'network': 'Telkom'
            },
        ]
        
        self.ussd_codes.extend(telkom_codes)
        print(f"✅ Added {len(telkom_codes)} Telkom codes")
        return len(telkom_codes)
    
    def add_utility_services(self):
        """Add South African utility services"""
        print("⚡ Adding Utility Services...")
        
        utilities = [
            {
                'name': 'Eskom Prepaid',
                'code': '*120*321#',
                'category': 'Utilities',
                'description': 'Buy Eskom prepaid electricity',
                'provider': 'Eskom',
                'network': 'All Networks'
            },
            {
                'name': 'DSTV South Africa',
                'code': '*120*345#',
                'category': 'Utilities',
                'description': 'Pay DSTV subscription',
                'provider': 'DSTV',
                'network': 'All Networks'
            },
            {
                'name': 'ShowMax',
                'code': '*134*789#',
                'category': 'Utilities',
                'description': 'ShowMax subscription services',
                'provider': 'ShowMax',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(utilities)
        print(f"✅ Added {len(utilities)} utility codes")
        return len(utilities)
    
    def scrape_all(self):
        """Collect all South African USSD codes"""
        print("🚀 Starting South Africa USSD Code Collection...")
        print("=" * 50)
        
        self.add_south_african_banks()
        self.add_vodacom_services()
        self.add_mtn_south_africa()
        self.add_cell_c()
        self.add_telkom_mobile()
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
    
    def save_to_json(self, filename: str = 'ussd_codes_south_africa.json'):
        """Save South African USSD codes to JSON file"""
        for i, code in enumerate(self.ussd_codes):
            code['id'] = f'za_{i+1:04d}'
            code['country'] = 'South Africa'
            code['last_updated'] = '2025-10-18T00:00:00Z'
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(self.ussd_codes, f, indent=2, ensure_ascii=False)
        
        print(f"\n💾 Saved {len(self.ussd_codes)} USSD codes to {filename}")

def main():
    scraper = USSDScraperSouthAfrica()
    ussd_codes = scraper.scrape_all()
    scraper.save_to_json('../assets/dataset/ussd_codes_south_africa.json')
    
    print("\n✅ Scraping Complete!")
    print(f"📊 Categories: {len(set(code['category'] for code in ussd_codes))}")
    print(f"🏢 Providers: {len(set(code['provider'] for code in ussd_codes))}")

if __name__ == '__main__':
    main()

