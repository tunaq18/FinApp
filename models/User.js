const sql = require("mssql");
const { getPool } = require("../config/database");

class User {
  static async create(email, name, password) {
    const pool = getPool();
    const result = await pool
      .request()
      .input("email", sql.NVarChar, email)
      .input("name", sql.NVarChar, name)
      .input("password", sql.NVarChar, password)
      .query(
        "INSERT INTO Users (Email, Name, Password) OUTPUT INSERTED.* VALUES (@email, @name, @password)",
      );

    return result.recordset[0];
  }

  static async findByEmail(email) {
    const pool = getPool();
    const result = await pool
      .request()
      .input("email", sql.NVarChar, email)
      .query("SELECT * FROM Users WHERE Email = @email");

    return result.recordset[0];
  }

  static async findById(id) {
    const pool = getPool();
    const result = await pool
      .request()
      .input("id", sql.Int, id)
      .query("SELECT Id, Email, Name, CreatedAt FROM Users WHERE Id = @id");

    return result.recordset[0];
  }

  static async authenticate(email, password) {
    const pool = getPool();
    const result = await pool
      .request()
      .input("email", sql.NVarChar, email)
      .input("password", sql.NVarChar, password)
      .query(
        "SELECT * FROM Users WHERE Email = @email AND Password = @password",
      );

    return result.recordset[0];
  }
}

module.exports = User;
