const express = require('express');
const router = express.Router();
const Staff = require('../models/Staff');
const { authenticate, isAdmin } = require('../middleware/auth');
const { body, validationResult } = require('express-validator');

// @route   GET /api/staff
// @desc    Get all staff members (Admin only)
// @access  Private (Admin)
router.get('/', authenticate, isAdmin, async (req, res) => {
  try {
    const staff = await Staff.find().sort({ createdAt: -1 });
    res.json(staff);
  } catch (error) {
    console.error('Get staff error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET /api/staff/:id
// @desc    Get staff by ID
// @access  Private (Admin)
router.get('/:id', authenticate, isAdmin, async (req, res) => {
  try {
    const staff = await Staff.findById(req.params.id);
    if (!staff) {
      return res.status(404).json({ message: 'Staff not found' });
    }
    res.json(staff);
  } catch (error) {
    console.error('Get staff error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   POST /api/staff
// @desc    Create a new staff member
// @access  Private (Admin)
router.post(
  '/',
  authenticate,
  isAdmin,
  [
    body('firstName').trim().notEmpty().withMessage('First name is required'),
    body('lastName').trim().notEmpty().withMessage('Last name is required'),
    body('email').isEmail().withMessage('Please enter a valid email'),
    body('phone').trim().notEmpty().withMessage('Phone number is required'),
  ],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const { firstName, lastName, email, phone, role, specialization } = req.body;

      // Check if staff with email already exists
      const existingStaff = await Staff.findOne({ email: email.toLowerCase() });
      if (existingStaff) {
        return res.status(400).json({ message: 'Staff with this email already exists' });
      }

      const staff = new Staff({
        firstName,
        lastName,
        email: email.toLowerCase(),
        phone,
        role: role || 'staff',
        specialization: specialization || '',
      });

      await staff.save();
      res.status(201).json(staff);
    } catch (error) {
      console.error('Create staff error:', error);
      if (error.code === 11000) {
        return res.status(400).json({ message: 'Staff with this email already exists' });
      }
      res.status(500).json({ message: 'Server error' });
    }
  }
);

// @route   PUT /api/staff/:id
// @desc    Update staff member
// @access  Private (Admin)
router.put(
  '/:id',
  authenticate,
  isAdmin,
  [
    body('firstName').optional().trim().notEmpty().withMessage('First name cannot be empty'),
    body('lastName').optional().trim().notEmpty().withMessage('Last name cannot be empty'),
    body('email').optional().isEmail().withMessage('Please enter a valid email'),
  ],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const updateData = { ...req.body, updatedAt: Date.now() };
      if (updateData.email) {
        updateData.email = updateData.email.toLowerCase();
      }

      const staff = await Staff.findByIdAndUpdate(req.params.id, updateData, {
        new: true,
        runValidators: true,
      });

      if (!staff) {
        return res.status(404).json({ message: 'Staff not found' });
      }

      res.json(staff);
    } catch (error) {
      console.error('Update staff error:', error);
      res.status(500).json({ message: 'Server error' });
    }
  }
);

// @route   DELETE /api/staff/:id
// @desc    Delete staff member (soft delete by setting isActive to false)
// @access  Private (Admin)
router.delete('/:id', authenticate, isAdmin, async (req, res) => {
  try {
    const staff = await Staff.findByIdAndUpdate(
      req.params.id,
      { isActive: false, updatedAt: Date.now() },
      { new: true }
    );

    if (!staff) {
      return res.status(404).json({ message: 'Staff not found' });
    }

    res.json({ message: 'Staff deactivated successfully', staff });
  } catch (error) {
    console.error('Delete staff error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;

