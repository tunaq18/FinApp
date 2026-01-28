const express = require("express");
const router = express.Router();
const statisticsController = require("../controllers/statisticsController");

router.get("/:userId/summary", statisticsController.getSummary);
router.get("/:userId/by-category", statisticsController.getByCategory);
router.get("/:userId/by-month", statisticsController.getByMonth);

module.exports = router;
