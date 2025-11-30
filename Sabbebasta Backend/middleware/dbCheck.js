const mongoose = require('mongoose');

// Middleware to check if MongoDB is connected
const checkDBConnection = (req, res, next) => {
  if (mongoose.connection.readyState !== 1) {
    return res.status(503).json({
      message: 'Database is not available. Please start MongoDB and try again.',
      error: 'DATABASE_UNAVAILABLE',
      details: 'MongoDB connection is required for this operation.'
    });
  }
  next();
};

module.exports = { checkDBConnection };

