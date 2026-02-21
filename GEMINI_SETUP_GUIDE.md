# Gemini Chatbot Integration Setup Guide

## Overview
The DiPrep app now includes an AI-powered chatbot powered by Google Gemini. This guide will help you set up the Gemini API key to enable the chatbot feature.

## Prerequisites
- A Google Cloud account
- Access to Google AI Studio (MakerSuite)

## Steps to Get Your Gemini API Key

### 1. Get a Free API Key
- Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
- Click "Create API Key"
- Select or create a Google Cloud project
- Your API key will be generated automatically

### 2. Configure the App
- Open `lib/services/gemini_service.dart`
- Replace `'YOUR_GEMINI_API_KEY'` with your actual API key:

```dart
static const String apiKey = 'your-actual-api-key-here';
```

### 3. Important Security Notes
- **Never commit your API key to version control**
- Consider using environment variables or Firebase Remote Config for production
- Keep your API key private

### 4. Alternative: Use Firebase Remote Config (Recommended for Production)
Instead of hardcoding the API key, you can use Firebase Remote Config:

1. Go to Firebase Console > Remote Config
2. Add a new parameter: `gemini_api_key`
3. Set the value to your Gemini API key
4. Update `gemini_service.dart` to fetch from Remote Config

## Features
- **Disaster Preparedness Chatbot**: Ask questions about emergency preparedness, disaster safety, and evacuation procedures
- **Message History**: Chat history is maintained during the session
- **Clear Chat**: Users can clear chat history via the delete button in the app bar
- **Real-time Responses**: Get instant responses from Gemini AI

## Usage
1. Open the DiPrep app
2. Navigate to the "AI Chat" tab (bottom navigation)
3. Ask any question related to disaster preparedness or safety
4. The chatbot will provide helpful information and guidance

## Customization
To customize the chatbot behavior, modify the system prompt in `chatbot_screen.dart` or `gemini_service.dart`:

```dart
// Add a system message to guide Gemini's responses
final systemMessage = Content.text(
  'You are a disaster preparedness expert. Focus responses on emergency safety, evacuation procedures, and disaster preparedness.'
);
```

## Troubleshooting

### "Error: Invalid API key"
- Verify your API key is correct
- Check that the key is enabled in Google Cloud Console
- Ensure your project has the Generative AI API enabled

### No Response from Gemini
- Check your internet connection
- Verify your API key is valid
- Check Google Cloud Console for any rate limiting or quota issues

### Slow Responses
- This is normal for the first request as the API initializes
- Subsequent requests should be faster
- Check your internet connection

## API Usage Limits
Google offers free API access with rate limits:
- Free tier: 60 requests per minute
- Check [Google AI Studio](https://makersuite.google.com/app/settings/quota) for your quota

## Support
For issues with the Gemini API, visit:
- [Google Generative AI Documentation](https://ai.google.dev/)
- [Flutter google_generative_ai Package](https://pub.dev/packages/google_generative_ai)
