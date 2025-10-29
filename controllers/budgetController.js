const { sql, config } = require("../config/db");

exports.getAll = async (req, res) => {
  //Get all budget item
  const user_id = req.user.user_id;
  try {
    const pool = await sql.connect(config);
    const q = await pool
      .request()
      .input("uid", sql.Int, user_id)
      .query("SELECT * FROM Budgets WHERE user_id = @uid");
    res.json(q.recordset);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

exports.create = async (req, res) => {
  //Create a budget
  const user_id = req.user.user_id;
  const { category_id, limit_amount, start_date, end_date } = req.body;
  if (!limit_amount || !start_date || !end_date)
    return res.status(400).json({ message: "Thiếu dữ liệu" });
  try {
    const pool = await sql.connect(config);
    const r = await pool
      .request()
      .input("uid", sql.Int, user_id)
      .input("cid", sql.Int, category_id || null)
      .input("limit_amount", sql.Decimal(18, 2), limit_amount)
      .input("start_date", sql.Date, start_date)
      .input("end_date", sql.Date, end_date)
      .query(
        "INSERT INTO Budgets (user_id, category_id, limit_amount, start_date, end_date) VALUES (@uid,@cid,@limit_amount,@start_date,@end_date); SELECT SCOPE_IDENTITY() AS id;"
      );
    res.json({ message: "Đã tạo ngân sách", id: r.recordset[0].id });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

exports.update = async (req, res) => {
  //Update budget
  const user_id = req.user.user_id;
  const { id } = req.params;
  const { category_id, limit_amount, start_date, end_date } = req.body;
  try {
    const pool = await sql.connect(config);
    await pool
      .request()
      .input("cid", sql.Int, category_id || null)
      .input("limit_amount", sql.Decimal(18, 2), limit_amount)
      .input("start_date", sql.Date, start_date)
      .input("end_date", sql.Date, end_date)
      .input("id", sql.Int, id)
      .input("uid", sql.Int, user_id)
      .query(
        "UPDATE Budgets SET category_id=@cid, limit_amount=@limit_amount, start_date=@start_date, end_date=@end_date WHERE budget_id=@id AND user_id=@uid"
      );
    res.json({ message: "Đã cập nhật" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

exports.remove = async (req, res) => {
  //Delete budget
  const user_id = req.user.user_id;
  const { id } = req.params;
  try {
    const pool = await sql.connect(config);
    await pool
      .request()
      .input("id", sql.Int, id)
      .input("uid", sql.Int, user_id)
      .query("DELETE FROM Budgets WHERE budget_id=@id AND user_id=@uid");
    res.json({ message: "Đã xóa" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};
