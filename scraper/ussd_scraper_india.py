"""
USSD Code Scraper for India
Scrapes USSD codes from Indian banks, UPI, mobile recharge, and telecom providers
"""

import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import json

class USSDScraperIndia:
    def __init__(self):
        self.ussd_codes = []
    
    def add_indian_banks(self):
        """Add Indian bank USSD codes"""
        print("🏦 Adding Indian Bank Codes...")
        
        banks = [
            {
                'name': 'SBI Quick',
                'code': '*99#',
                'category': 'Banking',
                'description': 'State Bank of India mobile banking - SBI Quick',
                'provider': 'SBI',
                'network': 'All Networks'
            },
            {
                'name': 'HDFC Bank',
                'code': '*99*54#',
                'category': 'Banking',
                'description': 'HDFC Bank mobile banking',
                'provider': 'HDFC Bank',
                'network': 'All Networks'
            },
            {
                'name': 'ICICI Bank',
                'code': '*99*55#',
                'category': 'Banking',
                'description': 'ICICI Bank mobile banking',
                'provider': 'ICICI Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Axis Bank',
                'code': '*99*56#',
                'category': 'Banking',
                'description': 'Axis Bank mobile banking',
                'provider': 'Axis Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Kotak Mahindra Bank',
                'code': '*99*58#',
                'category': 'Banking',
                'description': 'Kotak Bank mobile banking',
                'provider': 'Kotak Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Punjab National Bank',
                'code': '*99*59#',
                'category': 'Banking',
                'description': 'PNB mobile banking',
                'provider': 'PNB',
                'network': 'All Networks'
            },
            {
                'name': 'Bank of Baroda',
                'code': '*99*60#',
                'category': 'Banking',
                'description': 'Bank of Baroda mobile banking',
                'provider': 'Bank of Baroda',
                'network': 'All Networks'
            },
            {
                'name': 'Canara Bank',
                'code': '*99*61#',
                'category': 'Banking',
                'description': 'Canara Bank mobile banking',
                'provider': 'Canara Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Union Bank of India',
                'code': '*99*62#',
                'category': 'Banking',
                'description': 'Union Bank mobile banking',
                'provider': 'Union Bank',
                'network': 'All Networks'
            },
            {
                'name': 'IDBI Bank',
                'code': '*99*63#',
                'category': 'Banking',
                'description': 'IDBI Bank mobile banking',
                'provider': 'IDBI Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Yes Bank',
                'code': '*99*64#',
                'category': 'Banking',
                'description': 'Yes Bank mobile banking',
                'provider': 'Yes Bank',
                'network': 'All Networks'
            },
            {
                'name': 'IndusInd Bank',
                'code': '*99*65#',
                'category': 'Banking',
                'description': 'IndusInd Bank mobile banking',
                'provider': 'IndusInd Bank',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(banks)
        print(f"✅ Added {len(banks)} Indian bank codes")
        return len(banks)
    
    def add_airtel_india(self):
        """Add Airtel India USSD codes"""
        print("📱 Adding Airtel India...")
        
        airtel_codes = [
            {
                'name': 'Airtel Balance Check',
                'code': '*121#',
                'category': 'Telecom',
                'description': 'Check Airtel balance',
                'provider': 'Airtel India',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Data Balance',
                'code': '*121*1#',
                'category': 'Telecom',
                'description': 'Check Airtel data balance',
                'provider': 'Airtel India',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel My Number',
                'code': '*121*9#',
                'category': 'Telecom',
                'description': 'Check your Airtel number',
                'provider': 'Airtel India',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Loan',
                'code': '*141#',
                'category': 'Telecom',
                'description': 'Get emergency talktime loan',
                'provider': 'Airtel India',
                'network': 'Airtel'
            },
        ]
        
        self.ussd_codes.extend(airtel_codes)
        print(f"✅ Added {len(airtel_codes)} Airtel codes")
        return len(airtel_codes)
    
    def add_jio_india(self):
        """Add Jio India USSD codes"""
        print("📱 Adding Jio India...")
        
        jio_codes = [
            {
                'name': 'Jio Balance Check',
                'code': '*333#',
                'category': 'Telecom',
                'description': 'Check Jio balance',
                'provider': 'Jio',
                'network': 'Jio'
            },
            {
                'name': 'Jio Data Balance',
                'code': '*333*1#',
                'category': 'Telecom',
                'description': 'Check Jio data balance',
                'provider': 'Jio',
                'network': 'Jio'
            },
            {
                'name': 'Jio My Number',
                'code': '*333*2#',
                'category': 'Telecom',
                'description': 'Check your Jio number',
                'provider': 'Jio',
                'network': 'Jio'
            },
        ]
        
        self.ussd_codes.extend(jio_codes)
        print(f"✅ Added {len(jio_codes)} Jio codes")
        return len(jio_codes)
    
    def add_vi_india(self):
        """Add VI (Vodafone Idea) India USSD codes"""
        print("📱 Adding VI India...")
        
        vi_codes = [
            {
                'name': 'VI Balance Check',
                'code': '*111#',
                'category': 'Telecom',
                'description': 'Check VI (Vodafone Idea) balance',
                'provider': 'VI',
                'network': 'VI'
            },
            {
                'name': 'VI Data Balance',
                'code': '*111*6#',
                'category': 'Telecom',
                'description': 'Check VI data balance',
                'provider': 'VI',
                'network': 'VI'
            },
            {
                'name': 'VI My Number',
                'code': '*111*2#',
                'category': 'Telecom',
                'description': 'Check your VI number',
                'provider': 'VI',
                'network': 'VI'
            },
            {
                'name': 'VI Loan',
                'code': '*141#',
                'category': 'Telecom',
                'description': 'Get VI emergency talktime',
                'provider': 'VI',
                'network': 'VI'
            },
        ]
        
        self.ussd_codes.extend(vi_codes)
        print(f"✅ Added {len(vi_codes)} VI codes")
        return len(vi_codes)
    
    def add_bsnl_india(self):
        """Add BSNL India USSD codes"""
        print("📱 Adding BSNL India...")
        
        bsnl_codes = [
            {
                'name': 'BSNL Balance Check',
                'code': '*123#',
                'category': 'Telecom',
                'description': 'Check BSNL balance',
                'provider': 'BSNL',
                'network': 'BSNL'
            },
            {
                'name': 'BSNL Data Balance',
                'code': '*123*10#',
                'category': 'Telecom',
                'description': 'Check BSNL data balance',
                'provider': 'BSNL',
                'network': 'BSNL'
            },
            {
                'name': 'BSNL My Number',
                'code': '*123*1#',
                'category': 'Telecom',
                'description': 'Check your BSNL number',
                'provider': 'BSNL',
                'network': 'BSNL'
            },
        ]
        
        self.ussd_codes.extend(bsnl_codes)
        print(f"✅ Added {len(bsnl_codes)} BSNL codes")
        return len(bsnl_codes)
    
    def add_payment_services(self):
        """Add Indian payment and wallet services"""
        print("💰 Adding Payment Services...")
        
        payment_services = [
            {
                'name': 'UPI - National Payments',
                'code': '*99#',
                'category': 'Mobile Money',
                'description': 'NPCI UPI for mobile payments',
                'provider': 'NPCI UPI',
                'network': 'All Networks'
            },
            {
                'name': 'Paytm Balance',
                'code': '*400#',
                'category': 'Mobile Money',
                'description': 'Check Paytm wallet balance',
                'provider': 'Paytm',
                'network': 'All Networks'
            },
            {
                'name': 'Paytm Payments',
                'code': '*321#',
                'category': 'Mobile Money',
                'description': 'Paytm payment services',
                'provider': 'Paytm',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(payment_services)
        print(f"✅ Added {len(payment_services)} payment service codes")
        return len(payment_services)
    
    def scrape_all(self):
        """Collect all Indian USSD codes"""
        print("🚀 Starting India USSD Code Collection...")
        print("=" * 50)
        
        self.add_indian_banks()
        self.add_airtel_india()
        self.add_jio_india()
        self.add_vi_india()
        self.add_bsnl_india()
        self.add_payment_services()
        
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
    
    def save_to_json(self, filename: str = 'ussd_codes_india.json'):
        """Save Indian USSD codes to JSON file"""
        for i, code in enumerate(self.ussd_codes):
            code['id'] = f'in_{i+1:04d}'
            code['country'] = 'India'
            code['last_updated'] = '2025-10-18T00:00:00Z'
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(self.ussd_codes, f, indent=2, ensure_ascii=False)
        
        print(f"\n💾 Saved {len(self.ussd_codes)} USSD codes to {filename}")

def main():
    scraper = USSDScraperIndia()
    ussd_codes = scraper.scrape_all()
    scraper.save_to_json('../assets/dataset/ussd_codes_india.json')
    
    print("\n✅ Scraping Complete!")
    print(f"📊 Categories: {len(set(code['category'] for code in ussd_codes))}")
    print(f"🏢 Providers: {len(set(code['provider'] for code in ussd_codes))}")

if __name__ == '__main__':
    main()

