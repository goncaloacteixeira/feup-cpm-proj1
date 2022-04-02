const itemsController = require('../controllers/items.controller');
const express = require('express');
const router = express.Router()

router.get("/", itemsController.getAllItems);
router.get("/:uuid", itemsController.getItemByUUID)

module.exports = router