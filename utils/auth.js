// utils/auth.js - simple JWT middleware
const jwt = require('jsonwebtoken');
const secret = process.env.JWT_SECRET || 'secret';

function generateToken(payload){
  return jwt.sign(payload, secret, { expiresIn: '7d' });
}

function authenticate(req, res, next){
  const header = req.headers['authorization'];
  if(!header) return res.status(401).json({ message: 'Missing authorization' });
  const token = header.split(' ')[1];
  if(!token) return res.status(401).json({ message: 'Invalid token' });
  try{
    const decoded = jwt.verify(token, secret);
    req.user = decoded;
    next();
  }catch(err){
    return res.status(401).json({ message: 'Unauthorized' });
  }
}

module.exports = { generateToken, authenticate };
