const Statistics = require("../models/Statistics");

exports.getSummary = async (req, res) => {
  try {
    const stats = await Statistics.getSummary(req.params.userId);
    res.json(stats);
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};

exports.getByCategory = async (req, res) => {
  try {
    const stats = await Statistics.getByCategory(
      req.params.userId,
      req.query.isIncome,
    );
    res.json(stats);
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};

exports.getByMonth = async (req, res) => {
  try {
    const stats = await Statistics.getByMonth(
      req.params.userId,
      req.query.year,
    );
    res.json(stats);
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};
