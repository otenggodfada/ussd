import 'package:ussd_plus/utils/ussd_data_service.dart';

class CountryConfig {
  final String name;
  final String currency;
  final String currencySymbol;
  final String currencyCode;
  final List<String> telecomProviders;
  final List<String> bankingProviders;
  final List<String> mobileMoneyProviders;
  final List<String> utilityProviders;

  const CountryConfig({
    required this.name,
    required this.currency,
    required this.currencySymbol,
    required this.currencyCode,
    required this.telecomProviders,
    required this.bankingProviders,
    required this.mobileMoneyProviders,
    required this.utilityProviders,
  });
}

class CountryConfigService {
  static const Map<String, CountryConfig> _countryConfigs = {
    'Ghana': CountryConfig(
      name: 'Ghana',
      currency: 'Ghana Cedi',
      currencySymbol: 'GHS',
      currencyCode: 'GHS',
      telecomProviders: ['MTN', 'Vodafone', 'AirtelTigo', 'Glo'],
      bankingProviders: ['GCB Bank', 'Absa Bank', 'Fidelity Bank', 'Zenith Bank', 'Access Bank', 'Stanbic Bank', 'GTBank', 'First Bank', 'Ecobank', 'CAL Bank', 'Republic Bank', 'Agricultural Development Bank'],
      mobileMoneyProviders: ['MTN Mobile Money', 'Vodafone Cash', 'Airtel Money', 'Tigo Cash'],
      utilityProviders: ['ECG', 'GWC', 'GRDC'],
    ),
    'Nigeria': CountryConfig(
      name: 'Nigeria',
      currency: 'Nigerian Naira',
      currencySymbol: 'NGN',
      currencyCode: 'NGN',
      telecomProviders: ['MTN', 'Airtel', 'Globacom', '9mobile'],
      bankingProviders: ['GTBank', 'Access Bank', 'First Bank', 'Zenith Bank', 'UBA', 'Fidelity Bank', 'Stanbic Bank', 'Ecobank', 'Union Bank', 'Wema Bank', 'Polaris Bank', 'FCMB', 'Sterling Bank', 'Jaiz Bank', 'Heritage Bank', 'Keystone Bank', 'Titan Trust Bank', 'Providus Bank'],
      mobileMoneyProviders: ['OPay', 'PalmPay', 'Kuda Bank', 'Carbon', 'FairMoney'],
      utilityProviders: ['EKEDC', 'IKEDC', 'AEDC', 'PHED', 'KEDCO'],
    ),
    'Kenya': CountryConfig(
      name: 'Kenya',
      currency: 'Kenyan Shilling',
      currencySymbol: 'KES',
      currencyCode: 'KES',
      telecomProviders: ['Safaricom', 'Airtel', 'Telkom'],
      bankingProviders: ['Equity Bank', 'KCB Bank', 'Cooperative Bank', 'NCBA Bank', 'Standard Chartered', 'Barclays Bank', 'Absa Bank', 'Stanbic Bank', 'Diamond Trust Bank', 'I&M Bank', 'Family Bank', 'HF Group', 'Sidian Bank', 'GTBank', 'UBA Bank'],
      mobileMoneyProviders: ['M-Pesa', 'Airtel Money', 'T-Kash'],
      utilityProviders: ['Kenya Power', 'Kenya Water', 'Nairobi Water'],
    ),
    'Tanzania': CountryConfig(
      name: 'Tanzania',
      currency: 'Tanzanian Shilling',
      currencySymbol: 'TZS',
      currencyCode: 'TZS',
      telecomProviders: ['Vodacom', 'Airtel', 'Tigo', 'Halotel'],
      bankingProviders: ['CRDB Bank', 'NMB Bank', 'NBC Bank', 'Stanbic Bank', 'Exim Bank', 'Azania Bank', 'DTB Bank', 'Equity Bank', 'TPB Bank', 'NCBA Bank'],
      mobileMoneyProviders: ['M-Pesa', 'Tigo Pesa', 'Airtel Money', 'Halotel Pesa', 'Ezy Pesa'],
      utilityProviders: ['LUKU', 'DAWASA', 'DSTV', 'StarTimes'],
    ),
    'Uganda': CountryConfig(
      name: 'Uganda',
      currency: 'Ugandan Shilling',
      currencySymbol: 'UGX',
      currencyCode: 'UGX',
      telecomProviders: ['MTN', 'Airtel', 'Uganda Telecom'],
      bankingProviders: ['Stanbic Bank', 'Centenary Bank', 'dfcu Bank', 'Equity Bank', 'Standard Chartered', 'Barclays Bank', 'KCB Bank', 'DTB Bank', 'Housing Finance Bank', 'Bank of Uganda'],
      mobileMoneyProviders: ['MTN Mobile Money', 'MTN MoKash', 'Airtel Money'],
      utilityProviders: ['UMEME', 'NWSC', 'DSTV', 'GOtv', 'StarTimes'],
    ),
    'South Africa': CountryConfig(
      name: 'South Africa',
      currency: 'South African Rand',
      currencySymbol: 'ZAR',
      currencyCode: 'ZAR',
      telecomProviders: ['Vodacom', 'MTN', 'Cell C', 'Telkom'],
      bankingProviders: ['Standard Bank', 'FNB', 'ABSA', 'Nedbank', 'Capitec Bank', 'Investec', 'Discovery Bank', 'TymeBank', 'African Bank', 'Bidvest Bank'],
      mobileMoneyProviders: ['FNB eWallet', 'Standard Bank Instant Money', 'ABSA Cash Send'],
      utilityProviders: ['Eskom', 'City Power', 'Ethekwini', 'Cape Town'],
    ),
    'Rwanda': CountryConfig(
      name: 'Rwanda',
      currency: 'Rwandan Franc',
      currencySymbol: 'RWF',
      currencyCode: 'RWF',
      telecomProviders: ['MTN', 'Airtel', 'Tigo'],
      bankingProviders: ['Bank of Kigali', 'Equity Bank', 'KCB Bank', 'GTBank', 'Access Bank', 'Ecobank'],
      mobileMoneyProviders: ['MTN Mobile Money', 'Airtel Money'],
      utilityProviders: ['EWSA', 'REG', 'RURA'],
    ),
    'India': CountryConfig(
      name: 'India',
      currency: 'Indian Rupee',
      currencySymbol: 'INR',
      currencyCode: 'INR',
      telecomProviders: ['Airtel', 'Jio', 'Vodafone Idea', 'BSNL'],
      bankingProviders: ['SBI', 'HDFC Bank', 'ICICI Bank', 'Axis Bank', 'Kotak Mahindra Bank', 'IndusInd Bank', 'Yes Bank', 'Federal Bank', 'IDFC Bank', 'RBL Bank', 'Bandhan Bank', 'City Union Bank'],
      mobileMoneyProviders: ['Paytm', 'PhonePe', 'Google Pay', 'BHIM UPI'],
      utilityProviders: ['BSES', 'Tata Power', 'Adani Electricity', 'MSEB'],
    ),
    'USA': CountryConfig(
      name: 'USA',
      currency: 'US Dollar',
      currencySymbol: 'USD',
      currencyCode: 'USD',
      telecomProviders: ['AT&T', 'T-Mobile', 'Verizon', 'Sprint', 'Boost Mobile', 'Cricket Wireless', 'Metro by T-Mobile'],
      bankingProviders: ['Chase', 'Bank of America', 'Wells Fargo', 'Citibank', 'US Bank', 'PNC Bank', 'Capital One', 'TD Bank', 'HSBC', 'Regions Bank'],
      mobileMoneyProviders: ['Venmo', 'PayPal', 'Zelle', 'Cash App', 'Apple Pay', 'Google Pay'],
      utilityProviders: ['ConEd', 'PG&E', 'Southern California Edison', 'Florida Power & Light'],
    ),
  };

  static CountryConfig getCountryConfig(String country) {
    return _countryConfigs[country] ?? _countryConfigs['Ghana']!;
  }

  static Future<CountryConfig> getCurrentCountryConfig() async {
    final selectedCountry = await USSDDataService.getSelectedCountry();
    return getCountryConfig(selectedCountry);
  }

  static List<String> getAllSupportedCountries() {
    return _countryConfigs.keys.toList();
  }

  static String getCurrencySymbol(String country) {
    return getCountryConfig(country).currencySymbol;
  }

  static String getCurrencyCode(String country) {
    return getCountryConfig(country).currencyCode;
  }

  static String getCurrencyName(String country) {
    return getCountryConfig(country).currency;
  }

  static List<String> getTelecomProviders(String country) {
    return getCountryConfig(country).telecomProviders;
  }

  static List<String> getBankingProviders(String country) {
    return getCountryConfig(country).bankingProviders;
  }

  static List<String> getMobileMoneyProviders(String country) {
    return getCountryConfig(country).mobileMoneyProviders;
  }

  static List<String> getUtilityProviders(String country) {
    return getCountryConfig(country).utilityProviders;
  }

  static List<String> getAllProviders(String country) {
    final config = getCountryConfig(country);
    return [
      ...config.telecomProviders,
      ...config.bankingProviders,
      ...config.mobileMoneyProviders,
      ...config.utilityProviders,
    ];
  }
}
