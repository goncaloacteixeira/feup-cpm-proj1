const dao = require('./dao');

exports.insertUser = async function ({name, email, password, vat, address, card_number, card_validity, card_type, public_key}, uuid) {
  return await dao.run("INSERT INTO users(uuid, name, email, password, vat, address, card_number, card_validity, card_type, public_key) VALUES (?,?,?,?,?,?,?,?,?,?)", [uuid, name, email, password, vat, address, card_number, card_validity, card_type, public_key])
}

exports.getUserByUUID = async function (uuid) {
  return await dao.get("SELECT * FROM users WHERE uuid = ?", [uuid]);
}