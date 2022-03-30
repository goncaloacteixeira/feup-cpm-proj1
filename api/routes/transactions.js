var express = require('express');
var router = express.Router();
var trController = require('../controllers/transactions.controller');

router.get('/user/:uuid', trController.getPastTransactions);

module.exports = router;
