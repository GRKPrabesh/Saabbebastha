const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const app = express();

// Middleware - CORS configuration for Flutter web
app.use(cors({
  origin: '*', // Allow all origins for development
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: false,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/services', require('./routes/services'));
app.use('/api/bookings', require('./routes/bookings'));
app.use('/api/users', require('./routes/users'));
app.use('/api/staff', require('./routes/staff'));

// MongoDB Connection
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/sabbebasta';

// Disable Mongoose buffering - fail fast instead of timing out
mongoose.set('bufferCommands', false);

// Helper function to check MongoDB connection
const isMongoConnected = () => {
  return mongoose.connection.readyState === 1; // 1 = connected
};

// Export for use in routes
app.locals.isMongoConnected = isMongoConnected;

// Connect to MongoDB with retry logic
let reconnectAttempts = 0;
const MAX_RECONNECT_ATTEMPTS = 10;
const RECONNECT_INTERVAL = 5000; // 5 seconds

const connectDB = async () => {
  try {
    await mongoose.connect(MONGODB_URI, {
      serverSelectionTimeoutMS: 5000, // Fail fast after 5 seconds
      socketTimeoutMS: 45000,
    });
    console.log('✓ MongoDB Connected Successfully');
    reconnectAttempts = 0; // Reset on successful connection
  } catch (err) {
    reconnectAttempts++;
    
    if (reconnectAttempts === 1) {
      // Only show full message on first attempt
      console.error('✗ MongoDB Connection Error:', err.message);
      console.log('\n⚠️  MongoDB is not running. Please start MongoDB:');
      console.log('   Windows: Open Services and start "MongoDB" service');
      console.log('   Or run: net start MongoDB (as Administrator)');
      console.log('   Or install MongoDB and start it manually\n');
      console.log('⚠️  Server will continue running but database operations will fail.');
      console.log('   Attempting to reconnect automatically...\n');
    } else if (reconnectAttempts <= MAX_RECONNECT_ATTEMPTS) {
      console.log(`⚠️  Reconnection attempt ${reconnectAttempts}/${MAX_RECONNECT_ATTEMPTS}...`);
    } else {
      console.log(`\n⚠️  Stopped automatic reconnection after ${MAX_RECONNECT_ATTEMPTS} attempts.`);
      console.log('   Start MongoDB manually and the server will detect it on the next request.\n');
      return; // Stop trying
    }
    
    // Retry connection after interval
    setTimeout(() => {
      if (mongoose.connection.readyState === 0) { // Only retry if disconnected
        connectDB();
      }
    }, RECONNECT_INTERVAL);
  }
};

// Handle MongoDB connection events
mongoose.connection.on('disconnected', () => {
  console.log('⚠️  MongoDB disconnected. Attempting to reconnect...');
  reconnectAttempts = 0; // Reset counter on disconnect
  // Try to reconnect
  setTimeout(() => {
    if (mongoose.connection.readyState === 0) {
      connectDB();
    }
  }, RECONNECT_INTERVAL);
});

mongoose.connection.on('reconnected', () => {
  console.log('✓ MongoDB reconnected successfully');
  reconnectAttempts = 0;
});

mongoose.connection.on('error', (err) => {
  console.error('MongoDB connection error:', err.message);
});

// Start connection
connectDB();

// Health check endpoint
app.get('/api/health', (req, res) => {
  const mongoStatus = isMongoConnected() ? 'connected' : 'disconnected';
  res.json({ 
    status: 'OK', 
    message: 'Server is running',
    mongodb: mongoStatus,
    timestamp: new Date().toISOString()
  });
});

// 404 handler for API routes - must return JSON
app.use('/api/*', (req, res) => {
  res.status(404).json({ message: 'API endpoint not found', path: req.path });
});

// 404 handler for non-API routes
app.use((req, res) => {
  res.status(404).json({ message: 'Route not found', path: req.path });
});

// Error handler middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    message: err.message || 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Accessible at http://localhost:${PORT}`);
});

