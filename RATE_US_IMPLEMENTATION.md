# Rate Us Feature Implementation

## Overview
A smart, user-friendly rating system has been implemented to encourage app store reviews at optimal moments based on user engagement.

## When the Rating Dialog Appears

### Smart Timing Criteria
The rating dialog will only appear when ALL of the following conditions are met:

1. **Session Count**: User has launched the app at least 5 times
2. **Days Since Install**: At least 3 days since first installation
3. **Action Count**: User has performed at least 10 meaningful actions (e.g., dialing USSD codes)
4. **Session Engagement**: User has been active for at least 2 minutes in current session
5. **Not Recently Declined**: Hasn't been declined in the last 30 days
6. **Frequency Control**: At least 7 days between prompts

### Trigger Points
- **Every 10th successful USSD code dial**: After dialing 10 USSD codes successfully
- **Manual trigger**: Users can manually rate from Settings → Rate the App
- **After positive actions**: When user completes meaningful tasks (dial codes, analyze SMS, etc.)

## User Experience Features

### 1. Beautiful Rating Dialog
- **Non-intrusive**: User-friendly design with gradient styling
- **Clear options**: Three choices available:
  - "Rate us" - Opens the app store for rating
  - "Later" - Snoozes the prompt (can appear again later)
  - "No, thanks" - Declines and won't ask again for 30 days

### 2. Settings Integration
- **Rate Us Button**: Available in Settings screen under "About" section
- **Always accessible**: Users can rate anytime from Settings
- **Beautiful UI**: Matches app theme with star icon

### 3. Privacy & Respect
- **Never annoying**: Won't spam users with prompts
- **Respects user choice**: Remembers if user declined
- **Timing awareness**: Never interrupts important tasks

## Implementation Details

### Files Created
1. `lib/utils/app_review_service.dart` - Core rating logic
2. `lib/widgets/rate_us_dialog.dart` - UI components

### Files Modified
1. `pubspec.yaml` - Added `in_app_review` package
2. `lib/main.dart` - Initialize review service
3. `lib/screens/settings_screen.dart` - Added Rate Us button
4. `lib/screens/ussd_codes_screen.dart` - Action tracking and rating triggers

### Key Features

#### AppReviewService
```dart
// Track sessions
await AppReviewService.initialize();

// Record user actions
await AppReviewService.recordAction('ussd_code_dialed', metadata: code.code);

// Check if should show rating
final shouldShow = await AppReviewService.shouldRequestReview();

// Get statistics
final stats = await AppReviewService.getStats();
```

#### RateUsDialog
```dart
// Show the rating dialog
await RateUsDialog.show(context);

// Or add the button to settings
const RateUsButton()
```

## Timing Strategy (Optimal UX)

### ✅ When to Show:
1. After successful USSD code dials (every 10th time)
2. After completing SMS analysis
3. After earning coins
4. After adding favorites
5. After minimum engagement thresholds met

### ❌ When NOT to Show:
1. Immediately after app install
2. During onboarding flow
3. Right after errors or crashes
4. If user already rated
5. If user declined within last 30 days
6. During first few sessions (need warmup time)

## Configuration

### Adjusting Thresholds
Edit `lib/utils/app_review_service.dart`:

```dart
static const int _minSessionsBeforeReview = 5;    // Minimum app launches
static const int _minDaysSinceInstall = 3;          // Days since first install
static const int _daysBetweenPrompts = 30;          // Days between prompts
static const int _minActionsBeforeReview = 10;      // Minimum user actions
static const int _minMinutesInSession = 2;          // Active minutes in session
```

### Rating Frequency in Actions
Edit `lib/screens/ussd_codes_screen.dart`:

```dart
// In _maybeShowRatingDialog() method
if (actionCount > 0 && actionCount % 10 == 0) {  // Change 10 to desired frequency
```

## Testing

### Test Mode
Add a test button in Settings to manually trigger:

```dart
ElevatedButton(
  onPressed: () => AppReviewService.forceRequestReview(),
  child: Text('Test Rating'),
)
```

### Reset Data
```dart
await AppReviewService.reset();  // Clear all review data
```

### Check Stats
```dart
final stats = await AppReviewService.getStats();
print(stats);  // View current statistics
```

## Best Practices Applied

1. **User-Friendly**: Only asks when user is engaged
2. **Respectful**: Doesn't annoy or interrupt
3. **Smart Timing**: Appears after positive experiences
4. **Remembers Choices**: Respects user's "no thanks"
5. **Optional**: Users can rate anytime from Settings
6. **Beautiful UI**: Matches app design and theme

## User Flow

```
User installs app
    ↓
App tracks sessions and actions
    ↓
After 5 sessions + 3 days + 10 actions
    ↓
User dials 10th USSD code
    ↓
Rating dialog appears (beautiful & non-intrusive)
    ↓
User chooses:
  ✅ Rate us → Opens app store
  ⏸️ Later → Can appear again later
  ❌ No thanks → Won't ask for 30 days
```

## Benefits

1. **More Reviews**: Strategic timing increases conversion
2. **Better UX**: Only appears at optimal moments
3. **Privacy Respect**: No intrusive popups
4. **User Control**: Can rate anytime from Settings
5. **App Store Compliance**: Follows platform guidelines
6. **Retention**: Positive interaction improves user satisfaction

## Future Enhancements

- Add SMS analysis as a trigger point
- Add favorite actions as trigger point
- Add coin earning as trigger point
- Custom messages based on user engagement level
- A/B testing different trigger timings

## Summary

The Rate Us feature is now fully implemented with:
- ✅ Smart timing based on user engagement
- ✅ Beautiful, non-intrusive UI
- ✅ Respects user choices
- ✅ Settings integration
- ✅ Action tracking
- ✅ Privacy-focused

The rating dialog will appear at optimal moments when users are most likely to provide positive feedback, resulting in more app store reviews and better user experience.

