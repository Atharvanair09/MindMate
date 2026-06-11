const crypto = require('crypto');

// ENCRYPTION_KEY from .env is a 64-char hex string representing 32 bytes.
// If not set, fall back to a deterministic default for dev.
const rawKey = (process.env.ENCRYPTION_KEY || '').trim();
let ENCRYPTION_KEY;
if (rawKey.length === 64) {
  // Hex-encoded 32-byte key
  ENCRYPTION_KEY = Buffer.from(rawKey, 'hex');
} else if (rawKey.length === 32) {
  // Raw 32-char string key
  ENCRYPTION_KEY = Buffer.from(rawKey);
} else {
  // Fallback for dev — generate a deterministic 32-byte key
  console.warn('[CRYPTO] ⚠️ ENCRYPTION_KEY not set or wrong length (' + rawKey.length + '). Using fallback.');
  ENCRYPTION_KEY = Buffer.from('default-encryption-key-32-bytes!');
}
console.log('[CRYPTO] Encryption key loaded — buffer length:', ENCRYPTION_KEY.length, 'bytes');

const IV_LENGTH = 16;


function encrypt(text) {
  if (!text) return text;
  try {
    const iv = crypto.randomBytes(IV_LENGTH);
    const cipher = crypto.createCipheriv('aes-256-cbc', ENCRYPTION_KEY, iv);
    let encrypted = cipher.update(text);
    encrypted = Buffer.concat([encrypted, cipher.final()]);
    return iv.toString('hex') + ':' + encrypted.toString('hex');
  } catch (err) {
    console.error('[CRYPTO] ❌ Encryption error:', err.message);
    return null;
  }
}

function decrypt(text) {
  if (!text) return text;
  try {
    const textParts = text.split(':');
    const iv = Buffer.from(textParts.shift(), 'hex');
    const encryptedText = Buffer.from(textParts.join(':'), 'hex');
    const decipher = crypto.createDecipheriv('aes-256-cbc', ENCRYPTION_KEY, iv);
    let decrypted = decipher.update(encryptedText);
    decrypted = Buffer.concat([decrypted, decipher.final()]);
    return decrypted.toString();
  } catch (err) {
    console.error('[CRYPTO] ❌ Decryption error:', err.message);
    return null;
  }
}

function hashUuid(uuid) {
  if (!uuid) return uuid;
  return crypto.createHash('sha256').update(uuid).digest('hex');
}

module.exports = {
  encrypt,
  decrypt,
  hashUuid
};
