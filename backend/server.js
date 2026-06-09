require('dotenv').config();
const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const rateLimit = require('express-rate-limit');
const brevo = require('@getbrevo/brevo');
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

// Configure Brevo
let defaultClient = brevo.ApiClient.instance;
let apiKey = defaultClient.authentications['api-key'];
apiKey.apiKey = process.env.BREVO_API_KEY || process.env.RESEND_API_KEY; // fallback if user hasn't updated .env yet
let apiInstance = new brevo.TransactionalEmailsApi();

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
    let sendSmtpEmail = new brevo.SendSmtpEmail();
    sendSmtpEmail.subject = 'Your Verification Code';
    sendSmtpEmail.textContent = `Your verification code is: ${otp}. It will expire in 5 minutes.`;
    sendSmtpEmail.sender = { name: 'MindMate Security', email: 'noreply@mindmate.app' };
    sendSmtpEmail.to = [{ email: email }];
    sendSmtpEmail.htmlContent = `<b><!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <title>Your One-Time Code</title>
  <!--[if mso]>
  <noscript><xml><o:OfficeDocumentSettings><o:PixelsPerInch>96</o:PixelsPerInch></o:OfficeDocumentSettings></xml></noscript>
  <![endif]-->
  <style>
    body, table, td, a { -webkit-text-size-adjust:100%; -ms-text-size-adjust:100%; }
    table, td { mso-table-lspace:0pt; mso-table-rspace:0pt; }
    body { margin:0!important; padding:0!important; background-color:#f0faf4; }
  </style>
</head>
<body style="margin:0;padding:0;background-color:#f0faf4;font-family:Georgia,'Times New Roman',serif;">

  <!-- Preheader -->
  <div style="display:none;max-height:0;overflow:hidden;font-size:1px;color:#f0faf4;">
    Your one-time sign-in code is ready. Expires in 20 minutes.&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;
  </div>

  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f0faf4;">
    <tr>
      <td align="center" style="padding:32px 16px;">

        <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width:480px;">

          <!-- Hero illustration area -->
          <tr>
            <td align="center" style="background-color:#d6f5e3;border-radius:20px 20px 0 0;padding:36px 40px 0 40px;">

              <!-- SVG Illustration: woman with phone inside padlock shape -->
              <svg width="180" height="170" viewBox="0 0 180 170" fill="none" xmlns="http://www.w3.org/2000/svg">
                <!-- Padlock outer shape -->
                <ellipse cx="90" cy="100" rx="72" ry="65" fill="#a8edca" stroke="#3dba7b" stroke-width="2.5"/>
                <!-- Padlock shackle (top arch) -->
                <path d="M58 68 Q58 28 90 28 Q122 28 122 68" stroke="#3dba7b" stroke-width="5" fill="none" stroke-linecap="round"/>
                <!-- Person body -->
                <ellipse cx="90" cy="112" rx="28" ry="34" fill="#2e7d52"/>
                <!-- Person head -->
                <circle cx="90" cy="74" r="16" fill="#f5c5a3"/>
                <!-- Hair -->
                <path d="M74 68 Q76 52 90 52 Q104 52 106 68 Q100 60 90 62 Q80 60 74 68Z" fill="#2c2c2c"/>
                <!-- Phone in hands -->
                <rect x="78" y="100" width="24" height="16" rx="3" fill="#e0e0e0" stroke="#aaa" stroke-width="1"/>
                <rect x="80" y="102" width="20" height="10" rx="1" fill="#90caf9"/>
                <!-- Decorative circles around padlock -->
                <circle cx="38" cy="80" r="4" fill="#3dba7b" opacity="0.4"/>
                <circle cx="145" cy="95" r="3" fill="#3dba7b" opacity="0.4"/>
                <circle cx="55" cy="140" r="2.5" fill="#3dba7b" opacity="0.3"/>
                <circle cx="130" cy="55" r="2" fill="#3dba7b" opacity="0.3"/>
              </svg>

              <!-- Five star/dot OTP mask indicator -->
              <table role="presentation" cellpadding="0" cellspacing="0" border="0" style="margin:0 auto 0 auto;">
                <tr>
                  <td align="center" style="background-color:#1a1a1a;border-radius:30px;padding:8px 20px;">
                    <span style="font-family:'Courier New',Courier,monospace;font-size:18px;color:#3dba7b;letter-spacing:8px;">
                      &#10033; &#10033; &#10033; &#10033; &#10033;
                    </span>
                  </td>
                </tr>
              </table>
              <div style="height:24px;"></div>
            </td>
          </tr>

          <!-- White card body -->
          <tr>
            <td style="background-color:#ffffff;padding:36px 40px 32px 40px;">

              <!-- Heading -->
              <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                  <td align="center" style="padding-bottom:18px;">
                    <h1 style="margin:0;font-family:Georgia,'Times New Roman',serif;font-size:22px;font-weight:bold;color:#111111;">
                      Your one-time code is
                    </h1>
                  </td>
                </tr>

                <!-- OTP Code -->
                <tr>
                  <td align="center" style="padding-bottom:22px;">
                    <table role="presentation" cellpadding="0" cellspacing="0" border="0" style="border:2px solid #222222;border-radius:4px;">
                      <tr>
                        <td align="center" style="padding:12px 48px;">
                          <!-- *** REPLACE {{OTP_CODE}} with your dynamic value *** -->
                          <span style="font-family:'Courier New',Courier,monospace;font-size:28px;font-weight:bold;color:#111111;letter-spacing:6px;">
                            ${otp}
                          </span>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>

                <!-- Body text -->
                <tr>
                  <td align="center" style="padding-bottom:28px;">
                    <p style="margin:0;font-family:Georgia,'Times New Roman',serif;font-size:14px;color:#555555;line-height:1.7;text-align:center;max-width:340px;">
                      Please verify you're really you by entering this 6-digit code when you sign in. Just a heads up, this code will expire
                      in <strong>20 minutes</strong> for security reasons.
                    </p>
                  </td>
                </tr>

                <!-- Divider -->
                <tr>
                  <td style="border-top:1px solid #eeeeee;padding-bottom:24px;font-size:0;">&nbsp;</td>
                </tr>

                <!-- Location notice heading -->
                <tr>
                  <td align="center" style="padding-bottom:22px;">
                    <h2 style="margin:0;font-family:Georgia,'Times New Roman',serif;font-size:17px;font-weight:bold;color:#111111;text-align:center;line-height:1.5;">
                      We noticed you signed in from a<br/>new location or device
                    </h2>
                  </td>
                </tr>

                <!-- Three info columns: Device, Location, Date -->
                <tr>
                  <td style="padding-bottom:24px;">
                    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
                      <tr>

                        <!-- Device -->
                        <td align="center" width="33%" valign="top" style="padding:0 4px;">
                          <!-- Monitor icon SVG -->
                          <svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg" style="display:block;margin:0 auto 8px auto;">
                            <rect x="4" y="6" width="28" height="18" rx="2" stroke="#111" stroke-width="2" fill="none"/>
                            <line x1="12" y1="30" x2="24" y2="30" stroke="#111" stroke-width="2" stroke-linecap="round"/>
                            <line x1="18" y1="24" x2="18" y2="30" stroke="#111" stroke-width="2"/>
                            <rect x="7" y="9" width="22" height="12" rx="1" fill="#d6f5e3"/>
                          </svg>
                          <p style="margin:0 0 4px 0;font-family:Georgia,'Times New Roman',serif;font-size:13px;font-weight:bold;color:#111111;">Device:</p>
                          <!-- *** REPLACE {{DEVICE}} *** -->
                          <p style="margin:0;font-family:Georgia,'Times New Roman',serif;font-size:12px;color:#555555;line-height:1.5;">
                            {{BROWSER}}<br/>{{OS}}
                          </p>
                        </td>

                        <!-- Location -->
                        <td align="center" width="33%" valign="top" style="padding:0 4px;">
                          <!-- Map pin icon SVG -->
                          <svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg" style="display:block;margin:0 auto 8px auto;">
                            <path d="M18 4C13.03 4 9 8.03 9 13c0 7 9 19 9 19s9-12 9-19c0-4.97-4.03-9-9-9z" stroke="#111" stroke-width="2" fill="#d6f5e3"/>
                            <circle cx="18" cy="13" r="3.5" stroke="#111" stroke-width="1.5" fill="white"/>
                          </svg>
                          <p style="margin:0 0 4px 0;font-family:Georgia,'Times New Roman',serif;font-size:13px;font-weight:bold;color:#111111;">Location:</p>
                          <!-- *** REPLACE {{LOCATION}} *** -->
                          <p style="margin:0;font-family:Georgia,'Times New Roman',serif;font-size:12px;color:#555555;line-height:1.5;">
                            {{CITY}}<br/>{{STATE_ZIP}}
                          </p>
                        </td>

                        <!-- Date -->
                        <td align="center" width="33%" valign="top" style="padding:0 4px;">
                          <!-- Calendar icon SVG -->
                          <svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg" style="display:block;margin:0 auto 8px auto;">
                            <rect x="4" y="7" width="28" height="24" rx="2" stroke="#111" stroke-width="2" fill="#d6f5e3"/>
                            <rect x="4" y="7" width="28" height="8" rx="2" fill="#3dba7b" stroke="#111" stroke-width="2"/>
                            <line x1="12" y1="4" x2="12" y2="10" stroke="#111" stroke-width="2" stroke-linecap="round"/>
                            <line x1="24" y1="4" x2="24" y2="10" stroke="#111" stroke-width="2" stroke-linecap="round"/>
                            <circle cx="18" cy="22" r="2.5" fill="#3dba7b"/>
                            <path d="M16 22 L17.5 24 L21 20" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
                          </svg>
                          <p style="margin:0 0 4px 0;font-family:Georgia,'Times New Roman',serif;font-size:13px;font-weight:bold;color:#111111;">Date</p>
                          <!-- *** REPLACE {{DATE_TIME}} *** -->
                          <p style="margin:0;font-family:Georgia,'Times New Roman',serif;font-size:12px;color:#555555;line-height:1.5;">
                            {{DATE_TIME}}
                          </p>
                        </td>

                      </tr>
                    </table>
                  </td>
                </tr>

                <!-- Divider -->
                <tr>
                  <td style="border-top:1px solid #eeeeee;padding-bottom:20px;font-size:0;">&nbsp;</td>
                </tr>

                <!-- Warning text -->
                <tr>
                  <td align="center" style="padding-bottom:22px;">
                    <p style="margin:0;font-family:Georgia,'Times New Roman',serif;font-size:14px;color:#555555;line-height:1.7;text-align:center;">
                      If you didn't just try to sign in,<br/>
                      we recommend you reset your password here:
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <tr>
            <td align="center" style="background-color:#ffffff;border-radius:0 0 20px 20px;border-top:1px solid #eeeeee;padding:18px 40px 28px 40px;">
              <p style="margin:0;font-family:Georgia,'Times New Roman',serif;font-size:12px;color:#999999;line-height:1.7;text-align:center;">
                If you have any questions, contact our
                <a href="{{GUIDES_URL}}" style="color:#3dba7b;text-decoration:none;">Website Guides</a>.<br/>
                Or, visit our <a href="{{HELP_URL}}" style="color:#3dba7b;text-decoration:none;">Help Center</a>.
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>

</body>
</html></p>`;

    try {
      await apiInstance.sendTransacEmail(sendSmtpEmail);
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
    
    // Check if UUID already exists just in case
    const existing = await User.findOne({ uuid });
    if (existing) {
      return res.status(400).json({ error: 'User already exists' });
    }
    
    const user = new User({ uuid, recoveryPhraseHash });
    await user.save();
    
    // Issue JWT
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
    
    // Issue new JWT
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
