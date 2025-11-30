const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const { body, validationResult } = require('express-validator');
const User = require('../models/User');
const { authenticate } = require('../middleware/auth');

const JWT_SECRET = process.env.JWT_SECRET || 'your_super_secret_jwt_key_change_this_in_production';

// Helper to check MongoDB connection
const isMongoConnected = () => {
  return mongoose.connection.readyState === 1;
};

// Generate JWT token
const generateToken = (userId) => {
  return jwt.sign({ userId }, JWT_SECRET, { expiresIn: '7d' });
};

// @route   POST /api/auth/register
// @desc    Register a new user
// @access  Public
router.post(
  '/register',
  [
    body('firstName').trim().notEmpty().withMessage('First name is required'),
    body('lastName').trim().notEmpty().withMessage('Last name is required'),
    body('userName').trim().notEmpty().withMessage('Username is required'),
    body('email').isEmail().withMessage('Please enter a valid email'),
    body('phone').trim().notEmpty().withMessage('Phone number is required'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  ],
  async (req, res) => {
    try {
      // Check MongoDB connection first
      if (!isMongoConnected()) {
        return res.status(503).json({ 
          message: 'Database is not available. Please start MongoDB and try again.',
          error: 'DATABASE_UNAVAILABLE'
        });
      }

      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const { firstName, lastName, userName, email, phone, countryCode, password } = req.body;

      // Check if user already exists
      const existingUser = await User.findOne({
        $or: [{ email: email.toLowerCase() }, { userName: userName.toLowerCase() }],
      });

      if (existingUser) {
        return res.status(400).json({ message: 'User already exists with this email or username' });
      }

      // Create new user
      const user = new User({
        firstName,
        lastName,
        userName: userName.toLowerCase(),
        email: email.toLowerCase(),
        phone,
        countryCode: countryCode || '+1',
        password,
        role: 'customer',
      });

      await user.save();

      // Generate token
      const token = generateToken(user._id);

      res.status(201).json({
        message: 'User registered successfully',
        token,
        user: {
          id: user._id,
          firstName: user.firstName,
          lastName: user.lastName,
          userName: user.userName,
          email: user.email,
          phone: user.phone,
          role: user.role,
        },
      });
    } catch (error) {
      console.error('Registration error:', error);
      // Check if it's a MongoDB connection error
      if (error.name === 'MongooseError' || error.message.includes('buffering')) {
        return res.status(503).json({ 
          message: 'Database is not available. Please start MongoDB and try again.',
          error: 'DATABASE_UNAVAILABLE'
        });
      }
      res.status(500).json({ message: 'Server error during registration' });
    }
  }
);

// @route   POST /api/auth/login
// @desc    Login user
// @access  Public
router.post(
  '/login',
  [
    body('email').notEmpty().withMessage('Email or username is required'),
    body('password').notEmpty().withMessage('Password is required'),
  ],
  async (req, res) => {
    try {
      // Check MongoDB connection first
      if (!isMongoConnected()) {
        return res.status(503).json({ 
          message: 'Database is not available. Please start MongoDB and try again.',
          error: 'DATABASE_UNAVAILABLE'
        });
      }

      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const { email, password } = req.body;
      const loginIdentifier = email.toLowerCase();

      // Find user by email or username
      const user = await User.findOne({
        $or: [
          { email: loginIdentifier },
          { userName: loginIdentifier }
        ],
      });

      if (!user) {
        return res.status(401).json({ message: 'Invalid credentials' });
      }

      // Check password
      const isMatch = await user.comparePassword(password);

      if (!isMatch) {
        return res.status(401).json({ message: 'Invalid credentials' });
      }

      // Generate token
      const token = generateToken(user._id);

      res.json({
        message: 'Login successful',
        token,
        user: {
          id: user._id,
          firstName: user.firstName,
          lastName: user.lastName,
          userName: user.userName,
          email: user.email,
          phone: user.phone,
          role: user.role,
        },
      });
    } catch (error) {
      console.error('Login error:', error);
      // Check if it's a MongoDB connection error
      if (error.name === 'MongooseError' || error.message.includes('buffering')) {
        return res.status(503).json({ 
          message: 'Database is not available. Please start MongoDB and try again.',
          error: 'DATABASE_UNAVAILABLE'
        });
      }
      res.status(500).json({ message: 'Server error during login' });
    }
  }
);

// @route   GET /api/auth/me
// @desc    Get current user
// @access  Private
router.get('/me', authenticate, async (req, res) => {
  try {
    // Check MongoDB connection first
    if (!isMongoConnected()) {
      return res.status(503).json({ 
        message: 'Database is not available. Please start MongoDB and try again.',
        error: 'DATABASE_UNAVAILABLE'
      });
    }

    res.json({
      user: {
        id: req.user._id,
        firstName: req.user.firstName,
        lastName: req.user.lastName,
        userName: req.user.userName,
        email: req.user.email,
        phone: req.user.phone,
        role: req.user.role,
      },
    });
  } catch (error) {
    console.error('Get user error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;

