require("dotenv").config();
const express = require("express");
const cors = require("cors");
const app = express();
const port = process.env.PORT || 3000;

const userRoutes = require("./routes/userRoutes");
const categoryRoutes = require("./routes/categoryRoutes");
const transactionRoutes = require("./routes/transactionRoutes");
const budgetRoutes = require("./routes/budgetRoutes");

app.use(cors());
app.use(express.json());

app.use("/api/users", userRoutes);
app.use("/api/categories", categoryRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/budgets", budgetRoutes);

app.get("/", (req, res) => res.send("FinManage API running"));

app.all("*", (req, res) => {
  //Catch unknow url
  res.status(404).send("404 NOT FOUND!");
});

app.listen(port, () =>
  console.log(`Server running on http://localhost:${port}`)
);
