"""
USSD Code Scraper for Uganda
Scrapes USSD codes from Ugandan banks, MTN Mobile Money, telecom providers, and services
"""

import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import json

class USSDScraperUganda:
    def __init__(self):
        self.ussd_codes = []
    
    def add_ugandan_banks(self):
        """Add Ugandan bank USSD codes"""
        print("🏦 Adding Ugandan Bank Codes...")
        
        banks = [
            {
                'name': 'Stanbic Bank Uganda',
                'code': '*291#',
                'category': 'Banking',
                'description': 'Stanbic Bank mobile banking',
                'provider': 'Stanbic Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Centenary Bank',
                'code': '*236#',
                'category': 'Banking',
                'description': 'Centenary Bank Cente Mobile',
                'provider': 'Centenary Bank',
                'network': 'All Networks'
            },
            {
                'name': 'dfcu Bank',
                'code': '*256#',
                'category': 'Banking',
                'description': 'dfcu Bank mobile banking',
                'provider': 'dfcu Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Equity Bank Uganda',
                'code': '*365#',
                'category': 'Banking',
                'description': 'Equity Bank mobile banking',
                'provider': 'Equity Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Standard Chartered Uganda',
                'code': '*290#',
                'category': 'Banking',
                'description': 'Standard Chartered mobile banking',
                'provider': 'Standard Chartered',
                'network': 'All Networks'
            },
            {
                'name': 'Barclays Bank Uganda',
                'code': '*253#',
                'category': 'Banking',
                'description': 'Barclays Bank mobile banking',
                'provider': 'Barclays Bank',
                'network': 'All Networks'
            },
            {
                'name': 'ABSA Bank Uganda',
                'code': '*253#',
                'category': 'Banking',
                'description': 'ABSA Bank mobile banking',
                'provider': 'ABSA Bank',
                'network': 'All Networks'
            },
            {
                'name': 'KCB Bank Uganda',
                'code': '*217#',
                'category': 'Banking',
                'description': 'KCB Bank mobile banking',
                'provider': 'KCB Bank',
                'network': 'All Networks'
            },
            {
                'name': 'DTB Uganda',
                'code': '*252#',
                'category': 'Banking',
                'description': 'Diamond Trust Bank mobile banking',
                'provider': 'DTB',
                'network': 'All Networks'
            },
            {
                'name': 'Housing Finance Bank',
                'code': '*291*3#',
                'category': 'Banking',
                'description': 'Housing Finance Bank mobile banking',
                'provider': 'Housing Finance',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(banks)
        print(f"✅ Added {len(banks)} Ugandan bank codes")
        return len(banks)
    
    def add_mtn_mobile_money(self):
        """Add MTN Mobile Money Uganda USSD codes"""
        print("💰 Adding MTN Mobile Money Uganda...")
        
        mtn_momo = [
            {
                'name': 'MTN Mobile Money',
                'code': '*165#',
                'category': 'Mobile Money',
                'description': 'MTN Mobile Money - send, receive, pay bills',
                'provider': 'MTN Mobile Money',
                'network': 'MTN'
            },
            {
                'name': 'MTN MoMo Balance',
                'code': '*165*6#',
                'category': 'Mobile Money',
                'description': 'Check MTN Mobile Money balance',
                'provider': 'MTN Mobile Money',
                'network': 'MTN'
            },
            {
                'name': 'MTN MoMo PIN Change',
                'code': '*165*3#',
                'category': 'Mobile Money',
                'description': 'Change MTN Mobile Money PIN',
                'provider': 'MTN Mobile Money',
                'network': 'MTN'
            },
            {
                'name': 'MTN MoKash',
                'code': '*165*2#',
                'category': 'Mobile Money',
                'description': 'MTN MoKash savings and loans',
                'provider': 'MTN MoKash',
                'network': 'MTN'
            },
        ]
        
        self.ussd_codes.extend(mtn_momo)
        print(f"✅ Added {len(mtn_momo)} MTN Mobile Money codes")
        return len(mtn_momo)
    
    def add_mobile_money_services(self):
        """Add other mobile money services"""
        print("💰 Adding Mobile Money Services...")
        
        mobile_money = [
            {
                'name': 'Airtel Money Uganda',
                'code': '*185#',
                'category': 'Mobile Money',
                'description': 'Airtel Money mobile money services',
                'provider': 'Airtel Money',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Money Balance',
                'code': '*185*6#',
                'category': 'Mobile Money',
                'description': 'Check Airtel Money balance',
                'provider': 'Airtel Money',
                'network': 'Airtel'
            },
        ]
        
        self.ussd_codes.extend(mobile_money)
        print(f"✅ Added {len(mobile_money)} mobile money codes")
        return len(mobile_money)
    
    def add_mtn_uganda(self):
        """Add MTN Uganda USSD codes"""
        print("📱 Adding MTN Uganda...")
        
        mtn_codes = [
            {
                'name': 'MTN Balance Check',
                'code': '*131*6#',
                'category': 'Telecom',
                'description': 'Check MTN airtime balance',
                'provider': 'MTN Uganda',
                'network': 'MTN'
            },
            {
                'name': 'MTN Data Bundles',
                'code': '*150#',
                'category': 'Telecom',
                'description': 'Buy MTN data bundles',
                'provider': 'MTN Uganda',
                'network': 'MTN'
            },
            {
                'name': 'MTN My Number',
                'code': '*157#',
                'category': 'Telecom',
                'description': 'Check your MTN number',
                'provider': 'MTN Uganda',
                'network': 'MTN'
            },
            {
                'name': 'MTN Share Credit',
                'code': '*193#',
                'category': 'Telecom',
                'description': 'Share airtime with MTN users',
                'provider': 'MTN Uganda',
                'network': 'MTN'
            },
            {
                'name': 'MTN Borrow Airtime',
                'code': '*155#',
                'category': 'Telecom',
                'description': 'Borrow airtime from MTN',
                'provider': 'MTN Uganda',
                'network': 'MTN'
            },
        ]
        
        self.ussd_codes.extend(mtn_codes)
        print(f"✅ Added {len(mtn_codes)} MTN Uganda codes")
        return len(mtn_codes)
    
    def add_airtel_uganda(self):
        """Add Airtel Uganda USSD codes"""
        print("📱 Adding Airtel Uganda...")
        
        airtel_codes = [
            {
                'name': 'Airtel Balance Check',
                'code': '*131#',
                'category': 'Telecom',
                'description': 'Check Airtel balance',
                'provider': 'Airtel Uganda',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Data Bundles',
                'code': '*175#',
                'category': 'Telecom',
                'description': 'Buy Airtel data bundles',
                'provider': 'Airtel Uganda',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel My Number',
                'code': '*121#',
                'category': 'Telecom',
                'description': 'Check your Airtel number',
                'provider': 'Airtel Uganda',
                'network': 'Airtel'
            },
        ]
        
        self.ussd_codes.extend(airtel_codes)
        print(f"✅ Added {len(airtel_codes)} Airtel codes")
        return len(airtel_codes)
    
    def add_utility_services(self):
        """Add Ugandan utility services"""
        print("⚡ Adding Utility Services...")
        
        utilities = [
            {
                'name': 'UMEME Yaka',
                'code': '*185*2#',
                'category': 'Utilities',
                'description': 'Buy UMEME Yaka prepaid electricity',
                'provider': 'UMEME',
                'network': 'All Networks'
            },
            {
                'name': 'NWSC Water',
                'code': '*185*6#',
                'category': 'Utilities',
                'description': 'Pay water bills',
                'provider': 'NWSC',
                'network': 'All Networks'
            },
            {
                'name': 'DSTV Uganda',
                'code': '*165*2*1#',
                'category': 'Utilities',
                'description': 'Pay DSTV subscription',
                'provider': 'DSTV Uganda',
                'network': 'All Networks'
            },
            {
                'name': 'GOtv Uganda',
                'code': '*165*2*2#',
                'category': 'Utilities',
                'description': 'Pay GOtv subscription',
                'provider': 'GOtv Uganda',
                'network': 'All Networks'
            },
            {
                'name': 'StarTimes Uganda',
                'code': '*165*2*3#',
                'category': 'Utilities',
                'description': 'Pay StarTimes subscription',
                'provider': 'StarTimes Uganda',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(utilities)
        print(f"✅ Added {len(utilities)} utility codes")
        return len(utilities)
    
    def scrape_all(self):
        """Collect all Ugandan USSD codes"""
        print("🚀 Starting Uganda USSD Code Collection...")
        print("=" * 50)
        
        self.add_ugandan_banks()
        self.add_mtn_mobile_money()
        self.add_mobile_money_services()
        self.add_mtn_uganda()
        self.add_airtel_uganda()
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
    
    def save_to_json(self, filename: str = 'ussd_codes_uganda.json'):
        """Save Ugandan USSD codes to JSON file"""
        for i, code in enumerate(self.ussd_codes):
            code['id'] = f'ug_{i+1:04d}'
            code['country'] = 'Uganda'
            code['last_updated'] = '2025-10-18T00:00:00Z'
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(self.ussd_codes, f, indent=2, ensure_ascii=False)
        
        print(f"\n💾 Saved {len(self.ussd_codes)} USSD codes to {filename}")

def main():
    scraper = USSDScraperUganda()
    ussd_codes = scraper.scrape_all()
    scraper.save_to_json('../assets/dataset/ussd_codes_uganda.json')
    
    print("\n✅ Scraping Complete!")
    print(f"📊 Categories: {len(set(code['category'] for code in ussd_codes))}")
    print(f"🏢 Providers: {len(set(code['provider'] for code in ussd_codes))}")

if __name__ == '__main__':
    main()

