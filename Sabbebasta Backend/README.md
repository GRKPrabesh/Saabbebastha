# Sabbebasta Backend API

Backend API for the Sabbebasta (शव - व्यवस्था) application built with Node.js, Express, and MongoDB.

## Features

- User authentication (Admin and Customer roles)
- JWT-based authentication
- RESTful API endpoints
- MongoDB database integration
- Service management
- Booking system

## Installation

1. Install dependencies:
```bash
npm install
```

2. Create a `.env` file in the root directory:
```
PORT=5000
MONGODB_URI=mongodb://localhost:27017/sabbebasta
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
NODE_ENV=development
```

3. Make sure MongoDB is running on your system

4. Start the server:
```bash
# Development mode with auto-reload
npm run dev

# Production mode
npm start
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user (requires authentication)

### Services
- `GET /api/services` - Get all services
- `GET /api/services/:id` - Get service by ID
- `POST /api/services` - Create service (Admin only)
- `PUT /api/services/:id` - Update service (Admin only)
- `DELETE /api/services/:id` - Delete service (Admin only)

### Bookings
- `GET /api/bookings` - Get bookings (user's own or all if admin)
- `GET /api/bookings/:id` - Get booking by ID
- `POST /api/bookings` - Create booking
- `PUT /api/bookings/:id/status` - Update booking status (Admin only)
- `DELETE /api/bookings/:id` - Cancel booking

### Users
- `GET /api/users` - Get all users (Admin only)
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user profile
- `DELETE /api/users/:id` - Delete user (Admin only)

## Authentication

Include the JWT token in the Authorization header:
```
Authorization: Bearer <token>
```

## User Roles

- **admin**: Full access to all endpoints
- **customer**: Limited access to their own data

## Database Models

- **User**: Stores user information and authentication data
- **Service**: Stores service offerings (Electric Crematorium, Fire Burning, Burial Systems)
- **Booking**: Stores booking information linking users and services

