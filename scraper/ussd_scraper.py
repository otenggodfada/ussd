"""
USSD Code Scraper for Ghana
Scrapes USSD codes from various live websites including banks, telecom providers, and services
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

class USSDScraper:
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
        """Extract USSD codes from text (format: *123# or *123*1#)"""
        # Pattern to match USSD codes
        pattern = r'\*\d{2,5}(?:\*\d+)*#'
        codes = re.findall(pattern, text)
        return list(set(codes))  # Remove duplicates
    
    def extract_info_from_text(self, text: str, code: str) -> Tuple[str, str]:
        """Extract name and description around a USSD code"""
        # Find sentences containing the code
        sentences = re.split(r'[.!?\n]', text)
        for sentence in sentences:
            if code in sentence:
                # Clean and return as name
                name = sentence.replace(code, '').strip()
                name = re.sub(r'\s+', ' ', name)[:100]
                return name, name
        return '', ''
    
    def fetch_url(self, url: str, timeout: int = 10) -> str:
        """Fetch content from URL with error handling"""
        try:
            response = self.session.get(url, headers=self.headers, timeout=timeout)
            response.raise_for_status()
            return response.text
        except Exception as e:
            print(f"❌ Error fetching {url}: {e}")
            return ""
    
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
                
                # Try to detect provider from text near the code
                if not provider:
                    provider = self.detect_provider(text, code)
                
                if not name:
                    name = f"{provider} - {code}" if provider else f"Service {code}"
                if not description:
                    description = f"USSD service accessible via {code}"
                
                self.ussd_codes.append({
                    'name': name[:100].strip(),
                    'code': code,
                    'category': category,
                    'description': description[:200].strip(),
                    'provider': provider or 'Ghana Service',
                    'network': 'All Networks',
                    'source': url
                })
                count += 1
                
        except Exception as e:
            print(f"  ❌ Error: {str(e)[:100]}")
            
        return count
    
    def detect_provider(self, text: str, code: str) -> str:
        """Try to detect the provider name from text around the code"""
        providers = ['MTN', 'Vodafone', 'AirtelTigo', 'GCB', 'Absa', 'Ecobank', 
                    'Fidelity', 'Stanbic', 'Zenith', 'Access', 'CalBank', 'ECG',
                    'NHIS', 'SSNIT', 'Ghana Water', 'DSTV', 'GoTV']
        
        # Find text around the code
        code_index = text.find(code)
        if code_index != -1:
            nearby_text = text[max(0, code_index-100):code_index+100].lower()
            for provider in providers:
                if provider.lower() in nearby_text:
                    return provider
        return ''
    
    def scrape_mtn_ghana(self):
        """Scrape MTN Ghana related sites"""
        print("📱 Scraping MTN Ghana sources...")
        count = 0
        
        urls = [
            'https://www.mtn.com.gh/personal/mobile-money/',
            'https://www.mtn.com.gh/personal/explore-products/',
            'https://www.mtn.com.gh',
        ]
        
        for url in urls:
            try:
                count += self.scrape_generic_site(url, 'Mobile Money', 'MTN Ghana', verify_ssl=False)
                time.sleep(1)
            except:
                continue
        
        return count
    
    def scrape_vodafone_ghana(self):
        """Scrape Vodafone Ghana website"""
        print("📱 Scraping Vodafone Ghana...")
        
        urls = [
            'https://vodafone.com.gh/personal/services/vodafone-cash',
        ]
        
        count = 0
        for url in urls:
            count += self.scrape_generic_site(url, 'Mobile Money', 'Vodafone Ghana')
        
        return count
    
    def scrape_public_ussd_directories(self):
        """Scrape public USSD code directories and blogs"""
        print("📚 Scraping Public USSD Directories & Blogs...")
        count = 0
        
        # Public websites and blogs that list Ghana USSD codes
        sites = [
            ('https://www.ghanaweb.com', 'Various'),
            ('https://citinewsroom.com', 'Various'),
            ('https://www.myjoyonline.com', 'Various'),
            ('https://www.graphic.com.gh', 'Various'),
            ('https://www.modernghana.com', 'Various'),
            ('https://www.peacefmonline.com', 'Various'),
            ('https://www.ghanacelebrities.com', 'Various'),
            ('https://yen.com.gh', 'Various'),
            ('https://www.pulse.com.gh', 'Various'),
        ]
        
        for url, category in sites:
            try:
                # Try with and without SSL verification
                result = self.scrape_generic_site(url, category, verify_ssl=False)
                count += result
                if result > 0:
                    print(f"  ✅ Found codes on {url}")
                time.sleep(1)
            except:
                continue
                
        return count
    
    def scrape_search_results(self, query: str, category: str) -> int:
        """Scrape from search results (you can adapt this for specific sites)"""
        print(f"🔍 Searching for: {query}")
        
        # This is a placeholder - you could integrate with search APIs
        # or scrape specific Ghana news/info sites
        return 0
    
    def scrape_ghana_banks(self):
        """Scrape USSD codes from Ghana bank websites and sources"""
        print("🏦 Scraping Ghana Banks...")
        count = 0
        
        # Bank websites to scrape
        bank_urls = {
            'https://www.gcb.com.gh': ('GCB Bank', 'Banking'),
            'https://www.absa.com.gh': ('Absa Bank Ghana', 'Banking'),
            'https://www.ecobank.com/gh': ('Ecobank Ghana', 'Banking'),
            'https://www.fidelitybank.com.gh': ('Fidelity Bank', 'Banking'),
            'https://www.stanbicbank.com.gh': ('Stanbic Bank', 'Banking'),
            'https://www.zenithbank.com.gh': ('Zenith Bank', 'Banking'),
            'https://www.sc.com/gh': ('Standard Chartered', 'Banking'),
            'https://www.gtbank.com.gh': ('GTBank Ghana', 'Banking'),
            'https://www.ubaghana.com': ('UBA Ghana', 'Banking'),
            'https://www.firstbankghana.com': ('FirstBank Ghana', 'Banking'),
        }
        
        for url, (provider, category) in bank_urls.items():
            try:
                result = self.scrape_generic_site(url, category, provider, verify_ssl=False)
                count += result
                if result > 0:
                    print(f"  ✅ Extracted codes from {provider}")
                time.sleep(1)
            except Exception as e:
                continue
        
        # Add some known codes as fallback if scraping fails
        if count == 0:
            print("⚠️ No codes scraped, adding known codes...")
            fallback_banks = [
            {
                'name': 'MTN Mobile Money',
                'code': '*170#',
                'category': 'Mobile Money',
                'description': 'MTN Mobile Money services',
                'provider': 'MTN Ghana',
                'network': 'MTN'
            },
            {
                'name': 'Vodafone Cash',
                'code': '*110#',
                'category': 'Mobile Money',
                'description': 'Vodafone Cash services',
                'provider': 'Vodafone Ghana',
                'network': 'Vodafone'
            },
            {
                'name': 'AirtelTigo Money',
                'code': '*110#',
                'category': 'Mobile Money',
                'description': 'AirtelTigo Money services',
                'provider': 'AirtelTigo Ghana',
                'network': 'AirtelTigo'
            },
            {
                'name': 'GCB Bank',
                'code': '*422#',
                'category': 'Banking',
                'description': 'GCB Bank mobile banking services',
                'provider': 'GCB Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Absa Bank Ghana',
                'code': '*920#',
                'category': 'Banking',
                'description': 'Absa mobile banking',
                'provider': 'Absa Bank Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'Ecobank Ghana',
                'code': '*770#',
                'category': 'Banking',
                'description': 'Ecobank mobile banking services',
                'provider': 'Ecobank Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'Fidelity Bank Ghana',
                'code': '*776#',
                'category': 'Banking',
                'description': 'Fidelity mobile banking',
                'provider': 'Fidelity Bank Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'Stanbic Bank Ghana',
                'code': '*909#',
                'category': 'Banking',
                'description': 'Stanbic mobile banking',
                'provider': 'Stanbic Bank Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'CalBank',
                'code': '*771#',
                'category': 'Banking',
                'description': 'CalBank mobile services',
                'provider': 'CalBank PLC',
                'network': 'All Networks'
            },
            {
                'name': 'Standard Chartered Bank',
                'code': '*774#',
                'category': 'Banking',
                'description': 'SC Mobile banking',
                'provider': 'Standard Chartered Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'Zenith Bank Ghana',
                'code': '*966#',
                'category': 'Banking',
                'description': 'Zenith mobile banking',
                'provider': 'Zenith Bank Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'Access Bank Ghana',
                'code': '*901#',
                'category': 'Banking',
                'description': 'Access Bank mobile banking',
                'provider': 'Access Bank Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'First Atlantic Bank',
                'code': '*442#',
                'category': 'Banking',
                'description': 'FAB mobile banking',
                'provider': 'First Atlantic Bank',
                'network': 'All Networks'
            },
            {
                'name': 'Guaranty Trust Bank',
                'code': '*737#',
                'category': 'Banking',
                'description': 'GTBank mobile banking',
                'provider': 'GTBank Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'UBA Ghana',
                'code': '*919#',
                'category': 'Banking',
                'description': 'UBA mobile banking',
                'provider': 'UBA Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'FirstBank Ghana',
                'code': '*894#',
                'category': 'Banking',
                'description': 'FirstBank mobile banking',
                'provider': 'FirstBank Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'Prudential Bank',
                'code': '*778#',
                'category': 'Banking',
                'description': 'Prudential mobile banking',
                'provider': 'Prudential Bank Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'Agricultural Development Bank',
                'code': '*767#',
                'category': 'Banking',
                'description': 'ADB mobile banking',
                'provider': 'ADB Ghana',
                'network': 'All Networks'
            }
            ]
            self.ussd_codes.extend(fallback_banks)
            count = len(fallback_banks)
        
        print(f"✅ Added {count} bank USSD codes")
        return count
    
    def scrape_telecom_services(self):
        """Scrape telecom service USSD codes from provider websites"""
        print("📱 Scraping Telecom Services...")
        count = 0
        
        # Try scraping from actual websites
        count += self.scrape_mtn_ghana()
        time.sleep(2)
        count += self.scrape_vodafone_ghana()
        time.sleep(2)
        
        # Fallback known codes if scraping doesn't work
        if count == 0:
            print("⚠️ Using fallback telecom codes...")
            telecom = [
            # MTN Services
            {
                'name': 'MTN Balance Check',
                'code': '*124#',
                'category': 'Telecom',
                'description': 'Check MTN airtime balance',
                'provider': 'MTN Ghana',
                'network': 'MTN'
            },
            {
                'name': 'MTN Data Bundle',
                'code': '*138#',
                'category': 'Telecom',
                'description': 'Buy MTN data bundles',
                'provider': 'MTN Ghana',
                'network': 'MTN'
            },
            {
                'name': 'MTN My Number',
                'code': '*156#',
                'category': 'Telecom',
                'description': 'Check your MTN number',
                'provider': 'MTN Ghana',
                'network': 'MTN'
            },
            {
                'name': 'MTN Share',
                'code': '*198#',
                'category': 'Telecom',
                'description': 'Share credit on MTN',
                'provider': 'MTN Ghana',
                'network': 'MTN'
            },
            {
                'name': 'MTN Borrow Credit',
                'code': '*506#',
                'category': 'Telecom',
                'description': 'Borrow airtime from MTN',
                'provider': 'MTN Ghana',
                'network': 'MTN'
            },
            # Vodafone Services
            {
                'name': 'Vodafone Balance Check',
                'code': '*130#',
                'category': 'Telecom',
                'description': 'Check Vodafone balance',
                'provider': 'Vodafone Ghana',
                'network': 'Vodafone'
            },
            {
                'name': 'Vodafone Data Bundle',
                'code': '*136#',
                'category': 'Telecom',
                'description': 'Buy Vodafone data',
                'provider': 'Vodafone Ghana',
                'network': 'Vodafone'
            },
            {
                'name': 'Vodafone My Number',
                'code': '*134#',
                'category': 'Telecom',
                'description': 'Check your Vodafone number',
                'provider': 'Vodafone Ghana',
                'network': 'Vodafone'
            },
            {
                'name': 'Vodafone Borrow Credit',
                'code': '*139*9#',
                'category': 'Telecom',
                'description': 'Borrow airtime from Vodafone',
                'provider': 'Vodafone Ghana',
                'network': 'Vodafone'
            },
            # AirtelTigo Services
            {
                'name': 'AirtelTigo Balance Check',
                'code': '*132#',
                'category': 'Telecom',
                'description': 'Check AirtelTigo balance',
                'provider': 'AirtelTigo Ghana',
                'network': 'AirtelTigo'
            },
            {
                'name': 'AirtelTigo Data Bundle',
                'code': '*123#',
                'category': 'Telecom',
                'description': 'Buy AirtelTigo data',
                'provider': 'AirtelTigo Ghana',
                'network': 'AirtelTigo'
            },
            {
                'name': 'AirtelTigo My Number',
                'code': '*131*10#',
                'category': 'Telecom',
                'description': 'Check your AirtelTigo number',
                'provider': 'AirtelTigo Ghana',
                'network': 'AirtelTigo'
            },
            {
                'name': 'AirtelTigo Borrow Credit',
                'code': '*144#',
                'category': 'Telecom',
                'description': 'Borrow airtime from AirtelTigo',
                'provider': 'AirtelTigo Ghana',
                'network': 'AirtelTigo'
            }
            ]
            self.ussd_codes.extend(telecom)
            count = len(telecom)
        
        print(f"✅ Added {count} telecom USSD codes")
        return count
    
    def scrape_utility_services(self):
        """Scrape utility service USSD codes from provider websites"""
        print("⚡ Scraping Utility Services...")
        count = 0
        
        # Try scraping utility providers
        utility_urls = {
            'https://www.ecgonline.info': ('ECG Ghana', 'Utilities'),
            'https://www.gwcl.com.gh': ('Ghana Water Company', 'Utilities'),
        }
        
        for url, (provider, category) in utility_urls.items():
            try:
                count += self.scrape_generic_site(url, category, provider)
                time.sleep(2)
            except:
                continue
        
        # Fallback codes
        if count == 0:
            print("⚠️ Using fallback utility codes...")
            utilities = [
            {
                'name': 'ECG Prepaid',
                'code': '*226#',
                'category': 'Utilities',
                'description': 'ECG prepaid electricity services',
                'provider': 'ECG Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'ECG Bill Payment',
                'code': '*920*35#',
                'category': 'Utilities',
                'description': 'Pay ECG bills via mobile',
                'provider': 'ECG Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'Ghana Water Company',
                'code': '*920*33#',
                'category': 'Utilities',
                'description': 'Pay water bills',
                'provider': 'Ghana Water Company',
                'network': 'All Networks'
            },
            {
                'name': 'DSTV Ghana',
                'code': '*920*30#',
                'category': 'Entertainment',
                'description': 'Pay DSTV subscription',
                'provider': 'DSTV Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'GoTV Ghana',
                'code': '*920*31#',
                'category': 'Entertainment',
                'description': 'Pay GoTV subscription',
                'provider': 'GoTV Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'StarTimes Ghana',
                'code': '*920*32#',
                'category': 'Entertainment',
                'description': 'Pay StarTimes subscription',
                'provider': 'StarTimes Ghana',
                'network': 'All Networks'
            }
            ]
            self.ussd_codes.extend(utilities)
            count = len(utilities)
        
        print(f"✅ Added {count} utility USSD codes")
        return count
    
    def scrape_government_services(self):
        """Scrape government service USSD codes from official websites"""
        print("🏛️ Scraping Government Services...")
        count = 0
        
        # Government websites
        gov_urls = {
            'https://nia.gov.gh': ('National Identification Authority', 'Government'),
            'https://www.nhis.gov.gh': ('NHIS Ghana', 'Government'),
        }
        
        for url, (provider, category) in gov_urls.items():
            try:
                count += self.scrape_generic_site(url, category, provider)
                time.sleep(2)
            except:
                continue
        
        # Fallback codes
        if count == 0:
            print("⚠️ Using fallback government codes...")
            gov_services = [
            {
                'name': 'Ghana Card Registration',
                'code': '*920*101#',
                'category': 'Government',
                'description': 'Check Ghana Card registration status',
                'provider': 'National Identification Authority',
                'network': 'All Networks'
            },
            {
                'name': 'NHIS Registration',
                'code': '*929#',
                'category': 'Government',
                'description': 'NHIS mobile registration',
                'provider': 'NHIS Ghana',
                'network': 'All Networks'
            },
            {
                'name': 'SSNIT Contribution',
                'code': '*711#',
                'category': 'Government',
                'description': 'Check SSNIT contributions',
                'provider': 'SSNIT Ghana',
                'network': 'All Networks'
            }
            ]
            self.ussd_codes.extend(gov_services)
            count = len(gov_services)
        
        print(f"✅ Added {count} government USSD codes")
        return count
    
    def scrape_all(self):
        """Scrape all USSD codes from live websites"""
        print("🚀 Starting Real Web Scraping...")
        print("=" * 50)
        print("⚠️ Note: Some websites may block scraping or be slow")
        print("=" * 50)
        
        # Scrape from actual websites
        self.scrape_ghana_banks()
        self.scrape_telecom_services()
        self.scrape_utility_services()
        self.scrape_government_services()
        
        # Try public directories
        try:
            self.scrape_public_ussd_directories()
        except:
            pass
        
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
        print(f"📡 Scraped from live sources + fallbacks")
        
        return self.ussd_codes
    
    def save_to_json(self, filename: str = 'ussd_codes_ghana.json'):
        """Save scraped USSD codes to JSON file"""
        # Add IDs to each code
        for i, code in enumerate(self.ussd_codes):
            code['id'] = f'gh_{i+1:04d}'
            code['country'] = 'Ghana'
            code['last_updated'] = '2025-10-18T00:00:00Z'
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(self.ussd_codes, f, indent=2, ensure_ascii=False)
        
        print(f"\n💾 Saved {len(self.ussd_codes)} USSD codes to {filename}")
    
    def save_to_excel(self, filename: str = 'ussd_codes_ghana.xlsx'):
        """Save scraped USSD codes to Excel file"""
        try:
            import pandas as pd
            
            df = pd.DataFrame(self.ussd_codes)
            df.to_excel(filename, index=False)
            print(f"💾 Saved {len(self.ussd_codes)} USSD codes to {filename}")
        except ImportError:
            print("❌ pandas not installed. Run: pip install pandas openpyxl")

def main():
    scraper = USSDScraper()
    
    # Scrape all USSD codes
    ussd_codes = scraper.scrape_all()
    
    # Save to JSON
    scraper.save_to_json('../assets/dataset/ussd_codes_ghana.json')
    
    # Optionally save to Excel
    # scraper.save_to_excel('../assets/dataset/ussd_codes_ghana.xlsx')
    
    print("\n✅ Scraping Complete!")
    print(f"📊 Categories: {len(set(code['category'] for code in ussd_codes))}")
    print(f"🏢 Providers: {len(set(code['provider'] for code in ussd_codes))}")

if __name__ == '__main__':
    main()

