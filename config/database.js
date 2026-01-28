const sql = require("mssql");

const config = {
  user: process.env.DB_USER || "sa",
  password: process.env.DB_PASSWORD || "123456",
  server: process.env.DB_SERVER || "JAYJOE02",
  database: process.env.DB_DATABASE || "FinanceApp",
  options: {
    encrypt: true,
    trustServerCertificate: true,
    enableArithAbort: true,
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
};

let pool;

async function connectDB() {
  try {
    pool = await sql.connect(config);
    console.log("Đã kết nối SQL Server");
    await createTables();
  } catch (err) {
    console.error("Lỗi kết nối SQL Server:", err);
    process.exit(1);
  }
}

async function createTables() {
  try {
    // Tạo bảng Users
    await pool.request().query(`
      IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
      CREATE TABLE Users (
        Id INT PRIMARY KEY IDENTITY(1,1),
        Email NVARCHAR(255) NOT NULL UNIQUE,
        Name NVARCHAR(255) NOT NULL,
        Password NVARCHAR(255) NOT NULL,
        CreatedAt DATETIME DEFAULT GETDATE(),
        UpdatedAt DATETIME DEFAULT GETDATE()
      )
    `);

    // Tạo bảng Transactions
    await pool.request().query(`
      IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Transactions' AND xtype='U')
      CREATE TABLE Transactions (
        Id INT PRIMARY KEY IDENTITY(1,1),
        UserId INT NOT NULL,
        Title NVARCHAR(255) NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        Date DATETIME NOT NULL,
        Category NVARCHAR(100) NOT NULL,
        IsIncome BIT NOT NULL DEFAULT 0,
        CreatedAt DATETIME DEFAULT GETDATE(),
        UpdatedAt DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE
      )
    `);

    // Tạo indexes
    await pool.request().query(`
      IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_Transactions_UserId')
      CREATE INDEX IX_Transactions_UserId ON Transactions(UserId)
    `);

    await pool.request().query(`
      IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_Transactions_Date')
      CREATE INDEX IX_Transactions_Date ON Transactions(Date)
    `);

    console.log("Đã tạo/kiểm tra tables");
  } catch (err) {
    console.error("Lỗi tạo tables:", err);
  }
}

async function closeDB() {
  try {
    await pool.close();
    console.log("Đã đóng kết nối SQL Server");
  } catch (err) {
    console.error(err);
  }
}

function getPool() {
  return pool;
}

module.exports = { connectDB, closeDB, getPool };
