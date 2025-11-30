const mongoose = require('mongoose');
const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');

dotenv.config();

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/sabbebasta';

async function importDatabase() {
  try {
    // Get export file path from command line argument or find latest
    let exportFile = process.argv[2];
    
    if (!exportFile) {
      const exportDir = path.join(__dirname, '../database-export');
      if (!fs.existsSync(exportDir)) {
        console.error('Error: No export file specified and database-export directory not found.');
        console.error('Usage: node import-database.js <path-to-export-file.json>');
        process.exit(1);
      }
      
      const files = fs.readdirSync(exportDir)
        .filter(f => f.endsWith('.json'))
        .map(f => path.join(exportDir, f))
        .sort((a, b) => fs.statSync(b).mtime - fs.statSync(a).mtime);
      
      if (files.length === 0) {
        console.error('Error: No export files found in database-export directory.');
        process.exit(1);
      }
      
      exportFile = files[0];
      console.log(`Using latest export file: ${exportFile}`);
    }

    if (!fs.existsSync(exportFile)) {
      console.error(`Error: Export file not found: ${exportFile}`);
      process.exit(1);
    }

    console.log('Reading export file...');
    const exportData = JSON.parse(fs.readFileSync(exportFile, 'utf8'));
    
    console.log(`Database: ${exportData.database}`);
    console.log(`Exported at: ${exportData.exportedAt}\n`);

    await mongoose.connect(MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log('Connected to MongoDB');
    console.log('Importing database...\n');

    const db = mongoose.connection.db;

    for (const [collectionName, documents] of Object.entries(exportData.collections)) {
      if (documents.length === 0) {
        console.log(`Skipping empty collection: ${collectionName}`);
        continue;
      }

      console.log(`Importing collection: ${collectionName}`);
      
      // Clear existing data
      await db.collection(collectionName).deleteMany({});
      
      // Insert documents
      if (documents.length > 0) {
        await db.collection(collectionName).insertMany(documents);
        console.log(`  ✓ Imported ${documents.length} documents to ${collectionName}`);
      }
    }

    console.log('\n✓ Database imported successfully!');
    console.log('\nYou can now start the server with: npm run dev');
    
    process.exit(0);
  } catch (error) {
    console.error('Error importing database:', error);
    process.exit(1);
  }
}

importDatabase();

