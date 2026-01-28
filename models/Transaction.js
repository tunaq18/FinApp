const sql = require("mssql");
const { getPool } = require("../config/database");

class Transaction {
  static async findByUserId(userId, filters = {}) {
    const pool = getPool();
    let query = "SELECT * FROM Transactions WHERE UserId = @userId";
    const request = pool.request().input("userId", sql.Int, userId);

    if (filters.startDate) {
      query += " AND Date >= @startDate";
      request.input("startDate", sql.DateTime, new Date(filters.startDate));
    }
    if (filters.endDate) {
      query += " AND Date <= @endDate";
      request.input("endDate", sql.DateTime, new Date(filters.endDate));
    }
    if (filters.category) {
      query += " AND Category = @category";
      request.input("category", sql.NVarChar, filters.category);
    }
    if (filters.isIncome !== undefined) {
      query += " AND IsIncome = @isIncome";
      request.input("isIncome", sql.Bit, filters.isIncome === "true" ? 1 : 0);
    }

    query += " ORDER BY Date DESC";

    const result = await request.query(query);
    return result.recordset;
  }

  static async findById(id, userId) {
    const pool = getPool();
    const result = await pool
      .request()
      .input("id", sql.Int, id)
      .input("userId", sql.Int, userId)
      .query("SELECT * FROM Transactions WHERE Id = @id AND UserId = @userId");

    return result.recordset[0];
  }

  static async create(userId, data) {
    const pool = getPool();
    const result = await pool
      .request()
      .input("userId", sql.Int, userId)
      .input("title", sql.NVarChar, data.title)
      .input("amount", sql.Decimal(18, 2), data.amount)
      .input("date", sql.DateTime, data.date ? new Date(data.date) : new Date())
      .input("category", sql.NVarChar, data.category)
      .input("isIncome", sql.Bit, data.isIncome ? 1 : 0).query(`
        INSERT INTO Transactions (UserId, Title, Amount, Date, Category, IsIncome)
        OUTPUT INSERTED.*
        VALUES (@userId, @title, @amount, @date, @category, @isIncome)
      `);

    return result.recordset[0];
  }

  static async update(id, userId, data) {
    const pool = getPool();
    const result = await pool
      .request()
      .input("id", sql.Int, id)
      .input("userId", sql.Int, userId)
      .input("title", sql.NVarChar, data.title)
      .input("amount", sql.Decimal(18, 2), data.amount)
      .input("date", sql.DateTime, new Date(data.date))
      .input("category", sql.NVarChar, data.category)
      .input("isIncome", sql.Bit, data.isIncome ? 1 : 0).query(`
        UPDATE Transactions
        SET Title = @title,
            Amount = @amount,
            Date = @date,
            Category = @category,
            IsIncome = @isIncome,
            UpdatedAt = GETDATE()
        OUTPUT INSERTED.*
        WHERE Id = @id AND UserId = @userId
      `);

    return result.recordset[0];
  }

  static async delete(id, userId) {
    const pool = getPool();
    const result = await pool
      .request()
      .input("id", sql.Int, id)
      .input("userId", sql.Int, userId)
      .query(
        "DELETE FROM Transactions OUTPUT DELETED.* WHERE Id = @id AND UserId = @userId",
      );

    return result.recordset[0];
  }
}

module.exports = Transaction;
