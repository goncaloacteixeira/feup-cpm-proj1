const dao = require('./dao');

exports.insertUser = async function ({name, email, password, vat, address, card_number, card_validity, card_type, public_key}, uuid) {
  return await dao.run("INSERT INTO users(uuid, name, email, password, vat, address, card_number, card_validity, card_type, public_key) VALUES (?,?,?,?,?,?,?,?,?,?)", [uuid, name, email, password, vat, address, card_number, card_validity, card_type, public_key])
}

exports.getUserByUUID = async function (uuid) {
  return await dao.get("SELECT * FROM users WHERE uuid = ?", [uuid]);
}

exports.getUserByEmail = async function (email) {
  return await dao.get("SELECT * FROM users WHERE email = ?", [email]);
}

exports.updatePublicKey = async (user_uuid, public_Key) => {
  return await dao.run(
      "UPDATE users SET public_key = ? WHERE uuid = ?",
      [public_Key, user_uuid]
  )
}