const Transaction = require("../models/Transaction");

exports.getAll = async (req, res) => {
  try {
    const transactions = await Transaction.findByUserId(
      req.params.userId,
      req.query,
    );
    res.json(transactions);
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};

exports.getOne = async (req, res) => {
  try {
    const transaction = await Transaction.findById(
      req.params.transactionId,
      req.params.userId,
    );
    if (!transaction) {
      return res.status(404).json({ error: "Không tìm thấy giao dịch" });
    }
    res.json(transaction);
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};

exports.create = async (req, res) => {
  try {
    const transaction = await Transaction.create(req.params.userId, req.body);
    res.status(201).json(transaction);
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};

exports.update = async (req, res) => {
  try {
    const transaction = await Transaction.update(
      req.params.transactionId,
      req.params.userId,
      req.body,
    );
    if (!transaction) {
      return res.status(404).json({ error: "Không tìm thấy giao dịch" });
    }
    res.json(transaction);
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};

exports.delete = async (req, res) => {
  try {
    const transaction = await Transaction.delete(
      req.params.transactionId,
      req.params.userId,
    );
    if (!transaction) {
      return res.status(404).json({ error: "Không tìm thấy giao dịch" });
    }
    res.json({ message: "Đã xóa giao dịch thành công", transaction });
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};
