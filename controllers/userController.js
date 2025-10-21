const { sql, config } = require('../config/db');
const bcrypt = require('bcrypt');
const { generateToken } = require('../utils/auth');

exports.register = async (req, res) => {
  const { name, email, password } = req.body;
  if(!name || !email || !password) return res.status(400).json({ message: 'Thiếu thông tin' });
  try{
    const pool = await sql.connect(config);
    // check email
    const exists = await pool.request()
      .input('email', sql.NVarChar, email)
      .query('SELECT user_id FROM Users WHERE email = @email');
    if(exists.recordset.length) return res.status(400).json({ message: 'Email đã tồn tại' });

    const hash = await bcrypt.hash(password, 10);
    const result = await pool.request()
      .input('name', sql.NVarChar, name)
      .input('email', sql.NVarChar, email)
      .input('password_hash', sql.NVarChar, hash)
      .query('INSERT INTO Users (name, email, password_hash) VALUES (@name, @email, @password_hash); SELECT SCOPE_IDENTITY() AS id;');

    const id = result.recordset[0].id;
    const token = generateToken({ user_id: id, email });
    res.json({ message: 'Đăng ký thành công', token });
  }catch(err){
    console.error(err);
    res.status(500).json({ message: 'Lỗi server' });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;
  if(!email || !password) return res.status(400).json({ message: 'Thiếu thông tin' });
  try{
    const pool = await sql.connect(config);
    const user = await pool.request().input('email', sql.NVarChar, email)
      .query('SELECT user_id, password_hash, name FROM Users WHERE email = @email');
    if(!user.recordset.length) return res.status(400).json({ message: 'Email không tồn tại' });
    const row = user.recordset[0];
    const ok = await bcrypt.compare(password, row.password_hash);
    if(!ok) return res.status(401).json({ message: 'Sai mật khẩu' });
    const token = generateToken({ user_id: row.user_id, email });
    res.json({ token, user: { user_id: row.user_id, name: row.name, email } });
  }catch(err){
    console.error(err);
    res.status(500).json({ message: 'Lỗi server' });
  }
};

exports.getProfile = async (req, res) => {
  const user_id = req.user.user_id;
  try{
    const pool = await sql.connect(config);
    const q = await pool.request().input('id', sql.Int, user_id).query('SELECT user_id, name, email, created_at FROM Users WHERE user_id = @id');
    if(!q.recordset.length) return res.status(404).json({ message: 'User không tồn tại' });
    res.json(q.recordset[0]);
  }catch(err){
    console.error(err);
    res.status(500).json({ message: 'Lỗi server' });
  }
};

// optional: update profile (name)
exports.updateProfile = async (req, res) => {
  const user_id = req.user.user_id;
  const { name } = req.body;
  try{
    const pool = await sql.connect(config);
    await pool.request().input('name', sql.NVarChar, name).input('id', sql.Int, user_id)
      .query('UPDATE Users SET name = @name WHERE user_id = @id');
    res.json({ message: 'Cập nhật thành công' });
  }catch(err){
    console.error(err);
    res.status(500).json({ message: 'Lỗi server' });
  }
};
