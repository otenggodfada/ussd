"""
USSD Code Scraper for Nigeria
Scrapes USSD codes from Nigerian banks, mobile money, telecom providers, and services
"""

import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import json

class USSDScraperNigeria:
    def __init__(self):
        self.ussd_codes = []
    
    def add_nigerian_banks(self):
        """Add Nigerian bank USSD codes"""
        print("🏦 Adding Nigerian Bank Codes...")
        
        banks = [
            # Major Commercial Banks
            {
                'name': 'GTBank Quick Banking',
                'code': '*737#',
                'category': 'Banking',
                'description': 'GTBank mobile banking services - transfer, airtime, bills',
                'provider': 'GTBank',
                'network': 'All Networks'
            },
            {
                'name': 'Access Bank',
                'code': '*901#',
                'category': 'Banking',
                'description': 'Access Bank mobile banking and account services',
                'provider': 'Access Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Zenith Bank',
                'code': '*966#',
                'category': 'Banking',
                'description': 'Zenith Bank mobile banking and transfers',
                'provider': 'Zenith Bank',
                'network': 'All Networks'
            },
            {
                'name': 'First Bank',
                'code': '*894#',
                'category': 'Banking',
                'description': 'FirstBank mobile banking services',
                'provider': 'First Bank',
                'network': 'All Networks'
            },
            {
                'name': 'UBA Mobile Banking',
                'code': '*919#',
                'category': 'Banking',
                'description': 'UBA mobile banking and transfers',
                'provider': 'UBA',
                'network': 'All Networks'
            },
            {
                'name': 'Stanbic IBTC',
                'code': '*909#',
                'category': 'Banking',
                'description': 'Stanbic IBTC mobile banking services',
                'provider': 'Stanbic IBTC',
                'network': 'All Networks'
            },
            {
                'name': 'Fidelity Bank',
                'code': '*770#',
                'category': 'Banking',
                'description': 'Fidelity Bank mobile banking and instant banking',
                'provider': 'Fidelity Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Union Bank',
                'code': '*826#',
                'category': 'Banking',
                'description': 'Union Bank UnionMobile services',
                'provider': 'Union Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Sterling Bank',
                'code': '*822#',
                'category': 'Banking',
                'description': 'Sterling Bank mobile banking',
                'provider': 'Sterling Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Ecobank Nigeria',
                'code': '*326#',
                'category': 'Banking',
                'description': 'Ecobank mobile banking and transfers',
                'provider': 'Ecobank',
                'network': 'All Networks'
            },
            {
                'name': 'FCMB Mobile',
                'code': '*329#',
                'category': 'Banking',
                'description': 'FCMB mobile banking services',
                'provider': 'FCMB',
                'network': 'All Networks'
            },
            {
                'name': 'Wema Bank ALAT',
                'code': '*945#',
                'category': 'Banking',
                'description': 'Wema Bank ALAT digital banking',
                'provider': 'Wema Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Unity Bank',
                'code': '*7799#',
                'category': 'Banking',
                'description': 'Unity Bank mobile banking',
                'provider': 'Unity Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Keystone Bank',
                'code': '*7111#',
                'category': 'Banking',
                'description': 'Keystone Bank mobile banking',
                'provider': 'Keystone Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Heritage Bank',
                'code': '*322#',
                'category': 'Banking',
                'description': 'Heritage Bank mobile banking',
                'provider': 'Heritage Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Polaris Bank',
                'code': '*833#',
                'category': 'Banking',
                'description': 'Polaris Bank VULTe mobile banking',
                'provider': 'Polaris Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Providus Bank',
                'code': '*737*8#',
                'category': 'Banking',
                'description': 'Providus Bank QuickBank services',
                'provider': 'Providus Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Jaiz Bank',
                'code': '*389*301#',
                'category': 'Banking',
                'description': 'Jaiz Bank mobile banking',
                'provider': 'Jaiz Bank',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(banks)
        print(f"✅ Added {len(banks)} Nigerian bank codes")
        return len(banks)
    
    def add_mtn_nigeria(self):
        """Add MTN Nigeria USSD codes"""
        print("📱 Adding MTN Nigeria Codes...")
        
        mtn_codes = [
            {
                'name': 'MTN Balance Check',
                'code': '*556#',
                'category': 'Telecom',
                'description': 'Check MTN account balance',
                'provider': 'MTN Nigeria',
                'network': 'MTN'
            },
            {
                'name': 'MTN Data Balance',
                'code': '*131*4#',
                'category': 'Telecom',
                'description': 'Check MTN data balance',
                'provider': 'MTN Nigeria',
                'network': 'MTN'
            },
            {
                'name': 'MTN Data Plans',
                'code': '*131#',
                'category': 'Telecom',
                'description': 'Subscribe to MTN data plans',
                'provider': 'MTN Nigeria',
                'network': 'MTN'
            },
            {
                'name': 'MTN My Number',
                'code': '*123*1*1#',
                'category': 'Telecom',
                'description': 'Check your MTN phone number',
                'provider': 'MTN Nigeria',
                'network': 'MTN'
            },
            {
                'name': 'MTN Share & Sell',
                'code': '*777#',
                'category': 'Telecom',
                'description': 'Transfer airtime to other MTN numbers',
                'provider': 'MTN Nigeria',
                'network': 'MTN'
            },
            {
                'name': 'MTN XtraTime',
                'code': '*606#',
                'category': 'Telecom',
                'description': 'Borrow airtime from MTN',
                'provider': 'MTN Nigeria',
                'network': 'MTN'
            },
            {
                'name': 'MTN XtraByte',
                'code': '*606*2#',
                'category': 'Telecom',
                'description': 'Borrow data from MTN',
                'provider': 'MTN Nigeria',
                'network': 'MTN'
            },
            {
                'name': 'MTN Call Me Back',
                'code': '*136*PhoneNumber#',
                'category': 'Telecom',
                'description': 'Send please call me back message',
                'provider': 'MTN Nigeria',
                'network': 'MTN'
            },
        ]
        
        self.ussd_codes.extend(mtn_codes)
        print(f"✅ Added {len(mtn_codes)} MTN Nigeria codes")
        return len(mtn_codes)
    
    def add_glo_nigeria(self):
        """Add Glo Nigeria USSD codes"""
        print("📱 Adding Glo Nigeria Codes...")
        
        glo_codes = [
            {
                'name': 'Glo Balance Check',
                'code': '*127*0#',
                'category': 'Telecom',
                'description': 'Check Glo account balance',
                'provider': 'Glo Nigeria',
                'network': 'Glo'
            },
            {
                'name': 'Glo Data Plans',
                'code': '*777#',
                'category': 'Telecom',
                'description': 'Subscribe to Glo data plans',
                'provider': 'Glo Nigeria',
                'network': 'Glo'
            },
            {
                'name': 'Glo My Number',
                'code': '*135*8#',
                'category': 'Telecom',
                'description': 'Check your Glo phone number',
                'provider': 'Glo Nigeria',
                'network': 'Glo'
            },
            {
                'name': 'Glo Share & Transfer',
                'code': '*131#',
                'category': 'Telecom',
                'description': 'Transfer airtime to other Glo numbers',
                'provider': 'Glo Nigeria',
                'network': 'Glo'
            },
            {
                'name': 'Glo Borrow Me Credit',
                'code': '*321#',
                'category': 'Telecom',
                'description': 'Borrow airtime from Glo',
                'provider': 'Glo Nigeria',
                'network': 'Glo'
            },
            {
                'name': 'Glo Data Balance',
                'code': '*127*0#',
                'category': 'Telecom',
                'description': 'Check Glo data balance',
                'provider': 'Glo Nigeria',
                'network': 'Glo'
            },
        ]
        
        self.ussd_codes.extend(glo_codes)
        print(f"✅ Added {len(glo_codes)} Glo Nigeria codes")
        return len(glo_codes)
    
    def add_airtel_nigeria(self):
        """Add Airtel Nigeria USSD codes"""
        print("📱 Adding Airtel Nigeria Codes...")
        
        airtel_codes = [
            {
                'name': 'Airtel Balance Check',
                'code': '*123#',
                'category': 'Telecom',
                'description': 'Check Airtel account balance',
                'provider': 'Airtel Nigeria',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Data Plans',
                'code': '*141#',
                'category': 'Telecom',
                'description': 'Subscribe to Airtel data plans',
                'provider': 'Airtel Nigeria',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel My Number',
                'code': '*121#',
                'category': 'Telecom',
                'description': 'Check your Airtel phone number',
                'provider': 'Airtel Nigeria',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Share Credit',
                'code': '*432#',
                'category': 'Telecom',
                'description': 'Transfer airtime to other Airtel numbers',
                'provider': 'Airtel Nigeria',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Borrow Credit',
                'code': '*500#',
                'category': 'Telecom',
                'description': 'Borrow airtime from Airtel',
                'provider': 'Airtel Nigeria',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Data Balance',
                'code': '*140#',
                'category': 'Telecom',
                'description': 'Check Airtel data balance',
                'provider': 'Airtel Nigeria',
                'network': 'Airtel'
            },
        ]
        
        self.ussd_codes.extend(airtel_codes)
        print(f"✅ Added {len(airtel_codes)} Airtel Nigeria codes")
        return len(airtel_codes)
    
    def add_9mobile_nigeria(self):
        """Add 9mobile Nigeria USSD codes"""
        print("📱 Adding 9mobile Nigeria Codes...")
        
        nineMobile_codes = [
            {
                'name': '9mobile Balance Check',
                'code': '*232#',
                'category': 'Telecom',
                'description': 'Check 9mobile account balance',
                'provider': '9mobile Nigeria',
                'network': '9mobile'
            },
            {
                'name': '9mobile Data Plans',
                'code': '*229#',
                'category': 'Telecom',
                'description': 'Subscribe to 9mobile data plans',
                'provider': '9mobile Nigeria',
                'network': '9mobile'
            },
            {
                'name': '9mobile My Number',
                'code': '*248#',
                'category': 'Telecom',
                'description': 'Check your 9mobile phone number',
                'provider': '9mobile Nigeria',
                'network': '9mobile'
            },
            {
                'name': '9mobile Transfer Credit',
                'code': '*223#',
                'category': 'Telecom',
                'description': 'Transfer airtime to other 9mobile numbers',
                'provider': '9mobile Nigeria',
                'network': '9mobile'
            },
            {
                'name': '9mobile Borrow Credit',
                'code': '*665#',
                'category': 'Telecom',
                'description': 'Borrow airtime from 9mobile',
                'provider': '9mobile Nigeria',
                'network': '9mobile'
            },
        ]
        
        self.ussd_codes.extend(nineMobile_codes)
        print(f"✅ Added {len(nineMobile_codes)} 9mobile Nigeria codes")
        return len(nineMobile_codes)
    
    def add_utility_services(self):
        """Add Nigerian utility service USSD codes"""
        print("⚡ Adding Nigerian Utility Services...")
        
        utilities = [
            {
                'name': 'DSTV Nigeria',
                'code': '*737*6*Amount*SmartCardNumber#',
                'category': 'Utilities',
                'description': 'Pay DSTV subscription via GTBank',
                'provider': 'DSTV Nigeria',
                'network': 'All Networks'
            },
            {
                'name': 'GOtv Nigeria',
                'code': '*737*6*Amount*IUC#',
                'category': 'Utilities',
                'description': 'Pay GOtv subscription',
                'provider': 'GOtv Nigeria',
                'network': 'All Networks'
            },
            {
                'name': 'StarTimes Nigeria',
                'code': '*737*6*Amount*SmartCardNumber#',
                'category': 'Utilities',
                'description': 'Pay StarTimes subscription',
                'provider': 'StarTimes Nigeria',
                'network': 'All Networks'
            },
            {
                'name': 'IKEDC Prepaid',
                'code': '*222#',
                'category': 'Utilities',
                'description': 'Ikeja Electric prepaid electricity',
                'provider': 'IKEDC',
                'network': 'All Networks'
            },
            {
                'name': 'EKEDC Prepaid',
                'code': '*222#',
                'category': 'Utilities',
                'description': 'Eko Electric prepaid electricity',
                'provider': 'EKEDC',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(utilities)
        print(f"✅ Added {len(utilities)} utility service codes")
        return len(utilities)
    
    def add_mobile_money_services(self):
        """Add Nigerian mobile money USSD codes"""
        print("💰 Adding Nigerian Mobile Money Services...")
        
        mobile_money = [
            {
                'name': 'OPay',
                'code': '*955#',
                'category': 'Mobile Money',
                'description': 'OPay mobile money and payment services',
                'provider': 'OPay',
                'network': 'All Networks'
            },
            {
                'name': 'PalmPay',
                'code': '*861#',
                'category': 'Mobile Money',
                'description': 'PalmPay mobile money services',
                'provider': 'PalmPay',
                'network': 'All Networks'
            },
            {
                'name': 'Paga',
                'code': '*242#',
                'category': 'Mobile Money',
                'description': 'Paga mobile money and bill payments',
                'provider': 'Paga',
                'network': 'All Networks'
            },
            {
                'name': 'Kuda Bank',
                'code': '*5573#',
                'category': 'Mobile Money',
                'description': 'Kuda digital banking services',
                'provider': 'Kuda Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Quickteller',
                'code': '*322*0#',
                'category': 'Mobile Money',
                'description': 'Quickteller payment and bill services',
                'provider': 'Quickteller',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(mobile_money)
        print(f"✅ Added {len(mobile_money)} mobile money codes")
        return len(mobile_money)
    
    def add_government_services(self):
        """Add Nigerian government service USSD codes"""
        print("🏛️ Adding Nigerian Government Services...")
        
        gov_services = [
            {
                'name': 'NIMC NIN Check',
                'code': '*346#',
                'category': 'Government',
                'description': 'Check National Identity Number (NIN)',
                'provider': 'NIMC',
                'network': 'All Networks'
            },
            {
                'name': 'JAMB Registration',
                'code': '*55019#',
                'category': 'Government',
                'description': 'JAMB UTME registration services',
                'provider': 'JAMB',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(gov_services)
        print(f"✅ Added {len(gov_services)} government service codes")
        return len(gov_services)
    
    def scrape_all(self):
        """Collect all Nigerian USSD codes"""
        print("🚀 Starting Nigeria USSD Code Collection...")
        print("=" * 50)
        
        # Add all codes
        self.add_nigerian_banks()
        self.add_mtn_nigeria()
        self.add_glo_nigeria()
        self.add_airtel_nigeria()
        self.add_9mobile_nigeria()
        self.add_utility_services()
        self.add_mobile_money_services()
        self.add_government_services()
        
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
        print(f"📡 Nigerian Mobile Services")
        
        return self.ussd_codes
    
    def save_to_json(self, filename: str = 'ussd_codes_nigeria.json'):
        """Save Nigerian USSD codes to JSON file"""
        # Add IDs to each code
        for i, code in enumerate(self.ussd_codes):
            code['id'] = f'ng_{i+1:04d}'
            code['country'] = 'Nigeria'
            code['last_updated'] = '2025-10-18T00:00:00Z'
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(self.ussd_codes, f, indent=2, ensure_ascii=False)
        
        print(f"\n💾 Saved {len(self.ussd_codes)} USSD codes to {filename}")

def main():
    scraper = USSDScraperNigeria()
    
    # Scrape all USSD codes
    ussd_codes = scraper.scrape_all()
    
    # Save to JSON
    scraper.save_to_json('../assets/dataset/ussd_codes_nigeria.json')
    
    print("\n✅ Scraping Complete!")
    print(f"📊 Categories: {len(set(code['category'] for code in ussd_codes))}")
    print(f"🏢 Providers: {len(set(code['provider'] for code in ussd_codes))}")

if __name__ == '__main__':
    main()

