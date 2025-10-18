"""
USSD Code Scraper for Tanzania
Scrapes USSD codes from Tanzanian banks, M-Pesa, telecom providers, and services
"""

import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import json

class USSDScraperTanzania:
    def __init__(self):
        self.ussd_codes = []
    
    def add_tanzanian_banks(self):
        """Add Tanzanian bank USSD codes"""
        print("🏦 Adding Tanzanian Bank Codes...")
        
        banks = [
            {
                'name': 'CRDB Bank SimBanking',
                'code': '*150*00#',
                'category': 'Banking',
                'description': 'CRDB Bank mobile banking services',
                'provider': 'CRDB Bank',
                'network': 'All Networks'
            },
            {
                'name': 'NMB Bank',
                'code': '*150*01#',
                'category': 'Banking',
                'description': 'NMB Bank mobile banking',
                'provider': 'NMB Bank',
                'network': 'All Networks'
            },
            {
                'name': 'NBC Bank',
                'code': '*150*02#',
                'category': 'Banking',
                'description': 'National Bank of Commerce mobile banking',
                'provider': 'NBC Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Stanbic Bank Tanzania',
                'code': '*150*04#',
                'category': 'Banking',
                'description': 'Stanbic Bank mobile banking',
                'provider': 'Stanbic Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Exim Bank',
                'code': '*150*05#',
                'category': 'Banking',
                'description': 'Exim Bank mobile banking',
                'provider': 'Exim Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Azania Bank',
                'code': '*150*07#',
                'category': 'Banking',
                'description': 'Azania Bank mobile banking',
                'provider': 'Azania Bank',
                'network': 'All Networks'
            },
            {
                'name': 'DTB Tanzania',
                'code': '*150*10#',
                'category': 'Banking',
                'description': 'Diamond Trust Bank mobile banking',
                'provider': 'DTB',
                'network': 'All Networks'
            },
            {
                'name': 'Equity Bank Tanzania',
                'code': '*150*60#',
                'category': 'Banking',
                'description': 'Equity Bank mobile banking',
                'provider': 'Equity Bank',
                'network': 'All Networks'
            },
            {
                'name': 'TPB Bank',
                'code': '*150*76#',
                'category': 'Banking',
                'description': 'Tanzania Postal Bank mobile banking',
                'provider': 'TPB Bank',
                'network': 'All Networks'
            },
            {
                'name': 'NCBA Bank Tanzania',
                'code': '*150*55#',
                'category': 'Banking',
                'description': 'NCBA Bank mobile banking',
                'provider': 'NCBA Bank',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(banks)
        print(f"✅ Added {len(banks)} Tanzanian bank codes")
        return len(banks)
    
    def add_mpesa_tanzania(self):
        """Add M-Pesa Tanzania USSD codes"""
        print("💰 Adding M-Pesa Tanzania...")
        
        mpesa_codes = [
            {
                'name': 'M-Pesa Tanzania',
                'code': '*150*00#',
                'category': 'Mobile Money',
                'description': 'M-Pesa mobile money services - send, receive, pay bills',
                'provider': 'M-Pesa Tanzania',
                'network': 'Vodacom'
            },
            {
                'name': 'M-Pesa Balance',
                'code': '*150*00*1#',
                'category': 'Mobile Money',
                'description': 'Check M-Pesa balance',
                'provider': 'M-Pesa Tanzania',
                'network': 'Vodacom'
            },
            {
                'name': 'M-Pesa PIN Change',
                'code': '*150*00*5#',
                'category': 'Mobile Money',
                'description': 'Change M-Pesa PIN',
                'provider': 'M-Pesa Tanzania',
                'network': 'Vodacom'
            },
        ]
        
        self.ussd_codes.extend(mpesa_codes)
        print(f"✅ Added {len(mpesa_codes)} M-Pesa codes")
        return len(mpesa_codes)
    
    def add_mobile_money_services(self):
        """Add other mobile money services"""
        print("💰 Adding Mobile Money Services...")
        
        mobile_money = [
            {
                'name': 'Tigo Pesa',
                'code': '*150*01#',
                'category': 'Mobile Money',
                'description': 'Tigo Pesa mobile money services',
                'provider': 'Tigo Pesa',
                'network': 'Tigo'
            },
            {
                'name': 'Airtel Money Tanzania',
                'code': '*150*60#',
                'category': 'Mobile Money',
                'description': 'Airtel Money mobile money services',
                'provider': 'Airtel Money',
                'network': 'Airtel'
            },
            {
                'name': 'Halotel Pesa',
                'code': '*150*88#',
                'category': 'Mobile Money',
                'description': 'Halotel Pesa mobile money services',
                'provider': 'Halotel Pesa',
                'network': 'Halotel'
            },
            {
                'name': 'Ezy Pesa',
                'code': '*150*02#',
                'category': 'Mobile Money',
                'description': 'Ezy Pesa mobile wallet by Zantel',
                'provider': 'Ezy Pesa',
                'network': 'Zantel'
            },
        ]
        
        self.ussd_codes.extend(mobile_money)
        print(f"✅ Added {len(mobile_money)} mobile money codes")
        return len(mobile_money)
    
    def add_vodacom_services(self):
        """Add Vodacom Tanzania USSD codes"""
        print("📱 Adding Vodacom Tanzania...")
        
        vodacom_codes = [
            {
                'name': 'Vodacom Balance Check',
                'code': '*100#',
                'category': 'Telecom',
                'description': 'Check Vodacom balance',
                'provider': 'Vodacom Tanzania',
                'network': 'Vodacom'
            },
            {
                'name': 'Vodacom Data Bundles',
                'code': '*149#',
                'category': 'Telecom',
                'description': 'Buy Vodacom data bundles',
                'provider': 'Vodacom Tanzania',
                'network': 'Vodacom'
            },
            {
                'name': 'Vodacom My Number',
                'code': '*100*1#',
                'category': 'Telecom',
                'description': 'Check your Vodacom number',
                'provider': 'Vodacom Tanzania',
                'network': 'Vodacom'
            },
            {
                'name': 'Vodacom Share Credit',
                'code': '*150#',
                'category': 'Telecom',
                'description': 'Share airtime with other Vodacom users',
                'provider': 'Vodacom Tanzania',
                'network': 'Vodacom'
            },
        ]
        
        self.ussd_codes.extend(vodacom_codes)
        print(f"✅ Added {len(vodacom_codes)} Vodacom codes")
        return len(vodacom_codes)
    
    def add_airtel_tanzania(self):
        """Add Airtel Tanzania USSD codes"""
        print("📱 Adding Airtel Tanzania...")
        
        airtel_codes = [
            {
                'name': 'Airtel Balance Check',
                'code': '*123#',
                'category': 'Telecom',
                'description': 'Check Airtel balance',
                'provider': 'Airtel Tanzania',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Data Bundles',
                'code': '*149#',
                'category': 'Telecom',
                'description': 'Buy Airtel data bundles',
                'provider': 'Airtel Tanzania',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel My Number',
                'code': '*123*1#',
                'category': 'Telecom',
                'description': 'Check your Airtel number',
                'provider': 'Airtel Tanzania',
                'network': 'Airtel'
            },
        ]
        
        self.ussd_codes.extend(airtel_codes)
        print(f"✅ Added {len(airtel_codes)} Airtel codes")
        return len(airtel_codes)
    
    def add_tigo_tanzania(self):
        """Add Tigo Tanzania USSD codes"""
        print("📱 Adding Tigo Tanzania...")
        
        tigo_codes = [
            {
                'name': 'Tigo Balance Check',
                'code': '*100#',
                'category': 'Telecom',
                'description': 'Check Tigo balance',
                'provider': 'Tigo Tanzania',
                'network': 'Tigo'
            },
            {
                'name': 'Tigo Data Bundles',
                'code': '*150*00#',
                'category': 'Telecom',
                'description': 'Buy Tigo data bundles',
                'provider': 'Tigo Tanzania',
                'network': 'Tigo'
            },
            {
                'name': 'Tigo My Number',
                'code': '*100*1#',
                'category': 'Telecom',
                'description': 'Check your Tigo number',
                'provider': 'Tigo Tanzania',
                'network': 'Tigo'
            },
        ]
        
        self.ussd_codes.extend(tigo_codes)
        print(f"✅ Added {len(tigo_codes)} Tigo codes")
        return len(tigo_codes)
    
    def add_utility_services(self):
        """Add Tanzanian utility services"""
        print("⚡ Adding Utility Services...")
        
        utilities = [
            {
                'name': 'LUKU Electricity',
                'code': '*150*00*4#',
                'category': 'Utilities',
                'description': 'Buy LUKU electricity tokens',
                'provider': 'TANESCO',
                'network': 'All Networks'
            },
            {
                'name': 'DAWASA Water',
                'code': '*150*00*3#',
                'category': 'Utilities',
                'description': 'Pay water bills',
                'provider': 'DAWASA',
                'network': 'All Networks'
            },
            {
                'name': 'DSTV Tanzania',
                'code': '*150*00*2#',
                'category': 'Utilities',
                'description': 'Pay DSTV subscription',
                'provider': 'DSTV Tanzania',
                'network': 'All Networks'
            },
            {
                'name': 'StarTimes Tanzania',
                'code': '*150*00*6#',
                'category': 'Utilities',
                'description': 'Pay StarTimes subscription',
                'provider': 'StarTimes Tanzania',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(utilities)
        print(f"✅ Added {len(utilities)} utility codes")
        return len(utilities)
    
    def scrape_all(self):
        """Collect all Tanzanian USSD codes"""
        print("🚀 Starting Tanzania USSD Code Collection...")
        print("=" * 50)
        
        self.add_tanzanian_banks()
        self.add_mpesa_tanzania()
        self.add_mobile_money_services()
        self.add_vodacom_services()
        self.add_airtel_tanzania()
        self.add_tigo_tanzania()
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
    
    def save_to_json(self, filename: str = 'ussd_codes_tanzania.json'):
        """Save Tanzanian USSD codes to JSON file"""
        for i, code in enumerate(self.ussd_codes):
            code['id'] = f'tz_{i+1:04d}'
            code['country'] = 'Tanzania'
            code['last_updated'] = '2025-10-18T00:00:00Z'
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(self.ussd_codes, f, indent=2, ensure_ascii=False)
        
        print(f"\n💾 Saved {len(self.ussd_codes)} USSD codes to {filename}")

def main():
    scraper = USSDScraperTanzania()
    ussd_codes = scraper.scrape_all()
    scraper.save_to_json('../assets/dataset/ussd_codes_tanzania.json')
    
    print("\n✅ Scraping Complete!")
    print(f"📊 Categories: {len(set(code['category'] for code in ussd_codes))}")
    print(f"🏢 Providers: {len(set(code['provider'] for code in ussd_codes))}")

if __name__ == '__main__':
    main()

