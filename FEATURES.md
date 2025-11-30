# Sabbebasta Application - Feature List

## ✅ Implemented Features

### Customer Features

#### 1. **User Registration & Login**
- ✅ Register new account with full details (first name, last name, username, email, phone, password)
- ✅ Login with email, username, or phone number
- ✅ JWT token-based authentication
- ✅ Secure password storage with bcrypt hashing

#### 2. **Profile Management**
- ✅ View user profile information
- ✅ Edit profile (first name, last name, email, phone)
- ✅ Profile page shows user role (Admin/Customer)
- ✅ Logout functionality

#### 3. **Service Selection & Booking**
- ✅ Browse available services:
  - Electric Crematorium
  - Fire Burning
  - Burial Systems
- ✅ View service details (price, duration, rating, description)
- ✅ Choose service type when booking
- ✅ **Custom Location Selection**:
  - Option to choose custom location for cremation/burial
  - Interactive map to select location
  - Uses Google Maps for location picking
  - Can use default service location or custom location

#### 4. **Booking System**
- ✅ Create bookings with:
  - Deceased person name (required)
  - Relationship to deceased (required)
  - Booking date selection
  - Custom location (optional)
  - Additional notes (optional)
- ✅ View booking history
- ✅ See booking status (pending, confirmed, completed, cancelled)
- ✅ View booking details including location information

#### 5. **Map Integration**
- ✅ View service locations on map
- ✅ Select custom location on map for bookings
- ✅ See all service markers on map

### Admin Features

#### 1. **Admin Dashboard**
- ✅ Access admin dashboard (visible only to admin users)
- ✅ Three main tabs:
  - **Bookings**: View and manage all customer bookings
  - **Customers**: View all registered users
  - **Services**: View all available services

#### 2. **Booking Management**
- ✅ View all bookings from all customers
- ✅ Update booking status:
  - Pending
  - Confirmed
  - Completed
  - Cancelled
- ✅ View detailed booking information:
  - Customer details
  - Service details
  - Deceased person information
  - Custom location (if selected)
  - Payment status
  - Notes

#### 3. **Customer Management**
- ✅ View all registered customers
- ✅ See customer details:
  - Name
  - Email
  - Phone
  - Role (Admin/Customer)
- ✅ Customer list with role indicators

#### 4. **Service Management**
- ✅ View all services
- ✅ See service details (price, duration, type)
- ✅ Service status (active/inactive)

## Technical Features

### Backend (Node.js/Express/MongoDB)
- ✅ RESTful API architecture
- ✅ MongoDB database with Mongoose ODM
- ✅ JWT authentication middleware
- ✅ Role-based access control (Admin/Customer)
- ✅ Password hashing with bcrypt
- ✅ Input validation with express-validator
- ✅ CORS enabled for frontend communication
- ✅ Error handling and validation

### Frontend (Flutter)
- ✅ Material Design UI
- ✅ State management
- ✅ HTTP API integration
- ✅ SharedPreferences for token storage
- ✅ Google Maps integration
- ✅ Form validation
- ✅ Loading states and error handling
- ✅ Responsive design

## Database Models

### User Model
- First name, last name, username
- Email, phone, country code
- Password (hashed)
- Role (admin/customer)
- Timestamps

### Service Model
- Title, description
- Price, duration, rating
- Service type (electric_crematorium, fire_burning, burial_systems)
- Location (latitude, longitude, address)
- Active status

### Booking Model
- User reference
- Service reference
- Booking date
- Status (pending, confirmed, completed, cancelled)
- Payment status
- **Deceased name**
- **Relationship**
- **Custom location** (latitude, longitude, address)
- Notes
- Timestamps

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user

### Services
- `GET /api/services` - Get all services
- `GET /api/services/:id` - Get service by ID
- `POST /api/services` - Create service (Admin only)
- `PUT /api/services/:id` - Update service (Admin only)
- `DELETE /api/services/:id` - Delete service (Admin only)

### Bookings
- `GET /api/bookings` - Get bookings (user's own or all if admin)
- `GET /api/bookings/:id` - Get booking by ID
- `POST /api/bookings` - Create booking with custom location support
- `PUT /api/bookings/:id/status` - Update booking status (Admin only)
- `DELETE /api/bookings/:id` - Cancel booking

### Users
- `GET /api/users` - Get all users (Admin only)
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user profile
- `DELETE /api/users/:id` - Delete user (Admin only)

## User Flow

### Customer Flow
1. Register account → Login
2. Browse services → View service details
3. Book service:
   - Enter deceased person name
   - Enter relationship
   - Select booking date
   - Choose location (default or custom)
   - Add notes (optional)
   - Confirm booking
4. View booking history
5. Edit profile as needed

### Admin Flow
1. Login with admin credentials
2. Access admin dashboard
3. Manage bookings:
   - View all bookings
   - Update booking status
   - See detailed booking information
4. View all customers
5. View all services

## Security Features
- ✅ Password hashing
- ✅ JWT token authentication
- ✅ Role-based access control
- ✅ Input validation
- ✅ Secure API endpoints

## Future Enhancements
- Payment integration
- Push notifications
- Email notifications
- Image upload for services
- Advanced search and filters
- Booking calendar view
- Reports and analytics
- Multi-language support

