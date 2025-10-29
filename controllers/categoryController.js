const { sql, config } = require("../config/db");

exports.getAll = async (req, res) => {
  //Get all item
  const user_id = req.user.user_id;
  try {
    const pool = await sql.connect(config);
    const q = await pool
      .request()
      .input("uid", sql.Int, user_id)
      .query("SELECT * FROM Categories WHERE user_id = @uid");
    res.json(q.recordset);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

exports.create = async (req, res) => {
  //Create Categories
  const user_id = req.user.user_id;
  const { name, type } = req.body;
  if (!name || !type) return res.status(400).json({ message: "Thiếu dữ liệu" });
  try {
    const pool = await sql.connect(config);
    const r = await pool
      .request()
      .input("uid", sql.Int, user_id)
      .input("name", sql.NVarChar, name)
      .input("type", sql.NVarChar, type)
      .query(
        "INSERT INTO Categories (user_id, name, type) VALUES (@uid,@name,@type); SELECT SCOPE_IDENTITY() AS id;"
      );
    res.json({ message: "Đã tạo", id: r.recordset[0].id });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

exports.update = async (req, res) => {
  //Update Categories
  const user_id = req.user.user_id;
  const { id } = req.params;
  const { name, type } = req.body;
  try {
    const pool = await sql.connect(config);
    await pool
      .request()
      .input("name", sql.NVarChar, name)
      .input("type", sql.NVarChar, type)
      .input("id", sql.Int, id)
      .input("uid", sql.Int, user_id)
      .query(
        "UPDATE Categories SET name=@name, type=@type WHERE category_id=@id AND user_id=@uid"
      );
    res.json({ message: "Đã cập nhật" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

exports.remove = async (req, res) => {
  //Delte Categories
  const user_id = req.user.user_id;
  const { id } = req.params;
  try {
    const pool = await sql.connect(config);
    await pool
      .request()
      .input("id", sql.Int, id)
      .input("uid", sql.Int, user_id)
      .query("DELETE FROM Categories WHERE category_id=@id AND user_id=@uid");
    res.json({ message: "Đã xóa" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};
