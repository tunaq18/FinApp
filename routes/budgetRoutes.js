const express = require('express');
const router = express.Router();
const controller = require('../controllers/budgetController');
const { authenticate } = require('../utils/auth');

router.get('/', authenticate, controller.getAll);
router.post('/', authenticate, controller.create);
router.put('/:id', authenticate, controller.update);
router.delete('/:id', authenticate, controller.remove);

module.exports = router;
