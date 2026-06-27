require('dotenv').config();
const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const rateLimit = require('express-rate-limit');
const crypto = require('crypto');
const http = require('http');
const { Server } = require('socket.io');

const User = require('./models/User');
const Otp = require('./models/Otp');

const dns = require("dns");
dns.setDefaultResultOrder("ipv4first");

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*", // Adjust in production
    methods: ["GET", "POST"]
  }
});

app.set("trust proxy",1);
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Initialize Community Chat Socket Service
const { initCommunityChatService } = require('./services/communityChatService');
initCommunityChatService(io);

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
    const { email, location = 'Mumbai, Maharashtra', deviceId = 'MM-X900-STDT' } = req.body;
    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }
    
    // Generate a 6-digit OTP and dynamic variables for the email
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const internalRef = `MM-DT-${Math.floor(1000 + Math.random() * 9000)}`;
    const currentDate = new Date().toLocaleDateString('en-US', {
      month: 'long',
      day: 'numeric',
      year: 'numeric'
    }).toUpperCase();
    
    // Save/Update OTP in database
    await Otp.findOneAndUpdate(
      { email },
      { otp, createdAt: new Date() }, // Update createdAt to reset TTL
      { upsert: true, returnDocument: 'after' }
    );
    
    // Send email
    const emailData = {
      sender: { name: 'MindMate Security', email: 'atharvanair09.ns@gmail.com' },
      to: [{ email: email }],
      subject: 'Your Verification Code',
      textContent: `Your verification code is: ${otp}. It will expire in 5 minutes.`,
      htmlContent: `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Security Clearance</title>
    <link href="https://fonts.googleapis.com/css2?family=Anton&family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: #f4f1ea;
            font-family: 'Space Grotesk', sans-serif;
            display: flex;
            justify-content: center;
            padding: 20px;
        }

        .container {
            width: 320px;
            border: 2px solid #000;
            padding: 20px;
            background-color: #fff;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .logo {
            width: 40px;
            height: 40px;
            border: 2px solid #000;
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-template-rows: 1fr 1fr;
        }

        .logo div { border: 1px solid #000; }
        .logo div:nth-child(1) { background: #000; }
        .logo div:nth-child(2) { background: #0000ff; }
        .logo div:nth-child(4) { background: #ffff00; }

        .ref { font-size: 10px; font-weight: 500; }

        hr { border: 0; border-top: 2px solid #000; margin-bottom: 20px; }

        h1 {
            font-family: 'Anton', sans-serif;
            font-size: 42px;
            line-height: 1;
            margin-bottom: 15px;
        }

        .date { font-size: 12px; margin-bottom: 25px; border-left: 3px solid #8e8e52; padding-left: 8px; }

        .verification-box {
            border: 2px solid #000;
            padding: 20px;
            margin-bottom: 20px;
        }

        h2 { font-size: 20px; margin-bottom: 15px; }

        .text { font-size: 12px; margin-bottom: 20px; line-height: 1.4; }

        .code {
            background: #000;
            color: #fff;
            font-size: 32px;
            text-align: center;
            padding: 15px;
            letter-spacing: 10px;
            margin-bottom: 20px;
        }

        .confirm-btn {
            background: #ffe600;
            border: 2px solid #000;
            width: 100%;
            padding: 15px;
            font-family: 'Space Grotesk', sans-serif;
            font-weight: 700;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
        }

        .location-info { font-size: 10px; margin-bottom: 20px; }

        .crisis {
            background: #c92a2a;
            color: #fff;
            padding: 15px;
            text-align: center;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .footer-bar {
            background: #000;
            color: #fff;
            padding: 15px;
            font-size: 10px;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="header">
            <div class="logo">
                <div></div><div></div><div></div><div></div>
            </div>
            <div class="ref">INTERNAL REF: ${internalRef}</div>
        </div>
        <hr>
        <h1>SECURITY CLEARANCE REQUIRED</h1>
        <div class="date">DATE: ${currentDate}</div>

        <div class="verification-box">
            <h2>IDENTITY VERIFICATION</h2>
            <p class="text">Identity verification in progress. Do not share this code with anyone. This is the first and last time we see your email.</p>
            <div class="code">${otp}</div>
            <button class="confirm-btn">CONFIRM IDENTITY <span>&rarr;</span></button>
        </div>

        <div class="location-info">
            <p>LOCATION TRACKED: ${location.toUpperCase()}</p>
            <p>DEVICE ID: ${deviceId.toUpperCase()}</p>
        </div>

        <div class="crisis">
            CRISIS HELP?<br>
            IMMEDIATE ASSISTANCE AVAILABLE 24/7
        </div>

        <div class="footer-bar">
            <p>MINDMATE // NO PRETENDING, NO DATA MINING.</p>
            <p style="margin-top: 10px;">PRIVACY PROTOCOL. TERMS OF SERVICE. UNSUBSCRIBE</p>
            <p style="margin-top: 15px;">&copy; 2026 MINDMATE ARCHITECTURE. BUILT FOR RESILIENCE. ALL RIGHTS RESERVED.</p>
        </div>
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

// ─── JWT middleware ────────────────────────────────────────────────────────────
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // "Bearer <token>"
  if (!token) return res.status(401).json({ error: 'Missing auth token' });

  jwt.verify(token, JWT_SECRET, (err, payload) => {
    if (err) return res.status(403).json({ error: 'Invalid or expired token' });
    req.uuid = payload.uuid;
    next();
  });
}

// ─── PATCH /api/user/profile/setup — first-time username + avatar setup ───────
// Username is written ONLY if not already set (immutable after first save).
app.patch('/api/user/profile/setup', authenticateToken, async (req, res) => {
  try {
    const { username, avatarLabel, avatarImageUrl } = req.body;

    if (!username || !avatarLabel) {
      return res.status(400).json({ error: 'username and avatarLabel are required' });
    }

    // Basic server-side username validation
    const trimmed = username.trim();
    if (trimmed.length < 3 || trimmed.length > 24) {
      return res.status(400).json({ error: 'Username must be 3–24 characters' });
    }
    if (!/^[a-zA-Z0-9_]+$/.test(trimmed)) {
      return res.status(400).json({ error: 'Username may only contain letters, numbers and underscores' });
    }

    const existing = await User.findOne({ uuid: req.uuid });
    if (!existing) return res.status(404).json({ error: 'User not found' });

    // Enforce immutability: only write username if it has never been set
    const updateFields = { avatarLabel };
    if (!existing.username) {
      updateFields.username = trimmed;
    }
    // Persist custom photo if provided; clear it if explicitly set to null
    if (avatarImageUrl !== undefined) {
      updateFields.avatarImageUrl = avatarImageUrl || null;
    }

    const user = await User.findOneAndUpdate(
      { uuid: req.uuid },
      updateFields,
      { new: true }
    );

    res.json({
      message: 'Profile saved',
      username: user.username,
      avatarLabel: user.avatarLabel,
      avatarImageUrl: user.avatarImageUrl ?? null,
    });
  } catch (error) {
    console.error('Error saving profile setup:', error);
    res.status(500).json({ error: 'Failed to save profile' });
  }
});

// ─── PATCH /api/user/profile/avatar — update avatar only (always allowed) ─────
// Accepts avatarLabel (required) and optional avatarImageUrl (base64 data URL or null).
app.patch('/api/user/profile/avatar', authenticateToken, async (req, res) => {
  try {
    const { avatarLabel, avatarImageUrl } = req.body;

    if (!avatarLabel) {
      return res.status(400).json({ error: 'avatarLabel is required' });
    }

    const updateFields = { avatarLabel };
    // If avatarImageUrl is provided in the request body (even as null), persist it
    if (avatarImageUrl !== undefined) {
      updateFields.avatarImageUrl = avatarImageUrl || null;
    }

    const user = await User.findOneAndUpdate(
      { uuid: req.uuid },
      updateFields,
      { new: true }
    );

    if (!user) return res.status(404).json({ error: 'User not found' });

    res.json({
      message: 'Avatar updated',
      avatarLabel: user.avatarLabel,
      avatarImageUrl: user.avatarImageUrl ?? null,
    });
  } catch (error) {
    console.error('Error updating avatar:', error);
    res.status(500).json({ error: 'Failed to update avatar' });
  }
});

// ─── PATCH /api/user/profile/avatar-image — upload/clear custom photo ─────────
// Body: { avatarImageUrl: '<base64 data URL>' } or { avatarImageUrl: null } to clear.
app.patch('/api/user/profile/avatar-image', authenticateToken, async (req, res) => {
  try {
    const { avatarImageUrl } = req.body;

    const user = await User.findOneAndUpdate(
      { uuid: req.uuid },
      { avatarImageUrl: avatarImageUrl || null },
      { new: true }
    );

    if (!user) return res.status(404).json({ error: 'User not found' });

    res.json({
      message: 'Avatar image updated',
      avatarImageUrl: user.avatarImageUrl ?? null,
    });
  } catch (error) {
    console.error('Error updating avatar image:', error);
    res.status(500).json({ error: 'Failed to update avatar image' });
  }
});

// ─── GET /api/user/profile — fetch username + avatarLabel + avatarImageUrl ─────
app.get('/api/user/profile', authenticateToken, async (req, res) => {
  try {
    const user = await User.findOne({ uuid: req.uuid }, 'username avatarLabel avatarImageUrl');
    if (!user) return res.status(404).json({ error: 'User not found' });

    res.json({
      username: user.username,
      avatarLabel: user.avatarLabel,
      avatarImageUrl: user.avatarImageUrl ?? null,
    });
  } catch (error) {
    console.error('Error fetching profile:', error);
    res.status(500).json({ error: 'Failed to fetch profile' });
  }
});

const journalRoutes = require('./routes/journalRoutes');
const chatRoutes = require('./routes/chatRoutes');
const voiceRoutes = require('./routes/voice.routes');

app.use('/api/v1/journal', journalRoutes);
app.use('/api/v1/chat', chatRoutes);
app.use('/api/v1/voice', voiceRoutes);

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
