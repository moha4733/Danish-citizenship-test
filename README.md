# Dansk Indfødsret Test App

En professionel mobilapp til at øve sig til den danske statsborgerskabsprøve.

##功能

- 40 officielle spørgsmål i samme stil som den rigtige prøve
- Progressiv test med øjeblikkelig feedback
- Resultatskærm med detaljeret gennemgang af forkerte svar
- Abonnementssystem med 7 dages gratis prøveperiode
- Tidstagning (valgfrit)
- Lys/mørk tilstand
- Gem bedste resultater

## Teknisk Stack

- **Framework**: Flutter
- **Sprog**: Dart
- **State Management**: Provider
- **Storage**: SharedPreferences
- **In-App Purchases**: in_app_purchase package
- **Fonts**: Google Fonts (Poppins)

## Kom i Gang

### Forudsætninger

1. Flutter SDK (>=3.10.0)
2. Dart SDK (>=3.0.0)
3. Xcode (til iOS udvikling)
4. Android Studio (til Android udvikling)

### Installation

1. Klon dette repository
2. Kør `flutter pub get` for at installere dependencies
3. Kør `flutter run` for at starte appen

```bash
git clone <repository-url>
cd dansk_indfoedsret_test
flutter pub get
flutter run
```

## Projektstruktur

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── question.dart         # Question data models
├── providers/
│   ├── test_provider.dart    # Test state management
│   └── theme_provider.dart   # Theme state management
├── screens/
│   ├── welcome_screen.dart   # Welcome/onboarding screen
│   ├── home_screen.dart      # Main home screen
│   ├── question_screen.dart  # Quiz questions screen
│   ├── results_screen.dart   # Test results screen
│   └── subscription_screen.dart # Subscription screen
├── services/
│   ├── question_service.dart # Question data service
│   └── storage_service.dart  # Local storage service
└── widgets/                  # Reusable widgets
```

## App Store Publicering

### iOS App Store

#### 1. Apple Developer Setup

1. Opret en Apple Developer Account ($99/år)
2. Opret en ny App ID i App Store Connect
3. Konfigurer App Groups hvis nødvendigt
4. Oret et provisioning profile

#### 2. App Store Connect Configuration

1. Log ind på App Store Connect
2. Opret en ny app under "Apps"
3. Udfyld app information:
   - App Name: "Dansk Indfødsret Test"
   - Primary Language: "Danish"
   - Bundle ID: din unikke identifier
   - SKU: unikt produkt-ID

#### 3. App Information

**App Beskrivelse:**
```
Forbered dig til den danske statsborgerskabsprøve med vores professionelle app. 
Med 40 officielle spørgsmål kan du øve dig i samme stil som den rigtige prøve.

Funktioner:
• 40 spørgsmål om Danmark
• Øjeblikkelig feedback
• Detaljerede forklaringer
• Tidstagning
• Gem dine resultater
• Lys/mørk tilstand

Download i dag og bliv klar til statsborgerskabsprøven!
```

**Keywords:**
`dansk, indfødsret, statsborgerskab, prøve, test, danmark, læring, øvelse`

**Kategorier:**
- Primary: Education
- Secondary: Reference

#### 4. In-App Purchase Setup

1. Gå til "Features" > "In-App Purchases"
2. Opret et nyt abonnement:
   - Product ID: `dansk_test_monthly`
   - Reference Name: "Månedligt Abonnement"
   - Price: 20 DKK
   - Subscription Duration: 1 month
   - Free Trial: 7 days

3. Upload screenshots og app preview
4. Udfyld privacy policy og app metadata

#### 5. Build Configuration

Opdater `ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>
```

Opdater `ios/Runner.xcodeproj` project settings:
- Deployment Target: iOS 13.0+
- Supported Devices: iPhone
- App Store Connect team: dit team ID

#### 6. Build og Upload

```bash
# Build for iOS
flutter build ios --release

# Eller brug Xcode:
# 1. Åbn ios/Runner.xcworkspace
# 2. Vælg "Any iOS Device"
# 3. Product > Archive
# 4. Upload to App Store Connect
```

#### 7. App Review Process

Forbered følgende til review:
- Test account med aktivt abonnement
- Demo af alle features
- Privacy Policy URL
- Support URL
- Marketing URL

### Google Play Store

#### 1. Google Play Console Setup

1. Opret en Google Play Developer Account ($25 engangsgebyr)
2. Opret en ny app under "All apps"
3. Udfyld store listing information

#### 2. Store Listing

**App Title:** "Dansk Indfødsret Test"

**Short Description:**
"Øv dig til den danske statsborgerskabsprøve med 40 officielle spørgsmål."

**Full Description:**
```
Forbered dig til den danske statsborgerskabsprøve med vores professionelle app. 
Med 40 officielle spørgsmål kan du øve dig i samme stil som den rigtige prøve.

Funktioner:
• 40 spørgsmål om Danmark
• Øjeblikkelig feedback
• Detaljerede forklaringer
• Tidstagning
• Gem dine resultater
• Lys/mørk tilstand

Pris:
• 7 dages gratis prøveperiode
• 20 DKK pr. måned

Download i dag og bliv klar til statsborgerskabsprøven!
```

#### 3. Build og Upload

```bash
# Build for Android
flutter build appbundle --release

# Upload til Google Play Console via Google Play Android Developer API
```

## Legal og Compliance

### Privacy Policy

Opret en privacy policy der dækker:
- Data collection (ingen personlige data)
- In-app purchase information
- Contact information
- Data retention

### Terms of Service

Inkluder:
- Subscription terms
- Auto-renewal information
- Cancellation policy
- Refund policy

## Marketing Material

### App Icons
- 1024x1024 px for App Store
- Multiple sizes for Android

### Screenshots
Krævede screenshots:
- iPhone 6.7" Display
- iPhone 6.5" Display
- iPad Pro (12.9-inch) Display

### App Preview Video
- 15-30 sekunder
- Vis key features
- App Store format

## Testing

### Test Flight Beta Testing
1. Upload build til TestFlight
2. Inviter interne testere
3. Test in-app purchases
4. Test alle flows

### Google Play Beta Testing
1. Upload til internal testing
2. Test in-app billing
3. Test forskellige devices

## Post-Launch

### Analytics
Implementer analytics for:
- User engagement
- Subscription conversion
- Feature usage
- Crash reports

### Updates
Plan for regular updates:
- New questions
- Bug fixes
- Performance improvements
- New features

## Support

### Contact Information
- Email: support@dansktest.dk
- Website: dansktest.dk
- Privacy Policy: dansktest.dk/privacy
- Terms: dansktest.dk/terms

## Revenue Model

- **Subscription:** 20 DKK/month
- **Free Trial:** 7 days
- **Apple Commission:** 30%
- **Google Commission:** 30%
- **Net Revenue:** 14 DKK/month per user

## Success Metrics

- Download numbers
- Subscription conversion rate
- User retention
- App Store rating
- Monthly recurring revenue
