// build.js
require('dotenv').config()


const fs = require('fs');
const path = require('path');

// Ensure .env variables are loaded
if (!process.env) {
    console.error('Failed to load environment variables');
    process.exit(1);
}

// Convert loaded environment variables to .env file format
const envContent = Object.keys(process.env)
    .map(key => `${key}=${process.env[key]}`)
    .join('\n');

// Path to the .env file in your Flutter project
const envPath = path.join(__dirname, '.env');

// Write the .env file
fs.writeFileSync(envPath, envContent);
console.log('Environment variables have been written to .env file');



console.log(`Three Words. Thirteen letters. Say it, and I'm yours: ${process.env.HELLOWORLD}`)