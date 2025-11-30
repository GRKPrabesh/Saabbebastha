# Sabbebasta Flutter App

Flutter frontend application for the Sabbebasta (शव - व्यवस्था) funeral service booking system.

## Features

- User authentication (Login/Register)
- Service browsing (Electric Crematorium, Fire Burning, Burial Systems)
- Service booking
- Booking history
- User profile management
- Map view for service locations
- Support for Admin and Customer roles

## Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Update the API base URL in `lib/services/api_service.dart`:
   - For Android emulator: `http://10.0.2.2:5000/api`
   - For iOS simulator: `http://localhost:5000/api`
   - For physical device: `http://YOUR_COMPUTER_IP:5000/api`

3. Make sure the backend server is running (see backend README)

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── login_page.dart        # Login screen
├── signup_page.dart       # Registration screen
├── dashboard.dart         # Main dashboard with services
├── maps_page.dart         # Map view for service locations
├── models/                # Data models
│   ├── user.dart
│   ├── service.dart
│   └── booking.dart
└── services/              # API services
    └── api_service.dart
```

## User Roles

- **Customer**: Can browse services, make bookings, view their booking history
- **Admin**: Full access to manage services and view all bookings

## Default Admin Credentials

- Email: `admin@gmail.com`
- Password: `admin@123`

(After running the seed script in the backend)
