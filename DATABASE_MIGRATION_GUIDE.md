# Database Migration Guide

Complete guide for setting up the Sabbebasta project on a new device and managing database migration.

## Table of Contents
1. [Exporting Database from Current Device](#exporting-database-from-current-device)
2. [Setting Up on New Device](#setting-up-on-new-device)
3. [Importing Database to New Device](#importing-database-to-new-device)
4. [Alternative Methods](#alternative-methods)
5. [Troubleshooting](#troubleshooting)

---

## Exporting Database from Current Device

### Step 1: Export the Database

Run the export script to create a backup of your database:

```bash
cd "Sabbebasta Backend"
npm run export-db
```

This will:
- Connect to your MongoDB database
- Export all collections (users, services, bookings, etc.)
- Save the data to `database-export/sabbebasta-export-[timestamp].json`

### Step 2: Copy Files to New Device

Copy the following to your new device:
1. **Export file**: `Sabbebasta Backend/database-export/sabbebasta-export-*.json`
2. **Entire project folder**: Copy the whole project directory

You can use:
- USB drive
- Cloud storage (Google Drive, Dropbox, etc.)
- Network share
- Git repository (if using version control)

---

## Setting Up on New Device

### Step 1: Install Prerequisites

1. **Install Node.js** (v14 or higher)
   - Download from: https://nodejs.org/
   - Verify: `node --version`

2. **Install MongoDB**
   - Download from: https://www.mongodb.com/try/download/community
   - **Windows**: Install and MongoDB will run as a service
   - **Mac**: `brew install mongodb-community`
   - **Linux**: Follow MongoDB installation guide for your distribution

3. **Install Flutter** (for frontend)
   - Download from: https://flutter.dev/docs/get-started/install

### Step 2: Start MongoDB

**Windows:**
```powershell
# Run as Administrator
.\start-mongodb.ps1
```

Or manually:
```powershell
Start-Service -Name "MongoDB"
```

**Mac/Linux:**
```bash
# Start MongoDB service
sudo systemctl start mongod
# or
mongod
```

Verify MongoDB is running:
```bash
mongosh --eval "db.version()"
```

### Step 3: Set Up Backend

1. Navigate to backend directory:
```bash
cd "Sabbebasta Backend"
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file:
```bash
# Create .env file with:
PORT=5000
MONGODB_URI=mongodb://localhost:27017/sabbebasta
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
NODE_ENV=development
```

**Important**: Use the same `JWT_SECRET` from your original device if you want existing tokens to work, or generate a new one.

---

## Importing Database to New Device

### Option 1: Import from Export File (Recommended)

1. Place your export file in:
   ```
   Sabbebasta Backend/database-export/sabbebasta-export-*.json
   ```

2. Run the import script:
```bash
npm run import-db
```

Or specify the file path:
```bash
npm run import-db path/to/your/export-file.json
```

This will:
- Clear existing data in the database
- Import all collections from the export file
- Restore all users, services, bookings, etc.

### Option 2: Start Fresh with Seed Data

If you don't need existing data, you can start fresh:

```bash
npm run seed
```

This creates:
- Admin user: `admin` / `admin@123`
- Sample services (Electric Crematorium, Fire Burning, Burial Systems)

---

## Alternative Methods

### Method 1: Using MongoDB Native Tools

**Export (on current device):**
```bash
mongodump --db=sabbebasta --out=./database-backup
```

**Import (on new device):**
```bash
mongorestore --db=sabbebasta ./database-backup/sabbebasta
```

### Method 2: Using MongoDB Compass

1. **Export:**
   - Open MongoDB Compass
   - Connect to `mongodb://localhost:27017`
   - Select `sabbebasta` database
   - For each collection: Click collection → Export Collection → Choose JSON format

2. **Import:**
   - Connect to MongoDB on new device
   - Create `sabbebasta` database
   - For each collection: Click "+" → Import Collection → Select JSON file

### Method 3: Manual Collection Export/Import

**Export single collection:**
```bash
mongoexport --db=sabbebasta --collection=users --out=users.json
```

**Import single collection:**
```bash
mongoimport --db=sabbebasta --collection=users --file=users.json
```

---

## Complete Setup Checklist

### On New Device:

- [ ] Install Node.js
- [ ] Install MongoDB
- [ ] Start MongoDB service
- [ ] Copy project files to new device
- [ ] Run `npm install` in backend directory
- [ ] Create `.env` file with correct configuration
- [ ] Copy export file to `database-export/` folder
- [ ] Run `npm run import-db` to restore data
- [ ] Verify data: Check MongoDB Compass or run `npm run dev`
- [ ] Test login with admin credentials
- [ ] Set up Flutter frontend (if needed)
- [ ] Update API base URL in Flutter app

---

## Troubleshooting

### MongoDB Not Starting

**Windows:**
```powershell
# Check if service exists
Get-Service -Name "MongoDB"

# Start service manually
Start-Service -Name "MongoDB"

# Check MongoDB logs
# Usually in: C:\Program Files\MongoDB\Server\<version>\log\mongod.log
```

**Mac/Linux:**
```bash
# Check MongoDB status
sudo systemctl status mongod

# Start MongoDB
sudo systemctl start mongod

# Check if MongoDB is listening
netstat -an | grep 27017
```

### Connection Errors

1. **"Database is not available"**
   - Ensure MongoDB is running
   - Check `MONGODB_URI` in `.env` file
   - Verify MongoDB is accessible on port 27017

2. **"Authentication failed"**
   - If using authentication, update `MONGODB_URI` to include credentials:
   ```
   MONGODB_URI=mongodb://username:password@localhost:27017/sabbebasta
   ```

### Import/Export Issues

1. **Export file not found**
   - Ensure export file is in `database-export/` folder
   - Or provide full path: `npm run import-db "C:\path\to\file.json"`

2. **Import fails with duplicate key error**
   - The import script clears existing data first
   - If issues persist, manually drop the database:
   ```bash
   mongosh
   use sabbebasta
   db.dropDatabase()
   ```
   Then run import again

3. **Data not appearing after import**
   - Verify MongoDB connection
   - Check if database was created: `mongosh --eval "show dbs"`
   - Check collections: `mongosh sabbebasta --eval "show collections"`

### Port Already in Use

If port 5000 is already in use:
1. Change `PORT` in `.env` file
2. Update Flutter app's API base URL accordingly

---

## Quick Reference Commands

```bash
# Export database
npm run export-db

# Import database
npm run import-db

# Seed fresh database
npm run seed

# Start development server
npm run dev

# Start production server
npm start

# Check MongoDB connection
mongosh --eval "db.version()"

# List databases
mongosh --eval "show dbs"

# List collections in sabbebasta
mongosh sabbebasta --eval "show collections"

# Count documents in users collection
mongosh sabbebasta --eval "db.users.countDocuments()"
```

---

## Security Notes

1. **Never commit `.env` files** to version control
2. **Change JWT_SECRET** in production
3. **Use strong passwords** for admin accounts
4. **Backup regularly** using export scripts
5. **Secure MongoDB** in production (enable authentication)

---

## Need Help?

If you encounter issues:
1. Check MongoDB logs
2. Verify all environment variables are set correctly
3. Ensure MongoDB is running and accessible
4. Check network connectivity if using remote MongoDB
5. Review error messages in console output

