const mongoose = require('mongoose');
const dotenv = require('dotenv');
const User = require('../models/User');

dotenv.config();

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/sabbebasta';

async function addAdmin() {
  try {
    await mongoose.connect(MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log('Connected to MongoDB\n');

    // Check if admin already exists
    const existingAdmin = await User.findOne({
      $or: [
        { email: 'admin' },
        { userName: 'admin' },
        { role: 'admin' }
      ]
    });

    if (existingAdmin) {
      console.log('⚠ Admin user already exists!');
      console.log(`   Email: ${existingAdmin.email}`);
      console.log(`   Username: ${existingAdmin.userName}`);
      console.log(`   Role: ${existingAdmin.role}`);
      
      // Update existing admin
      existingAdmin.password = 'admin@123';
      existingAdmin.email = 'admin';
      existingAdmin.userName = 'admin';
      await existingAdmin.save();
      
      console.log('\n✓ Admin user updated successfully!');
      console.log('   Email/Username: admin');
      console.log('   Password: admin@123');
    } else {
      // Create new admin user
      const admin = new User({
        firstName: 'Admin',
        lastName: 'User',
        userName: 'admin',
        email: 'admin',
        phone: '1234567890',
        countryCode: '+1',
        password: 'admin@123',
        role: 'admin',
      });

      await admin.save();
      
      console.log('✓ Admin user created successfully!');
      console.log('   Email/Username: admin');
      console.log('   Password: admin@123');
    }
    
    console.log('\nYou can now login with these credentials.');
    
    process.exit(0);
  } catch (error) {
    console.error('\n✗ Error creating admin user:', error.message);
    if (error.code === 11000) {
      console.error('   A user with this email or username already exists.');
    }
    process.exit(1);
  }
}

addAdmin();

