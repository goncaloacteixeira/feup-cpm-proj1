var express = require('express');
var router = express.Router();
var trController = require('../controllers/transactions.controller');

router.get('/user/:uuid', trController.getPastTransactions);
router.post('/token/:token', trController.validateToken);

module.exports = router;
