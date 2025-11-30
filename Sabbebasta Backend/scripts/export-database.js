const mongoose = require('mongoose');
const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');

dotenv.config();

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/sabbebasta';

async function exportDatabase() {
  try {
    await mongoose.connect(MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log('Connected to MongoDB');
    console.log('Exporting database...\n');

    const db = mongoose.connection.db;
    const collections = await db.listCollections().toArray();
    
    const exportDir = path.join(__dirname, '../database-export');
    if (!fs.existsSync(exportDir)) {
      fs.mkdirSync(exportDir, { recursive: true });
    }

    const exportData = {
      exportedAt: new Date().toISOString(),
      database: 'sabbebasta',
      collections: {}
    };

    for (const collection of collections) {
      const collectionName = collection.name;
      console.log(`Exporting collection: ${collectionName}`);
      
      const data = await db.collection(collectionName).find({}).toArray();
      exportData.collections[collectionName] = data;
      
      console.log(`  ✓ Exported ${data.length} documents from ${collectionName}`);
    }

    const exportFile = path.join(exportDir, `sabbebasta-export-${Date.now()}.json`);
    fs.writeFileSync(exportFile, JSON.stringify(exportData, null, 2));
    
    console.log(`\n✓ Database exported successfully to: ${exportFile}`);
    console.log(`\nYou can copy this file to your new device and use import-database.js to restore it.`);
    
    process.exit(0);
  } catch (error) {
    console.error('Error exporting database:', error);
    process.exit(1);
  }
}

exportDatabase();

