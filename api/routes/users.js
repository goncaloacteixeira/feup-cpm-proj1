const express = require('express');
const router = express.Router();
const usersController = require('../controllers/users.controller');

router.post('/', usersController.registerUser);
router.get('/:uuid', usersController.getUserByUUID);

module.exports = router;
