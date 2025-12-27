# 🌍 Smart Travel Planner

A beautiful Flutter application for planning trips to popular Indian destinations. Built with **GetX** state management and clean architecture.

## ✨ Features

- 🔍 **Search Destinations** - Find cities and get real-time weather info
- 🏛️ **Discover Places** - Browse tourist attractions, restaurants, and landmarks
- 📅 **Create Itineraries** - Plan your trip with custom date ranges
- 💾 **Save Trips** - Local storage using Hive for offline access
- 🌤️ **Live Weather** - Real-time weather data for your destinations

## 📱 Screenshots

*Coming soon*

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **GetX** | State management, routing, dependency injection |
| **Hive** | Local NoSQL database |
| **OpenWeatherMap API** | Weather data |
| **Geoapify API** | Places and attractions |

## 🏗️ Architecture

```
lib/
├── main.dart
└── app/
    ├── core/
    │   ├── constants/    # API configs & app constants
    │   ├── theme/        # App theming
    │   └── utils/        # Helper functions
    ├── data/
    │   ├── models/       # Data models (Destination, Place, Trip, Weather)
    │   ├── providers/    # API service providers
    │   └── repositories/ # Data layer abstraction
    ├── modules/
    │   ├── home/         # Home screen with popular destinations
    │   ├── destination/  # Destination details & places
    │   ├── itinerary/    # Trip planning screen
    │   └── saved_trips/  # Saved trips list
    ├── routes/           # GetX routing
    └── widgets/          # Reusable UI components
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/RaviSahu1520/gravity_assignment.git
   cd gravity_assignment
   ```

2. **Add API Keys**
   ```bash
   # Copy the template file
   cp lib/app/core/constants/api_secrets.template.dart lib/app/core/constants/api_secrets.dart
   ```
   
   Then edit `api_secrets.dart` with your own API keys:
   - [OpenWeatherMap API](https://openweathermap.org/api)
   - [Geoapify API](https://www.geoapify.com/)

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📍 Featured Destinations

- Gwalior
- Indore
- Bhopal
- Jaipur
- Udaipur
- Varanasi

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

Made with ❤️ using Flutter
