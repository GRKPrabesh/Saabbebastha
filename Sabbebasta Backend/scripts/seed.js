const mongoose = require('mongoose');
const dotenv = require('dotenv');
const User = require('../models/User');
const Service = require('../models/Service');

dotenv.config();

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/sabbebasta';

async function seedDatabase() {
  try {
    await mongoose.connect(MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log('Connected to MongoDB');

    // Clear existing data (optional - comment out if you want to keep existing data)
    // await User.deleteMany({});
    // await Service.deleteMany({});

    // Create admin user
    const adminExists = await User.findOne({ role: 'admin' });
    if (!adminExists) {
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
      console.log('Admin user created: admin / admin@123');
    } else {
      console.log('Admin user already exists');
    }

    // Create sample services
    const services = [
      {
        title: 'Electric Crematorium',
        description: 'An electric crematorium is a machine that uses electricity to cremate a body, typically in 45 minutes to a few hours, depending on the model. It is an eco-friendly alternative to traditional wooden pyres, which is cost-effective and reduces environmental pollution to high levels.',
        price: 250,
        duration: '45 mins',
        rating: 4.5,
        imageUrl: 'https://via.placeholder.com/400x300/E0E0E0/757575?text=Electric+Crematorium',
        serviceType: 'electric_crematorium',
        location: {
          latitude: 28.6139,
          longitude: 77.2090,
          address: 'Delhi Crematorium Services, New Delhi',
        },
        isActive: true,
      },
      {
        title: 'Fire Burning',
        description: 'Burning dead bodies is a practice in both funerary rites, like the Hindu cremation ceremony, and in criminal acts, where fire is used to conceal evidence. The process can take several hours depending on the size and condition of the body.',
        price: 500,
        duration: '3-4 hours',
        rating: 4.5,
        imageUrl: 'https://via.placeholder.com/400x300/E0E0E0/757575?text=Fire+Burning',
        serviceType: 'fire_burning',
        location: {
          latitude: 28.6280,
          longitude: 77.2160,
          address: 'Traditional Fire Services, New Delhi',
        },
        isActive: true,
      },
      {
        title: 'Burial Systems',
        description: 'Buried dead bodies are bodies that have been placed into the ground, a practice known as burial, which has been performed by humans for tens of thousands of years. Reasons for burial include respect for the deceased, religious beliefs, and cultural practices.',
        price: 100,
        duration: '1-2 hours',
        rating: 4.5,
        imageUrl: 'https://via.placeholder.com/400x300/E0E0E0/757575?text=Burial+Systems',
        serviceType: 'burial_systems',
        location: {
          latitude: 28.6000,
          longitude: 77.2000,
          address: 'Burial Ground Services, New Delhi',
        },
        isActive: true,
      },
    ];

    for (const serviceData of services) {
      const existingService = await Service.findOne({ title: serviceData.title });
      if (!existingService) {
        const service = new Service(serviceData);
        await service.save();
        console.log(`Service created: ${serviceData.title}`);
      } else {
        console.log(`Service already exists: ${serviceData.title}`);
      }
    }

    console.log('Database seeding completed!');
    process.exit(0);
  } catch (error) {
    console.error('Error seeding database:', error);
    process.exit(1);
  }
}

seedDatabase();

