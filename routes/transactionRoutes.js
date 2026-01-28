const express = require("express");
const router = express.Router();
const transactionController = require("../controllers/transactionController");

router.get("/:userId", transactionController.getAll);
router.get("/:userId/:transactionId", transactionController.getOne);
router.post("/:userId", transactionController.create);
router.put("/:userId/:transactionId", transactionController.update);
router.delete("/:userId/:transactionId", transactionController.delete);

module.exports = router;
