# Learning App - Flutter Learning Platform

A comprehensive Flutter learning application built with GetX state management and REST API integration.

## 📱 Features

### 1. Onboarding Flow
- **Two-page onboarding experience**
  - Page 1: "Smarter Learning Starts Here" with personalized learning introduction
  - Page 2: "Learn. Practice. Succeed." showcasing app features
- **Navigation options**: Next button to progress, Skip button to jump to home
- **Persistent storage**: Onboarding completion status saved using GetStorage

### 2. Home Page
Dynamic content loaded from REST API including:
- **Greeting section** with user welcome message
- **Active course card** with Continue/Join Course actions
- **Category chips** for course filtering
- **Popular courses** horizontal scrollable list
- **Live class card** with Join Now action
- **Community section** for engagement
- **Testimonials** carousel from users
- **Contact section** with Chat and Call options
- **Bottom navigation** bar for app sections

### 3. Subjects/Videos Page
- **Video player** section (placeholder for actual video integration)
- **Video information** including title and description
- **Video list** with:
  - ✓ Completed videos (green checkmark)
  - 🔒 Locked videos (disabled state)
  - ▶️ Available videos (playable)
- **Download option** for offline viewing

### 4. Streak Page
- **Visual learning path** showing progress
- **Day-by-day tracking** with completion status
- **Module markers** for learning milestones
- **Accessible from** "Day 7 🔥" button on home page

## 🛠️ Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: GetX
- **Navigation**: GetX Navigation
- **Local Storage**: GetStorage
- **HTTP Client**: http package
- **Video Player**: video_player package
- **Image Caching**: cached_network_image
- **UI Components**: smooth_page_indicator

## 📡 API Integration

**Base URL**: `https://trogon.info/task/api/`

### Endpoints:
1. **Home Page**: `home.php`
   - Fetches greeting, active courses, categories, popular courses, live classes, community info, testimonials, and contact details

2. **Video Details**: `video_details.php`
   - Fetches video URL, title, description, course name, and video list with completion status

3. **Streak Data**: `streak.php`
   - Fetches current streak, total days, and day-by-day completion data

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart       # API URLs and app constants
│   ├── routes/
│   │   ├── app_routes.dart         # Route names
│   │   └── app_pages.dart          # GetX page configuration
│   └── theme/
│       └── app_theme.dart          # App colors and theme
│
├── data/
│   ├── models/
│   │   ├── home_model.dart         # Home page data models
│   │   ├── video_model.dart        # Video data models
│   │   └── streak_model.dart       # Streak data models
│   └── services/
│       └── api_service.dart        # REST API service
│
├── controllers/
│   ├── onboarding_controller.dart  # Onboarding state management
│   ├── home_controller.dart        # Home page state management
│   ├── video_controller.dart       # Videos page state management
│   └── streak_controller.dart      # Streak page state management
│
├── views/
│   ├── onboarding/
│   │   └── onboarding_page.dart    # Onboarding UI
│   ├── home/
│   │   └── home_page.dart          # Home page UI
│   ├── videos/
│   │   └── videos_page.dart        # Videos page UI
│   └── streak/
│       └── streak_page.dart        # Streak page UI
│
└── main.dart                        # App entry point
```

## 📦 Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd learningapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For mobile/emulator
   flutter run
   
   # For web
   flutter run -d chrome
   
   # For specific device
   flutter devices  # List available devices
   flutter run -d <device-id>
   ```

## 🎨 Design Features

- **Modern UI/UX**: Clean and intuitive interface
- **Gradient backgrounds**: Eye-catching color schemes
- **Smooth animations**: Enhanced user experience
- **Responsive layouts**: Adapts to different screen sizes
- **Loading states**: Visual feedback during data fetching
- **Error handling**: User-friendly error messages
- **Empty states**: Graceful handling of no data scenarios

## 📱 Navigation Flow

```
Onboarding Page
    ├── Page 1 (Next) → Page 2
    │                    └── (Next) → Home Page
    └── (Skip) → Home Page

Home Page
    ├── Continue Button → Videos Page
    ├── Day 7 🔥 Button → Streak Page
    └── Bottom Nav → (Home/Courses/Tools/Profile)

Videos Page
    └── Back Button → Home Page

Streak Page
    └── Back Button → Home Page
```

## 🔧 State Management

All pages use **GetX controllers** for:
- ✅ Reactive state management
- ✅ API data fetching
- ✅ Loading states
- ✅ Error handling
- ✅ Navigation

## 🎯 Key Implementations

### 1. GetX State Management
- Controllers automatically initialized when pages load
- Reactive UI updates using `.obs` variables
- Clean separation of business logic and UI

### 2. REST API Integration
- Centralized `ApiService` class
- Proper error handling
- JSON parsing to Dart models
- Loading and error states

### 3. Persistent Storage
- Onboarding completion flag saved locally
- App remembers if user has completed onboarding
- Automatic route selection on app start

### 4. Dynamic UI
- Data-driven content from APIs
- Fallback content for API failures
- Smooth loading transitions

## 🚀 Running the App

### Development Mode
```bash
flutter run
```

### Production Build
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📝 Notes

- The app requires an internet connection to fetch data from APIs
- Video player functionality is a placeholder and can be integrated with actual video URLs
- All screens have loading, error, and empty states for better UX
- The app uses GetStorage for local persistence (onboarding status)

## 🐛 Troubleshooting

**Issue**: API not loading
- Check internet connection
- Verify API endpoints are accessible
- Check console for error messages

**Issue**: Onboarding not skipping
- Clear app data and restart
- Check GetStorage initialization in main.dart

**Issue**: Navigation not working
- Ensure all routes are registered in `app_pages.dart`
- Check route names match in navigation calls

## 📄 License

This project is for educational purposes.

## 👨‍💻 Developer

Built with Flutter, GetX, and ❤️
