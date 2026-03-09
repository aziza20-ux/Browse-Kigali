Browse-Kigali

Browse-Kigali is a Flutter mobile application that helps users explore Kigali’s businesses, services, and points of interest. It provides an intuitive interface to browse listings, view detailed information with location maps, and navigate to selected locations with turn-by-turn directions.

Features

Browse Listings: View different service providers, businesses, and points of interest in Kigali.

Search & Filter: Quickly search for listings by name, category, or location.

Listing Details: Detailed page for each listing with description, images, contact info, and location map.

Map Integration: Embedded Google Map showing the exact location of each listing.

Turn-by-Turn Navigation: Launch Google Maps for directions from your current location to the selected listing.

User Authentication: Sign up, log in, and manage your profile.

Categories: Listings are organized by categories to facilitate browsing and filtering.

Project Structure lib/ ├── screens/ # UI screens of the app (HomeScreen, ListingDetail, Login, etc.) ├── services/ # Firebase interaction and other backend services (AuthService, ListingService) ├── state_management/ # Providers for state management (AuthProvider, ListingProvider, DirectoryProvider) ├── models/ # Data models (UserModel, ListingModel) Firestore Database Structure Firestore Root │ ├── users │ ├── {userId} │ │ ├── name: string │ │ ├── email: string │ │ └── profilePic: string (optional) │ ├── listings │ ├── {listingId} │ │ ├── name: string │ │ ├── description: string │ │ ├── category: string │ │ ├── images: array of strings (image URLs) │ │ ├── location: │ │ │ ├── latitude: double │ │ │ └── longitude: double │ │ └── contact: string │

Notes:

Each listing is directly associated with a category for simplicity.

Location data uses latitude and longitude for map integration.

Users collection stores authentication info and optional profile.

State Management

The app uses Provider for state management. Each folder and class corresponds to a specific part of the app’s reactive state:

AuthProvider (state_management/auth_provider.dart): Handles user login, signup, and authentication state.

ListingProvider (state_management/listing_provider.dart): Manages retrieval, filtering, and updating listings from Firestore.

DirectoryProvider (state_management/category_provider.dart): Manages categories for listings and helps with filtering.

Workflow:

Providers fetch data asynchronously from Firestore through services.

Changes trigger notifyListeners(), updating subscribed UI screens automatically.

Screens use Consumer or Provider.of to reactively display the latest data.

Getting Started

Clone the repository:

git clone https://github.com/yourusername/browse-kigali.git

Install dependencies:

flutter pub get

Configure Firebase:

Add google-services.json (Android) or GoogleService-Info.plist (iOS).

Enable Firebase Authentication and Firestore in your Firebase project.

Run the app:

flutter run
