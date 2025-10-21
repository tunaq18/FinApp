const { sql, config } = require('../config/db');

exports.getAll = async (req, res) => {
  const user_id = req.user.user_id;
  try{
    const pool = await sql.connect(config);
    const q = await pool.request().input('uid', sql.Int, user_id)
      .query(`SELECT t.transaction_id, t.[date], t.amount, t.note, t.type, c.name AS category_name
              FROM Transactions t LEFT JOIN Categories c ON t.category_id = c.category_id
              WHERE t.user_id = @uid ORDER BY t.[date] DESC`);
    res.json(q.recordset);
  }catch(err){console.error(err);res.status(500).json({message:'Lỗi server'})}
};

exports.create = async (req, res) => {
  const user_id = req.user.user_id;
  const { category_id, amount, note, date, type } = req.body;
  if(!amount || !date || !type) return res.status(400).json({ message:'Thiếu dữ liệu' });
  try{
    const pool = await sql.connect(config);
    const r = await pool.request()
      .input('uid', sql.Int, user_id)
      .input('cid', sql.Int, category_id || null)
      .input('amount', sql.Decimal(18,2), amount)
      .input('note', sql.NVarChar, note)
      .input('date', sql.Date, date)
      .input('type', sql.NVarChar, type)
      .query('INSERT INTO Transactions (user_id, category_id, amount, note, [date], type) VALUES (@uid,@cid,@amount,@note,@date,@type); SELECT SCOPE_IDENTITY() AS id;');
    res.json({ message:'Đã thêm giao dịch', id: r.recordset[0].id });
  }catch(err){console.error(err);res.status(500).json({message:'Lỗi server'})}
};

exports.update = async (req, res) => {
  const user_id = req.user.user_id;
  const { id } = req.params;
  const { category_id, amount, note, date, type } = req.body;
  try{
    const pool = await sql.connect(config);
    await pool.request()
      .input('cid', sql.Int, category_id || null)
      .input('amount', sql.Decimal(18,2), amount)
      .input('note', sql.NVarChar, note)
      .input('date', sql.Date, date)
      .input('type', sql.NVarChar, type)
      .input('id', sql.Int, id)
      .input('uid', sql.Int, user_id)
      .query('UPDATE Transactions SET category_id=@cid, amount=@amount, note=@note, [date]=@date, type=@type WHERE transaction_id=@id AND user_id=@uid');
    res.json({ message:'Đã cập nhật' });
  }catch(err){console.error(err);res.status(500).json({message:'Lỗi server'})}
};

exports.remove = async (req, res) => {
  const user_id = req.user.user_id;
  const { id } = req.params;
  try{
    const pool = await sql.connect(config);
    await pool.request().input('id', sql.Int, id).input('uid', sql.Int, user_id).query('DELETE FROM Transactions WHERE transaction_id=@id AND user_id=@uid');
    res.json({ message:'Đã xóa' });
  }catch(err){console.error(err);res.status(500).json({message:'Lỗi server'})}
};
