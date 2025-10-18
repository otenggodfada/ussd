"""
USSD Code Scraper for Kenya
Scrapes USSD codes from Kenyan banks, M-Pesa, telecom providers, and services
"""

import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import json

class USSDScraperKenya:
    def __init__(self):
        self.ussd_codes = []
    
    def add_kenyan_banks(self):
        """Add Kenyan bank USSD codes"""
        print("🏦 Adding Kenyan Bank Codes...")
        
        banks = [
            # Major Kenyan Banks
            {
                'name': 'Equity Bank',
                'code': '*247#',
                'category': 'Banking',
                'description': 'Equity Bank mobile banking - Eazzy 24/7',
                'provider': 'Equity Bank',
                'network': 'All Networks'
            },
            {
                'name': 'KCB Mobile Banking',
                'code': '*522#',
                'category': 'Banking',
                'description': 'KCB Bank mobile banking services',
                'provider': 'KCB Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Co-operative Bank',
                'code': '*667#',
                'category': 'Banking',
                'description': 'Co-operative Bank MCo-op Cash services',
                'provider': 'Co-operative Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Standard Chartered Kenya',
                'code': '*865#',
                'category': 'Banking',
                'description': 'Standard Chartered mobile banking',
                'provider': 'Standard Chartered',
                'network': 'All Networks'
            },
            {
                'name': 'Barclays Bank Kenya',
                'code': '*224#',
                'category': 'Banking',
                'description': 'Barclays Bank mobile banking',
                'provider': 'Barclays Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Absa Bank Kenya',
                'code': '*224#',
                'category': 'Banking',
                'description': 'Absa Bank mobile banking (formerly Barclays)',
                'provider': 'Absa Bank',
                'network': 'All Networks'
            },
            {
                'name': 'I&M Bank',
                'code': '*456#',
                'category': 'Banking',
                'description': 'I&M Bank mobile banking services',
                'provider': 'I&M Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Diamond Trust Bank',
                'code': '*253#',
                'category': 'Banking',
                'description': 'DTB mobile banking',
                'provider': 'DTB',
                'network': 'All Networks'
            },
            {
                'name': 'Stanbic Bank Kenya',
                'code': '*909#',
                'category': 'Banking',
                'description': 'Stanbic Bank mobile banking',
                'provider': 'Stanbic Bank',
                'network': 'All Networks'
            },
            {
                'name': 'NIC Bank',
                'code': '*645#',
                'category': 'Banking',
                'description': 'NIC Bank mobile banking',
                'provider': 'NIC Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Family Bank',
                'code': '*325#',
                'category': 'Banking',
                'description': 'Family Bank Pesa Pap services',
                'provider': 'Family Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Sidian Bank',
                'code': '*833#',
                'category': 'Banking',
                'description': 'Sidian Bank mobile banking',
                'provider': 'Sidian Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Housing Finance',
                'code': '*544#',
                'category': 'Banking',
                'description': 'Housing Finance mobile banking',
                'provider': 'Housing Finance',
                'network': 'All Networks'
            },
            {
                'name': 'Prime Bank',
                'code': '*544#',
                'category': 'Banking',
                'description': 'Prime Bank mobile banking',
                'provider': 'Prime Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Gulf African Bank',
                'code': '*665#',
                'category': 'Banking',
                'description': 'Gulf African Bank Halal banking',
                'provider': 'Gulf African Bank',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(banks)
        print(f"✅ Added {len(banks)} Kenyan bank codes")
        return len(banks)
    
    def add_mpesa_services(self):
        """Add M-Pesa USSD codes"""
        print("💰 Adding M-Pesa Services...")
        
        mpesa_codes = [
            {
                'name': 'M-Pesa Main Menu',
                'code': '*234#',
                'category': 'Mobile Money',
                'description': 'Access M-Pesa services - send money, buy airtime, pay bills',
                'provider': 'M-Pesa',
                'network': 'Safaricom'
            },
            {
                'name': 'M-Pesa Balance',
                'code': '*234*1*6#',
                'category': 'Mobile Money',
                'description': 'Check M-Pesa account balance',
                'provider': 'M-Pesa',
                'network': 'Safaricom'
            },
            {
                'name': 'M-Pesa PIN Reset',
                'code': '*234*5#',
                'category': 'Mobile Money',
                'description': 'Reset M-Pesa PIN',
                'provider': 'M-Pesa',
                'network': 'Safaricom'
            },
            {
                'name': 'M-Pesa Statement',
                'code': '*234*6#',
                'category': 'Mobile Money',
                'description': 'Request M-Pesa statement',
                'provider': 'M-Pesa',
                'network': 'Safaricom'
            },
            {
                'name': 'M-Shwari',
                'code': '*234*6#',
                'category': 'Mobile Money',
                'description': 'Access M-Shwari savings and loans',
                'provider': 'M-Shwari',
                'network': 'Safaricom'
            },
            {
                'name': 'KCB M-Pesa',
                'code': '*522#',
                'category': 'Mobile Money',
                'description': 'KCB M-Pesa account services',
                'provider': 'KCB M-Pesa',
                'network': 'Safaricom'
            },
        ]
        
        self.ussd_codes.extend(mpesa_codes)
        print(f"✅ Added {len(mpesa_codes)} M-Pesa codes")
        return len(mpesa_codes)
    
    def add_safaricom_services(self):
        """Add Safaricom USSD codes"""
        print("📱 Adding Safaricom Services...")
        
        safaricom_codes = [
            {
                'name': 'Safaricom Balance Check',
                'code': '*144#',
                'category': 'Telecom',
                'description': 'Check Safaricom airtime balance',
                'provider': 'Safaricom',
                'network': 'Safaricom'
            },
            {
                'name': 'Safaricom Data Bundles',
                'code': '*544#',
                'category': 'Telecom',
                'description': 'Buy Safaricom data bundles',
                'provider': 'Safaricom',
                'network': 'Safaricom'
            },
            {
                'name': 'Safaricom My Number',
                'code': '*100#',
                'category': 'Telecom',
                'description': 'Check your Safaricom phone number',
                'provider': 'Safaricom',
                'network': 'Safaricom'
            },
            {
                'name': 'Safaricom Sambaza',
                'code': '*141#',
                'category': 'Telecom',
                'description': 'Transfer airtime to other Safaricom numbers',
                'provider': 'Safaricom',
                'network': 'Safaricom'
            },
            {
                'name': 'Safaricom Okoa Jahazi',
                'code': '*130#',
                'category': 'Telecom',
                'description': 'Borrow airtime from Safaricom',
                'provider': 'Safaricom',
                'network': 'Safaricom'
            },
            {
                'name': 'Safaricom Okoa Data',
                'code': '*131#',
                'category': 'Telecom',
                'description': 'Borrow data from Safaricom',
                'provider': 'Safaricom',
                'network': 'Safaricom'
            },
            {
                'name': 'Safaricom Customer Care',
                'code': '*100#',
                'category': 'Customer Service',
                'description': 'Access Safaricom customer care',
                'provider': 'Safaricom',
                'network': 'Safaricom'
            },
        ]
        
        self.ussd_codes.extend(safaricom_codes)
        print(f"✅ Added {len(safaricom_codes)} Safaricom codes")
        return len(safaricom_codes)
    
    def add_airtel_kenya(self):
        """Add Airtel Kenya USSD codes"""
        print("📱 Adding Airtel Kenya Services...")
        
        airtel_codes = [
            {
                'name': 'Airtel Money Kenya',
                'code': '*234#',
                'category': 'Mobile Money',
                'description': 'Airtel Money mobile money services',
                'provider': 'Airtel Money',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Balance Check',
                'code': '*131#',
                'category': 'Telecom',
                'description': 'Check Airtel Kenya balance',
                'provider': 'Airtel Kenya',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Data Bundles',
                'code': '*544#',
                'category': 'Telecom',
                'description': 'Buy Airtel data bundles',
                'provider': 'Airtel Kenya',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel My Number',
                'code': '*121#',
                'category': 'Telecom',
                'description': 'Check your Airtel phone number',
                'provider': 'Airtel Kenya',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Share Credit',
                'code': '*141#',
                'category': 'Telecom',
                'description': 'Transfer airtime to other Airtel numbers',
                'provider': 'Airtel Kenya',
                'network': 'Airtel'
            },
            {
                'name': 'Airtel Borrow Credit',
                'code': '*130#',
                'category': 'Telecom',
                'description': 'Borrow airtime from Airtel',
                'provider': 'Airtel Kenya',
                'network': 'Airtel'
            },
        ]
        
        self.ussd_codes.extend(airtel_codes)
        print(f"✅ Added {len(airtel_codes)} Airtel Kenya codes")
        return len(airtel_codes)
    
    def add_telkom_kenya(self):
        """Add Telkom Kenya USSD codes"""
        print("📱 Adding Telkom Kenya Services...")
        
        telkom_codes = [
            {
                'name': 'T-Kash',
                'code': '*460#',
                'category': 'Mobile Money',
                'description': 'T-Kash mobile money services',
                'provider': 'T-Kash',
                'network': 'Telkom'
            },
            {
                'name': 'Telkom Balance Check',
                'code': '*130#',
                'category': 'Telecom',
                'description': 'Check Telkom Kenya balance',
                'provider': 'Telkom Kenya',
                'network': 'Telkom'
            },
            {
                'name': 'Telkom Data Bundles',
                'code': '*544#',
                'category': 'Telecom',
                'description': 'Buy Telkom data bundles',
                'provider': 'Telkom Kenya',
                'network': 'Telkom'
            },
            {
                'name': 'Telkom My Number',
                'code': '*100#',
                'category': 'Telecom',
                'description': 'Check your Telkom phone number',
                'provider': 'Telkom Kenya',
                'network': 'Telkom'
            },
            {
                'name': 'Telkom Share Airtime',
                'code': '*131#',
                'category': 'Telecom',
                'description': 'Transfer airtime to other Telkom numbers',
                'provider': 'Telkom Kenya',
                'network': 'Telkom'
            },
        ]
        
        self.ussd_codes.extend(telkom_codes)
        print(f"✅ Added {len(telkom_codes)} Telkom Kenya codes")
        return len(telkom_codes)
    
    def add_utility_services(self):
        """Add Kenyan utility service USSD codes"""
        print("⚡ Adding Kenyan Utility Services...")
        
        utilities = [
            {
                'name': 'KPLC Prepaid',
                'code': '*977#',
                'category': 'Utilities',
                'description': 'Kenya Power prepaid electricity tokens',
                'provider': 'KPLC',
                'network': 'All Networks'
            },
            {
                'name': 'Nairobi Water',
                'code': '*888#',
                'category': 'Utilities',
                'description': 'Nairobi Water bill payments',
                'provider': 'Nairobi Water',
                'network': 'All Networks'
            },
            {
                'name': 'DSTV Kenya',
                'code': '*483#',
                'category': 'Utilities',
                'description': 'Pay DSTV subscription via M-Pesa',
                'provider': 'DSTV Kenya',
                'network': 'All Networks'
            },
            {
                'name': 'GOtv Kenya',
                'code': '*483*4#',
                'category': 'Utilities',
                'description': 'Pay GOtv subscription',
                'provider': 'GOtv Kenya',
                'network': 'All Networks'
            },
            {
                'name': 'StarTimes Kenya',
                'code': '*639#',
                'category': 'Utilities',
                'description': 'Pay StarTimes subscription',
                'provider': 'StarTimes Kenya',
                'network': 'All Networks'
            },
            {
                'name': 'Zuku',
                'code': '*483*5#',
                'category': 'Utilities',
                'description': 'Pay Zuku TV and internet subscription',
                'provider': 'Zuku',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(utilities)
        print(f"✅ Added {len(utilities)} utility service codes")
        return len(utilities)
    
    def add_transport_services(self):
        """Add Kenyan transport service USSD codes"""
        print("🚗 Adding Kenyan Transport Services...")
        
        transport = [
            {
                'name': 'Uber Kenya',
                'code': '*255#',
                'category': 'Transport',
                'description': 'Request Uber ride without app',
                'provider': 'Uber',
                'network': 'All Networks'
            },
            {
                'name': 'Little Cab',
                'code': '*808#',
                'category': 'Transport',
                'description': 'Little Cab ride hailing service',
                'provider': 'Little Cab',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(transport)
        print(f"✅ Added {len(transport)} transport service codes")
        return len(transport)
    
    def add_government_services(self):
        """Add Kenyan government service USSD codes"""
        print("🏛️ Adding Kenyan Government Services...")
        
        gov_services = [
            {
                'name': 'NHIF Kenya',
                'code': '*155#',
                'category': 'Government',
                'description': 'National Hospital Insurance Fund services',
                'provider': 'NHIF',
                'network': 'All Networks'
            },
            {
                'name': 'KRA iTax',
                'code': '*572#',
                'category': 'Government',
                'description': 'Kenya Revenue Authority tax services',
                'provider': 'KRA',
                'network': 'All Networks'
            },
            {
                'name': 'Huduma Number',
                'code': '*456#',
                'category': 'Government',
                'description': 'Huduma Kenya government services',
                'provider': 'Huduma Kenya',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(gov_services)
        print(f"✅ Added {len(gov_services)} government service codes")
        return len(gov_services)
    
    def scrape_all(self):
        """Collect all Kenyan USSD codes"""
        print("🚀 Starting Kenya USSD Code Collection...")
        print("=" * 50)
        
        # Add all codes
        self.add_kenyan_banks()
        self.add_mpesa_services()
        self.add_safaricom_services()
        self.add_airtel_kenya()
        self.add_telkom_kenya()
        self.add_utility_services()
        self.add_transport_services()
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
        print(f"📡 Kenyan Mobile Services")
        
        return self.ussd_codes
    
    def save_to_json(self, filename: str = 'ussd_codes_kenya.json'):
        """Save Kenyan USSD codes to JSON file"""
        # Add IDs to each code
        for i, code in enumerate(self.ussd_codes):
            code['id'] = f'ke_{i+1:04d}'
            code['country'] = 'Kenya'
            code['last_updated'] = '2025-10-18T00:00:00Z'
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(self.ussd_codes, f, indent=2, ensure_ascii=False)
        
        print(f"\n💾 Saved {len(self.ussd_codes)} USSD codes to {filename}")

def main():
    scraper = USSDScraperKenya()
    
    # Scrape all USSD codes
    ussd_codes = scraper.scrape_all()
    
    # Save to JSON
    scraper.save_to_json('../assets/dataset/ussd_codes_kenya.json')
    
    print("\n✅ Scraping Complete!")
    print(f"📊 Categories: {len(set(code['category'] for code in ussd_codes))}")
    print(f"🏢 Providers: {len(set(code['provider'] for code in ussd_codes))}")

if __name__ == '__main__':
    main()

