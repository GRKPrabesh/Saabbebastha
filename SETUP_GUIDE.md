# Sabbebasta Application Setup Guide

Complete setup guide for both frontend and backend of the Sabbebasta application.

## Prerequisites

1. **Node.js** (v14 or higher) - [Download](https://nodejs.org/)
2. **MongoDB** - [Download](https://www.mongodb.com/try/download/community)
3. **Flutter** (v3.9.2 or higher) - [Download](https://flutter.dev/docs/get-started/install)
4. **Git** (optional)

## Backend Setup

### 1. Navigate to Backend Directory
```bash
cd "Sabbebasta Backend"
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Configure Environment Variables

Create a `.env` file in the `Sabbebasta Backend` directory:
```
PORT=5000
MONGODB_URI=mongodb://localhost:27017/sabbebasta
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
NODE_ENV=development
```

### 4. Start MongoDB

Make sure MongoDB is running on your system:
- **Windows**: MongoDB should start automatically as a service
- **Mac/Linux**: Run `mongod` or `sudo systemctl start mongod`

### 5. Seed the Database (Optional but Recommended)

This will create an admin user and sample services:
```bash
npm run seed
```

Default admin credentials:
- Email: `admin`
- Password: `admin@123`

### 6. Start the Backend Server

**Development mode (with auto-reload):**
```bash
npm run dev
```

**Production mode:**
```bash
npm start
```

The server will run on `http://localhost:5000`

## Frontend Setup

### 1. Navigate to Flutter Directory
```bash
cd world_1
```

### 2. Install Flutter Dependencies
```bash
flutter pub get
```

### 3. Configure API Base URL

Edit `lib/services/api_service.dart` and update the `baseUrl` constant:

**For Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:5000/api';
```

**For iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:5000/api';
```

**For Physical Device:**
1. Find your computer's IP address:
   - Windows: `ipconfig` (look for IPv4 Address)
   - Mac/Linux: `ifconfig` or `ip addr`
2. Update the baseUrl:
```dart
static const String baseUrl = 'http://YOUR_IP_ADDRESS:5000/api';
```

### 4. Run the Flutter App

```bash
flutter run
```

## Testing the Application

### 1. Create a Customer Account

1. Open the app
2. Click "Sign Up"
3. Fill in the registration form
4. Submit to create an account

### 2. Login as Customer

1. Use your registered credentials
2. Browse services
3. Book a service
4. View booking history

### 3. Login as Admin

1. Use admin credentials:
   - Email: `admin`
   - Password: `admin@123`
2. Admin can manage services and view all bookings

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user (requires auth)

### Services
- `GET /api/services` - Get all services
- `GET /api/services/:id` - Get service by ID
- `POST /api/services` - Create service (Admin only)
- `PUT /api/services/:id` - Update service (Admin only)
- `DELETE /api/services/:id` - Delete service (Admin only)

### Bookings
- `GET /api/bookings` - Get bookings
- `GET /api/bookings/:id` - Get booking by ID
- `POST /api/bookings` - Create booking
- `PUT /api/bookings/:id/status` - Update booking status (Admin only)
- `DELETE /api/bookings/:id` - Cancel booking

### Users
- `GET /api/users` - Get all users (Admin only)
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user profile
- `DELETE /api/users/:id` - Delete user (Admin only)

## Troubleshooting

### Backend Issues

1. **MongoDB Connection Error**
   - Ensure MongoDB is running
   - Check MONGODB_URI in `.env` file
   - Verify MongoDB is accessible on the specified port

2. **Port Already in Use**
   - Change PORT in `.env` file
   - Or stop the process using port 5000

3. **Module Not Found**
   - Run `npm install` again
   - Delete `node_modules` and reinstall

### Frontend Issues

1. **Network Error**
   - Verify backend is running
   - Check API base URL in `api_service.dart`
   - For physical devices, ensure phone and computer are on same network
   - Check firewall settings

2. **Build Errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Check Flutter version compatibility

3. **CORS Issues**
   - Backend has CORS enabled, but if issues persist, check backend CORS configuration

## Project Structure

```
Sabbebasta_1/
├── Sabbebasta Backend/          # Node.js/Express Backend
│   ├── models/                  # MongoDB models
│   ├── routes/                  # API routes
│   ├── middleware/              # Auth middleware
│   ├── scripts/                 # Database seed script
│   ├── server.js                # Main server file
│   └── package.json
│
└── world_1/                     # Flutter Frontend
    ├── lib/
    │   ├── models/              # Data models
    │   ├── services/            # API service
    │   ├── login_page.dart
    │   ├── signup_page.dart
    │   ├── dashboard.dart
    │   └── maps_page.dart
    └── pubspec.yaml
```

## Next Steps

1. Customize services and locations
2. Add payment integration
3. Implement push notifications
4. Add image upload functionality
5. Enhance admin dashboard
6. Add more service types

## Support

For issues or questions, check the code comments or refer to the README files in each directory.

