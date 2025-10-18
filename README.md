# USSD+ - Offline USSD and SMS Analysis App

A powerful Flutter app that combines offline USSD code management with AI-powered SMS analysis. Everything works completely offline, ensuring your data stays private and secure on your device.

## 🚀 Features

### 📱 USSD Management
- **Offline USSD Database**: Access telecom, banking, and utility USSD codes
- **Smart Search**: Find codes by name, provider, or category
- **Favorites**: Save frequently used codes
- **History**: Track recently used codes
- **Tap-to-Dial**: Simulate USSD code dialing

### 🤖 AI-Powered SMS Analysis
- **Smart Categorization**: Automatically categorize SMS into Telecom, Banking, Utilities, Mobile Money, and more
- **Cost Tracking**: Monitor SMS spending by category
- **Smart Suggestions**: Get contextual suggestions based on message content
- **Summary Logic**: Group related messages for better insights

### 🎨 Dynamic UI System
- **Reskin Engine**: Change `themeNumber` in `theme_generator.dart` to completely reskin the app
- **Material 3 Design**: Modern, clean interface
- **Dark Mode Support**: Automatic theme switching
- **Responsive Layout**: Works on all screen sizes

### 🔒 Privacy & Security
- **100% Offline**: No internet required, no data collection
- **Local Storage**: All data stored securely on device
- **No External APIs**: Complete privacy protection
- **App Store Compliant**: Meets all Google Play and Apple App Store requirements

## 🛠️ Technical Stack

- **Flutter 3+** with Material 3
- **Hive** for local database
- **Permission Handler** for runtime permissions
- **Flutter Local Notifications** for notifications
- **AdMob** integration (placeholder)

## 📦 Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ussd-plus.git
cd ussd-plus
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive adapters:
```bash
flutter packages pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

## 🎨 Reskinning the App

To completely reskin the app with a new visual identity:

1. Open `lib/theme/theme_generator.dart`
2. Change the `themeNumber` constant:
```dart
static const int themeNumber = 2; // Change this number
```
3. Hot reload the app to see the new theme

The reskin engine will automatically:
- Generate a new color palette
- Change UI layout and component arrangement
- Modify typography, spacing, and visual elements
- Create a completely fresh visual identity

## 📱 Screenshots

### Dashboard
- Usage statistics and insights
- Quick actions for common tasks
- Recent activity feed

### USSD Codes
- Categorized USSD codes
- Search and filter functionality
- Favorites and history

### SMS Insights
- AI-powered message categorization
- Cost analysis and tracking
- Smart suggestions and summaries

### Settings
- App preferences and configuration
- Privacy policy and about information
- Premium features (placeholder)

## 🔧 Configuration

### Android
- Minimum SDK: 21
- Target SDK: Latest
- Permissions: SMS, Notifications, Phone State

### iOS
- Minimum iOS: 11.0
- Permissions: Notifications (optional)

## 📄 Privacy Policy

USSD+ is designed to work completely offline. We do not collect, store, or transmit any personal information to external servers. All data remains on your device.

- No SMS content is sent to external servers
- All analysis is performed locally using offline algorithms
- USSD codes are stored locally and not transmitted
- No data is backed up to external cloud services

## 🚀 Future Features

- [ ] Advanced AI analysis algorithms
- [ ] More USSD code categories
- [ ] Export/import functionality
- [ ] Widget support
- [ ] Wear OS companion app
- [ ] Advanced analytics and reporting

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support, email support@ussdplus.app or create an issue on GitHub.

---

**Made with ❤️ for offline-first mobile users**
