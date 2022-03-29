const users = require('../repositories/users');
const uuid = require('uuid');
const bcrypt = require('bcrypt');
const saltRounds = 10;

exports.registerUser = async (req, res) => {
  let properties = [
    'name',
    'email',
    'password',
    'vat',
    'address',
    'card_number',
    'card_validity',
    'card_type',
    'public_key'];

  for (let property of properties) {
    if (!req.body[property]) {
      return res.status(400).send("One or more fields missing!");
    }
  }

  if (req.body.vat.toString().length !== 9) {
    return res.status(400).send("VAT must have 9 digits!");
  }

  try {
    let newUUID = uuid.v4();
    bcrypt.hash(req.body.password, saltRounds, async function (err, hash) {
      req.body.password = hash;
      await users.insertUser(req.body, newUUID);
      return res.status(200).send(newUUID)
    });
  } catch (e) {
    console.error(e)
    return res.status(400).send(e.message);
  }
}

exports.getUserByUUID = async (req, res) => {
  let user = await users.getUserByUUID(req.params.uuid);
  return res.json(user);
};
