class OnboardingPage {
  final String title;
  final String description;
  final String iconData;
  final List<String> features;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.iconData,
    this.features = const [],
  });
}

class OnboardingData {
  static List<OnboardingPage> getPages() {
    return [
      OnboardingPage(
        title: "Welcome to USSD+",
        description: "Your ultimate companion for USSD codes and mobile services. Access thousands of codes from multiple countries instantly.",
        iconData: "📱",
        features: [
          "Multi-country support",
          "Offline access",
          "Quick dialing",
        ],
      ),
      OnboardingPage(
        title: "Smart Country Detection",
        description: "We automatically detect your location to show relevant USSD codes for your country. No manual setup required!",
        iconData: "🌍",
        features: [
          "GPS location detection",
          "IP-based fallback",
          "Manual country selection",
        ],
      ),
      OnboardingPage(
        title: "AI-Powered SMS Analysis",
        description: "Get intelligent insights from your SMS messages. Track expenses, analyze patterns, and discover hidden costs.",
        iconData: "🤖",
        features: [
          "Expense tracking",
          "Pattern analysis",
          "Cost insights",
        ],
      ),
      OnboardingPage(
        title: "Quick Actions & Favorites",
        description: "Save your most-used USSD codes as favorites and access them instantly. One-tap dialing for maximum convenience.",
        iconData: "⭐",
        features: [
          "Favorite codes",
          "Quick dialing",
          "Recent activity",
        ],
      ),
      OnboardingPage(
        title: "Ready to Get Started?",
        description: "You're all set! Start exploring USSD codes and managing your mobile services with USSD+.",
        iconData: "🚀",
        features: [
          "Start exploring",
          "Add favorites",
          "Track expenses",
        ],
      ),
    ];
  }
}
