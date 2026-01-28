const sql = require("mssql");
const { getPool } = require("../config/database");

class Statistics {
  static async getSummary(userId) {
    const pool = getPool();
    const result = await pool.request().input("userId", sql.Int, userId).query(`
        SELECT 
          SUM(CASE WHEN IsIncome = 1 THEN Amount ELSE 0 END) AS TotalIncome,
          SUM(CASE WHEN IsIncome = 0 THEN Amount ELSE 0 END) AS TotalExpense,
          SUM(CASE WHEN IsIncome = 1 THEN Amount ELSE -Amount END) AS Balance,
          COUNT(*) AS TotalTransactions
        FROM Transactions
        WHERE UserId = @userId
      `);

    const stats = result.recordset[0];
    return {
      totalIncome: stats.TotalIncome || 0,
      totalExpense: stats.TotalExpense || 0,
      balance: stats.Balance || 0,
      totalTransactions: stats.TotalTransactions || 0,
    };
  }

  static async getByCategory(userId, isIncome) {
    const pool = getPool();
    let query = `
      SELECT 
        Category,
        SUM(Amount) AS Total,
        COUNT(*) AS Count
      FROM Transactions
      WHERE UserId = @userId
    `;

    const request = pool.request().input("userId", sql.Int, userId);

    if (isIncome !== undefined) {
      query += " AND IsIncome = @isIncome";
      request.input("isIncome", sql.Bit, isIncome === "true" ? 1 : 0);
    }

    query += " GROUP BY Category ORDER BY Total DESC";

    const result = await request.query(query);

    return result.recordset.map((row) => ({
      category: row.Category,
      total: parseFloat(row.Total),
      count: row.Count,
    }));
  }

  static async getByMonth(userId, year) {
    const pool = getPool();
    const currentYear = year || new Date().getFullYear();

    const result = await pool
      .request()
      .input("userId", sql.Int, userId)
      .input("year", sql.Int, currentYear).query(`
        SELECT 
          MONTH(Date) AS Month,
          IsIncome,
          SUM(Amount) AS Total
        FROM Transactions
        WHERE UserId = @userId AND YEAR(Date) = @year
        GROUP BY MONTH(Date), IsIncome
        ORDER BY MONTH(Date)
      `);

    const monthlyStats = {};
    for (let i = 1; i <= 12; i++) {
      monthlyStats[i] = { income: 0, expense: 0 };
    }

    result.recordset.forEach((row) => {
      const month = row.Month;
      if (row.IsIncome) {
        monthlyStats[month].income = parseFloat(row.Total);
      } else {
        monthlyStats[month].expense = parseFloat(row.Total);
      }
    });

    return monthlyStats;
  }
}

module.exports = Statistics;
