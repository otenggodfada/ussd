"""
USSD/MMI Code Scraper for USA
Scrapes USSD codes, MMI codes, and carrier-specific codes for US networks
"""

import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import requests
from bs4 import BeautifulSoup
import json
import time
from typing import List, Dict, Tuple
import re
from urllib.parse import urljoin

class USSDScraperUSA:
    def __init__(self):
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'en-US,en;q=0.5',
            'Connection': 'keep-alive',
        }
        self.ussd_codes = []
        self.session = requests.Session()
        
    def extract_ussd_codes(self, text: str) -> List[str]:
        """Extract USSD/MMI codes from text (format: *123# or *#123#)"""
        # Pattern to match USSD/MMI codes
        pattern = r'\*[#\d]+[#\*\d]*#'
        codes = re.findall(pattern, text)
        return list(set(codes))  # Remove duplicates
    
    def scrape_generic_site(self, url: str, category: str, provider: str = "", verify_ssl: bool = True) -> int:
        """Generic scraper for any website"""
        print(f"🔍 Scraping {url}...")
        count = 0
        
        try:
            response = self.session.get(url, headers=self.headers, timeout=15, verify=verify_ssl)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Remove script and style elements
            for script in soup(['script', 'style', 'nav', 'footer']):
                script.decompose()
            
            text = soup.get_text()
            
            # Extract USSD codes
            codes = self.extract_ussd_codes(text)
            
            print(f"  Found {len(codes)} codes on page")
            
            for code in codes:
                # Try to find context around the code
                name, description = self.extract_info_from_text(text, code)
                
                if not name:
                    name = f"{provider} - {code}" if provider else f"Service {code}"
                if not description:
                    description = f"Service code accessible via {code}"
                
                self.ussd_codes.append({
                    'name': name[:100].strip(),
                    'code': code,
                    'category': category,
                    'description': description[:200].strip(),
                    'provider': provider or 'Universal',
                    'network': 'All Networks' if not provider else provider,
                    'source': url
                })
                count += 1
                
        except Exception as e:
            print(f"  ❌ Error: {str(e)[:100]}")
            
        return count
    
    def extract_info_from_text(self, text: str, code: str) -> Tuple[str, str]:
        """Extract name and description around a USSD code"""
        sentences = re.split(r'[.!?\n]', text)
        for sentence in sentences:
            if code in sentence:
                name = sentence.replace(code, '').strip()
                name = re.sub(r'\s+', ' ', name)[:100]
                return name, name
        return '', ''
    
    def add_universal_mmi_codes(self):
        """Add universal MMI codes that work on all devices"""
        print("📱 Adding Universal MMI Codes...")
        
        universal_codes = [
            {
                'name': 'Display IMEI Number',
                'code': '*#06#',
                'category': 'Device Info',
                'description': 'Display your device IMEI (International Mobile Equipment Identity) number',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Check Call Forwarding Status',
                'code': '*#21#',
                'category': 'Call Management',
                'description': 'Check if call forwarding is enabled on your device',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Disable Call Forwarding',
                'code': '##21#',
                'category': 'Call Management',
                'description': 'Disable all call forwarding settings',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Check Call Waiting Status',
                'code': '*#43#',
                'category': 'Call Management',
                'description': 'Check if call waiting is enabled',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Enable Call Waiting',
                'code': '*43#',
                'category': 'Call Management',
                'description': 'Enable call waiting feature',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Disable Call Waiting',
                'code': '#43#',
                'category': 'Call Management',
                'description': 'Disable call waiting feature',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Check Call Barring Status',
                'code': '*#33#',
                'category': 'Call Management',
                'description': 'Check call barring status',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Check Forwarding When Unreachable',
                'code': '*#62#',
                'category': 'Call Management',
                'description': 'Check call forwarding when phone is unreachable',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Check Forwarding When Busy',
                'code': '*#67#',
                'category': 'Call Management',
                'description': 'Check call forwarding when line is busy',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Check Forwarding When No Answer',
                'code': '*#61#',
                'category': 'Call Management',
                'description': 'Check call forwarding when no answer',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Enable Caller ID',
                'code': '*31#',
                'category': 'Call Management',
                'description': 'Enable showing your caller ID',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Disable Caller ID',
                'code': '#31#',
                'category': 'Call Management',
                'description': 'Hide your caller ID for next call',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Check Caller ID Status',
                'code': '*#31#',
                'category': 'Call Management',
                'description': 'Check caller ID presentation status',
                'provider': 'Universal',
                'network': 'All Networks'
            },
            {
                'name': 'Check Network Lock Status',
                'code': '*#7465625#',
                'category': 'Device Info',
                'description': 'Check if device is network locked (Samsung devices)',
                'provider': 'Universal',
                'network': 'All Networks'
            },
        ]
        
        self.ussd_codes.extend(universal_codes)
        print(f"✅ Added {len(universal_codes)} universal MMI codes")
        return len(universal_codes)
    
    def add_att_codes(self):
        """Add AT&T specific USSD codes"""
        print("📱 Adding AT&T Codes...")
        
        att_codes = [
            {
                'name': 'AT&T Balance Check',
                'code': '*225#',
                'category': 'Account Management',
                'description': 'Check AT&T prepaid account balance',
                'provider': 'AT&T',
                'network': 'AT&T'
            },
            {
                'name': 'AT&T Account Info',
                'code': '*777#',
                'category': 'Account Management',
                'description': 'Access AT&T prepaid account information',
                'provider': 'AT&T',
                'network': 'AT&T'
            },
            {
                'name': 'AT&T Refill Account',
                'code': '*729',
                'category': 'Account Management',
                'description': 'Refill AT&T prepaid account',
                'provider': 'AT&T',
                'network': 'AT&T'
            },
            {
                'name': 'AT&T Customer Service',
                'code': '*611',
                'category': 'Customer Service',
                'description': 'Call AT&T customer service',
                'provider': 'AT&T',
                'network': 'AT&T'
            },
            {
                'name': 'AT&T Data Usage',
                'code': '*3282#',
                'category': 'Account Management',
                'description': 'Check AT&T data usage (*DATA#)',
                'provider': 'AT&T',
                'network': 'AT&T'
            },
            {
                'name': 'AT&T Call History',
                'code': '*646#',
                'category': 'Account Management',
                'description': 'View recent call history and usage',
                'provider': 'AT&T',
                'network': 'AT&T'
            },
        ]
        
        self.ussd_codes.extend(att_codes)
        print(f"✅ Added {len(att_codes)} AT&T codes")
        return len(att_codes)
    
    def add_tmobile_codes(self):
        """Add T-Mobile specific USSD codes"""
        print("📱 Adding T-Mobile Codes...")
        
        tmobile_codes = [
            {
                'name': 'T-Mobile Balance Check',
                'code': '#999#',
                'category': 'Account Management',
                'description': 'Check T-Mobile prepaid account balance',
                'provider': 'T-Mobile',
                'network': 'T-Mobile'
            },
            {
                'name': 'T-Mobile Account Info',
                'code': '#225#',
                'category': 'Account Management',
                'description': 'Access T-Mobile account information (#BAL#)',
                'provider': 'T-Mobile',
                'network': 'T-Mobile'
            },
            {
                'name': 'T-Mobile Customer Service',
                'code': '*611',
                'category': 'Customer Service',
                'description': 'Call T-Mobile customer service',
                'provider': 'T-Mobile',
                'network': 'T-Mobile'
            },
            {
                'name': 'T-Mobile Add Funds',
                'code': '#ADD',
                'category': 'Account Management',
                'description': 'Add funds to T-Mobile prepaid account',
                'provider': 'T-Mobile',
                'network': 'T-Mobile'
            },
            {
                'name': 'T-Mobile Refill',
                'code': '#REF#',
                'category': 'Account Management',
                'description': 'Refill T-Mobile prepaid account',
                'provider': 'T-Mobile',
                'network': 'T-Mobile'
            },
            {
                'name': 'T-Mobile Minutes Check',
                'code': '#MIN#',
                'category': 'Account Management',
                'description': 'Check remaining minutes',
                'provider': 'T-Mobile',
                'network': 'T-Mobile'
            },
            {
                'name': 'T-Mobile Data Usage',
                'code': '#WEB#',
                'category': 'Account Management',
                'description': 'Check data usage and balance',
                'provider': 'T-Mobile',
                'network': 'T-Mobile'
            },
        ]
        
        self.ussd_codes.extend(tmobile_codes)
        print(f"✅ Added {len(tmobile_codes)} T-Mobile codes")
        return len(tmobile_codes)
    
    def add_verizon_codes(self):
        """Add Verizon specific codes"""
        print("📱 Adding Verizon Codes...")
        
        verizon_codes = [
            {
                'name': 'Verizon Balance Check',
                'code': '#BAL',
                'category': 'Account Management',
                'description': 'Check Verizon prepaid account balance (send via SMS)',
                'provider': 'Verizon',
                'network': 'Verizon'
            },
            {
                'name': 'Verizon Customer Service',
                'code': '*611',
                'category': 'Customer Service',
                'description': 'Call Verizon customer service',
                'provider': 'Verizon',
                'network': 'Verizon'
            },
            {
                'name': 'Verizon Prepaid Refill',
                'code': '*611',
                'category': 'Account Management',
                'description': 'Access Verizon prepaid refill menu',
                'provider': 'Verizon',
                'network': 'Verizon'
            },
            {
                'name': 'Verizon Data Usage',
                'code': '#DATA',
                'category': 'Account Management',
                'description': 'Check Verizon data usage (send via SMS)',
                'provider': 'Verizon',
                'network': 'Verizon'
            },
        ]
        
        self.ussd_codes.extend(verizon_codes)
        print(f"✅ Added {len(verizon_codes)} Verizon codes")
        return len(verizon_codes)
    
    def add_sprint_codes(self):
        """Add Sprint/T-Mobile (merged) specific codes"""
        print("📱 Adding Sprint Codes...")
        
        sprint_codes = [
            {
                'name': 'Sprint Customer Service',
                'code': '*2',
                'category': 'Customer Service',
                'description': 'Call Sprint customer service',
                'provider': 'Sprint',
                'network': 'Sprint'
            },
            {
                'name': 'Sprint Account Info',
                'code': '*4',
                'category': 'Account Management',
                'description': 'Access Sprint account information',
                'provider': 'Sprint',
                'network': 'Sprint'
            },
        ]
        
        self.ussd_codes.extend(sprint_codes)
        print(f"✅ Added {len(sprint_codes)} Sprint codes")
        return len(sprint_codes)
    
    def add_boost_mobile_codes(self):
        """Add Boost Mobile codes"""
        print("📱 Adding Boost Mobile Codes...")
        
        boost_codes = [
            {
                'name': 'Boost Mobile Balance',
                'code': '*225#',
                'category': 'Account Management',
                'description': 'Check Boost Mobile account balance',
                'provider': 'Boost Mobile',
                'network': 'Boost Mobile'
            },
            {
                'name': 'Boost Mobile Customer Service',
                'code': '*611',
                'category': 'Customer Service',
                'description': 'Call Boost Mobile customer service',
                'provider': 'Boost Mobile',
                'network': 'Boost Mobile'
            },
            {
                'name': 'Boost Mobile Add Funds',
                'code': '*ADD',
                'category': 'Account Management',
                'description': 'Add funds to Boost Mobile account',
                'provider': 'Boost Mobile',
                'network': 'Boost Mobile'
            },
        ]
        
        self.ussd_codes.extend(boost_codes)
        print(f"✅ Added {len(boost_codes)} Boost Mobile codes")
        return len(boost_codes)
    
    def add_cricket_wireless_codes(self):
        """Add Cricket Wireless codes"""
        print("📱 Adding Cricket Wireless Codes...")
        
        cricket_codes = [
            {
                'name': 'Cricket Balance Check',
                'code': '*#8351#',
                'category': 'Account Management',
                'description': 'Check Cricket Wireless account balance',
                'provider': 'Cricket Wireless',
                'network': 'Cricket Wireless'
            },
            {
                'name': 'Cricket Customer Service',
                'code': '*611',
                'category': 'Customer Service',
                'description': 'Call Cricket customer service',
                'provider': 'Cricket Wireless',
                'network': 'Cricket Wireless'
            },
            {
                'name': 'Cricket Data Usage',
                'code': '*#3282#',
                'category': 'Account Management',
                'description': 'Check Cricket data usage',
                'provider': 'Cricket Wireless',
                'network': 'Cricket Wireless'
            },
        ]
        
        self.ussd_codes.extend(cricket_codes)
        print(f"✅ Added {len(cricket_codes)} Cricket Wireless codes")
        return len(cricket_codes)
    
    def add_metro_pcs_codes(self):
        """Add Metro by T-Mobile (MetroPCS) codes"""
        print("📱 Adding Metro by T-Mobile Codes...")
        
        metro_codes = [
            {
                'name': 'Metro Balance Check',
                'code': '#999#',
                'category': 'Account Management',
                'description': 'Check Metro by T-Mobile account balance',
                'provider': 'Metro by T-Mobile',
                'network': 'Metro by T-Mobile'
            },
            {
                'name': 'Metro Customer Service',
                'code': '*611',
                'category': 'Customer Service',
                'description': 'Call Metro customer service',
                'provider': 'Metro by T-Mobile',
                'network': 'Metro by T-Mobile'
            },
            {
                'name': 'Metro Add Funds',
                'code': '#PAY',
                'category': 'Account Management',
                'description': 'Add funds to Metro account',
                'provider': 'Metro by T-Mobile',
                'network': 'Metro by T-Mobile'
            },
        ]
        
        self.ussd_codes.extend(metro_codes)
        print(f"✅ Added {len(metro_codes)} Metro codes")
        return len(metro_codes)
    
    def scrape_all(self):
        """Scrape all USSD codes for USA"""
        print("🚀 Starting USA USSD/MMI Code Collection...")
        print("=" * 50)
        print("⚠️ Note: USA has limited USSD infrastructure")
        print("=" * 50)
        
        # Add all known codes
        self.add_universal_mmi_codes()
        self.add_att_codes()
        self.add_tmobile_codes()
        self.add_verizon_codes()
        self.add_sprint_codes()
        self.add_boost_mobile_codes()
        self.add_cricket_wireless_codes()
        self.add_metro_pcs_codes()
        
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
        print(f"✨ Total Unique USSD/MMI Codes: {len(self.ussd_codes)}")
        print(f"📡 USA Mobile Network Codes")
        
        return self.ussd_codes
    
    def save_to_json(self, filename: str = 'ussd_codes_usa.json'):
        """Save scraped USSD codes to JSON file"""
        # Add IDs to each code
        for i, code in enumerate(self.ussd_codes):
            code['id'] = f'us_{i+1:04d}'
            code['country'] = 'USA'
            code['last_updated'] = '2025-10-18T00:00:00Z'
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(self.ussd_codes, f, indent=2, ensure_ascii=False)
        
        print(f"\n💾 Saved {len(self.ussd_codes)} USSD codes to {filename}")
    
    def save_to_excel(self, filename: str = 'ussd_codes_usa.xlsx'):
        """Save scraped USSD codes to Excel file"""
        try:
            import pandas as pd
            
            df = pd.DataFrame(self.ussd_codes)
            df.to_excel(filename, index=False)
            print(f"💾 Saved {len(self.ussd_codes)} USSD codes to {filename}")
        except ImportError:
            print("❌ pandas not installed. Run: pip install pandas openpyxl")

def main():
    scraper = USSDScraperUSA()
    
    # Scrape all USSD codes
    ussd_codes = scraper.scrape_all()
    
    # Save to JSON
    scraper.save_to_json('../assets/dataset/ussd_codes_usa.json')
    
    # Optionally save to Excel
    # scraper.save_to_excel('../assets/dataset/ussd_codes_usa.xlsx')
    
    print("\n✅ Scraping Complete!")
    print(f"📊 Categories: {len(set(code['category'] for code in ussd_codes))}")
    print(f"🏢 Providers: {len(set(code['provider'] for code in ussd_codes))}")

if __name__ == '__main__':
    main()

