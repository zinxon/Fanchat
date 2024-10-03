# Fanchat - Hong Kong Stock Price Prediction AI Chatbot

Fanchat is a financial product chatbot that provides AI-powered stock price predictions for the Hong Kong market.

![alt text](https://github.com/zinxon/Fanchat/blob/master/demo%20image/Fanchat.png)

https://github.com/zinxon/Fanchat/assets/24634403/49fba6e4-d99c-466a-81f1-4de02262a6b0

## Features

- AI-powered chatbot for stock price predictions
- User authentication (Email and Google Sign-In)
- Stock watchlist management
- Real-time stock data updates
- Financial reports, stockholder information, and news for each stock
- Investor type recommendation

## Technologies Used

- Flutter for cross-platform mobile development
- Firebase for authentication and data storage
- Dialogflow for natural language processing
- Yahoo Finance API for stock data

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio or Xcode (for iOS development)
- Firebase account

### Installation

1. Clone the repository:

   ```
   git clone https://github.com/your-username/Fanchat.git
   ```

2. Install dependencies:

   ```
   flutter pub get
   ```

3. Set up Firebase:

   - Create a new Firebase project
   - Add your iOS and Android apps to the Firebase project
   - Download and add the `GoogleService-Info.plist` file to the iOS app
   - Download and add the `google-services.json` file to the Android app

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/`: Contains the main Dart code for the application
- `android/`: Android-specific configuration files
- `ios/`: iOS-specific configuration files
- `assets/`: Contains images, fonts, and other static assets
