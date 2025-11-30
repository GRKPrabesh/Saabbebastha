const express = require('express');
const router = express.Router();
const Booking = require('../models/Booking');
const Service = require('../models/Service');
const { authenticate, isAdmin } = require('../middleware/auth');
const { body, validationResult } = require('express-validator');

// @route   GET /api/bookings
// @desc    Get all bookings (admin) or user's bookings (customer)
// @access  Private
router.get('/', authenticate, async (req, res) => {
  try {
    let bookings;

    if (req.user.role === 'admin') {
      // Admin can see all bookings
      bookings = await Booking.find()
        .populate('user', 'firstName lastName email phone')
        .populate('service', 'title price duration')
        .populate('assignedStaff', 'firstName lastName email phone')
        .sort({ createdAt: -1 });
    } else {
      // Customer can only see their own bookings
      bookings = await Booking.find({ user: req.user._id })
        .populate('service', 'title price duration imageUrl')
        .populate('assignedStaff', 'firstName lastName email phone')
        .sort({ createdAt: -1 });
    }

    res.json(bookings);
  } catch (error) {
    console.error('Get bookings error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET /api/bookings/:id
// @desc    Get booking by ID
// @access  Private
router.get('/:id', authenticate, async (req, res) => {
  try {
      const booking = await Booking.findById(req.params.id)
      .populate('user', 'firstName lastName email phone')
      .populate('service', 'title price duration imageUrl')
      .populate('assignedStaff', 'firstName lastName email phone');

    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    // Check if user has access to this booking
    if (req.user.role !== 'admin' && booking.user._id.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: 'Access denied' });
    }

    res.json(booking);
  } catch (error) {
    console.error('Get booking error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   POST /api/bookings
// @desc    Create a new booking
// @access  Private (Customer)
router.post(
  '/',
  authenticate,
  [
    body('service').notEmpty().withMessage('Service ID is required'),
    body('bookingDate').notEmpty().withMessage('Booking date is required'),
  ],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const { service, bookingDate, notes, deceasedName, relationship, customLocation } = req.body;

      // Verify service exists
      const serviceData = await Service.findById(service);
      if (!serviceData) {
        return res.status(404).json({ message: 'Service not found' });
      }

      // Create booking
      const booking = new Booking({
        user: req.user._id,
        service,
        bookingDate: new Date(bookingDate),
        totalAmount: serviceData.price,
        notes: notes || '',
        deceasedName: deceasedName || '',
        relationship: relationship || '',
        customLocation: customLocation || null,
      });

      await booking.save();

      // Populate and return
      await booking.populate('service', 'title price duration imageUrl');

      res.status(201).json(booking);
    } catch (error) {
      console.error('Create booking error:', error);
      res.status(500).json({ message: 'Server error' });
    }
  }
);

// @route   PUT /api/bookings/:id/status
// @desc    Update booking status (Admin only)
// @access  Private (Admin)
router.put(
  '/:id/status',
  authenticate,
  isAdmin,
  [body('status').isIn(['pending', 'confirmed', 'completed', 'cancelled']).withMessage('Invalid status')],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const updateData = { status: req.body.status, updatedAt: Date.now() };
      if (req.body.assignedStaff !== undefined) {
        updateData.assignedStaff = req.body.assignedStaff || null;
      }

      const booking = await Booking.findByIdAndUpdate(
        req.params.id,
        updateData,
        { new: true }
      )
        .populate('user', 'firstName lastName email phone')
        .populate('service', 'title price duration')
        .populate('assignedStaff', 'firstName lastName email phone');

      if (!booking) {
        return res.status(404).json({ message: 'Booking not found' });
      }

      res.json(booking);
    } catch (error) {
      console.error('Update booking status error:', error);
      res.status(500).json({ message: 'Server error' });
    }
  }
);

// @route   DELETE /api/bookings/:id
// @desc    Cancel a booking
// @access  Private
router.delete('/:id', authenticate, async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);

    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    // Check if user has access
    if (req.user.role !== 'admin' && booking.user.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: 'Access denied' });
    }

    // Update status to cancelled instead of deleting
    booking.status = 'cancelled';
    booking.updatedAt = Date.now();
    await booking.save();

    res.json({ message: 'Booking cancelled successfully' });
  } catch (error) {
    console.error('Cancel booking error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;

