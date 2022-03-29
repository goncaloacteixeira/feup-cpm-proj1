const dao = require('./dao');
const bcrypt = require('bcrypt');
const saltRounds = 10;


exports.getAllItems = async () => {
  return await dao.all("SELECT * FROM items", [])
}

exports.getItemById = async (uuid) => {
  return await dao.get("SELECT * FROM items WHERE uuid = ?", [uuid])
}

exports.getUserByUsername = async (username) => {
  return dao.get("SELECT * FROM users WHERE username = ?", [username]);
}

exports.getUserById = async (id) => {
  return dao.get('SELECT * FROM users WHERE id = ?', [id]);
}
