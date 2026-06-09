require('dotenv').config();
const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const rateLimit = require('express-rate-limit');
const crypto = require('crypto');

const User = require('./models/User');
const Otp = require('./models/Otp');

const dns = require("dns");
dns.setDefaultResultOrder("ipv4first");

const app = express();
app.set("trust proxy",1);
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'super-secret-key-for-mindmate';

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('Connected to MongoDB Atlas'))
  .catch(err => console.error('MongoDB connection error:', err));

// Brevo API Key
const BREVO_API_KEY = process.env.BREVO_API_KEY || process.env.RESEND_API_KEY;

// Rate limiter for OTP requests: max 3 requests per 5 minutes
const otpLimiter = rateLimit({
  windowMs: 5 * 60 * 1000, // 5 minutes
  max: 3,
  message: { error: 'Too many OTP requests from this IP, please try again after 5 minutes' }
});

app.post('/api/auth/send-otp', otpLimiter, async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }
    
    // Generate a 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    
    // Save/Update OTP in database
    await Otp.findOneAndUpdate(
      { email },
      { otp, createdAt: new Date() }, // Update createdAt to reset TTL
      { upsert: true, returnDocument: 'after' }
    );
    
    // Send email
    const emailData = {
      sender: { name: 'MindMate Security', email: 'noreply@mindmate.app' },
      to: [{ email: email }],
      subject: 'Your Verification Code',
      textContent: `Your verification code is: ${otp}. It will expire in 5 minutes.`,
      htmlContent: `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Your One-Time Code</title>
</head>
<body style="margin:0;padding:0;background-color:#f0faf4;font-family:sans-serif;">
  <div style="max-width:480px;margin:20px auto;background:#fff;padding:30px;border-radius:20px;text-align:center;">
    <h1 style="color:#111;">Your verification code</h1>
    <div style="font-size:32px;font-weight:bold;letter-spacing:5px;margin:20px 0;padding:15px;border:2px dashed #3dba7b;display:inline-block;">
      ${otp}
    </div>
    <p style="color:#555;">This code will expire in 20 minutes. Please do not share it with anyone.</p>
  </div>
</body>
</html>`
    };

    try {
      const brevoRes = await fetch('https://api.brevo.com/v3/smtp/email', {
        method: 'POST',
        headers: {
          'accept': 'application/json',
          'api-key': BREVO_API_KEY,
          'content-type': 'application/json'
        },
        body: JSON.stringify(emailData)
      });
      
      const brevoData = await brevoRes.json();
      
      if (!brevoRes.ok) {
        console.error('Brevo API Error:', brevoData);
        throw new Error(brevoData.message || 'Failed to send email via Brevo');
      }

      console.log(`OTP sent to ${email}`);
      res.json({ message: 'OTP sent successfully' });
    } catch (error) {
      console.error('Brevo Error:', error);
      throw new Error(error.message || 'Failed to send email via Brevo');
    }
  } catch (error) {
    console.error('Error sending OTP:', error);
    res.status(500).json({ error: 'Failed to send OTP' });
  }
});

app.post('/api/auth/verify-otp', async (req, res) => {
  try {
    const { email, otp } = req.body;
    
    if (!email || !otp) {
      return res.status(400).json({ error: 'Email and OTP are required' });
    }
    
    const record = await Otp.findOne({ email });
    if (!record || record.otp !== otp) {
      return res.status(401).json({ error: 'Invalid or expired OTP' });
    }
        
    // Delete OTP immediately after verification
    await Otp.deleteOne({ email });
    res.json({ message: 'Verified successfully' });
  } catch (error) {
    console.error('Error verifying OTP:', error);
    res.status(500).json({ error: 'Failed to verify OTP' });
  }
});

app.post('/api/auth/register', async (req, res) => {
  try {
    const { uuid, recoveryPhraseHash } = req.body;
    
    if (!uuid || !recoveryPhraseHash) {
      return res.status(400).json({ error: 'UUID and Recovery Phrase Hash are required' });
    }
    
    const existing = await User.findOne({ uuid });
    if (existing) {
      return res.status(400).json({ error: 'User already exists' });
    }
    
    const user = new User({ uuid, recoveryPhraseHash });
    await user.save();
    
    const token = jwt.sign({ uuid }, JWT_SECRET, { expiresIn: '30d' });
    res.json({ message: 'Registered successfully', token });
  } catch (error) {
    console.error('Error registering:', error);
    res.status(500).json({ error: 'Failed to register user' });
  }
});

app.post('/api/auth/recover', async (req, res) => {
  try {
    const { recoveryPhraseHash } = req.body;
    
    if (!recoveryPhraseHash) {
      return res.status(400).json({ error: 'Recovery Phrase Hash is required' });
    }
    
    const user = await User.findOne({ recoveryPhraseHash });
    if (!user) {
      return res.status(401).json({ error: 'Invalid recovery phrase' });
    }
    
    const token = jwt.sign({ uuid: user.uuid }, JWT_SECRET, { expiresIn: '30d' });
    res.json({ message: 'Recovered successfully', token, uuid: user.uuid });
  } catch (error) {
    console.error('Error recovering:', error);
    res.status(500).json({ error: 'Failed to recover account' });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
