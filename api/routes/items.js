const itemsController = require('../controllers/items.controller');
const express = require('express');
const router = express.Router()

router.get("/", itemsController.getAllItems);
router.get("/:id", itemsController.getItemById)

module.exports = router