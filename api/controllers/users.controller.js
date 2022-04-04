const users = require('../repositories/users');
const uuid = require('uuid');
const bcrypt = require('bcrypt');
const {getPastTransactions, getItemsForTransaction} = require("../repositories/transactions");
const transactions = require("../repositories/transactions");
const saltRounds = 10;

exports.registerUser = async (req, res) => {
  console.log(req.body)

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
      return res.json({message: "ERROR", content: "One or more fields missing!"});
    }
  }

  if (req.body.vat.toString().length !== 9) {
    return res.json({message: "ERROR", content: "VAT must have 9 digits!"});
  }

  try {
    let newUUID = uuid.v4();
    bcrypt.hash(req.body.password, saltRounds, async function (err, hash) {
      req.body.password = hash;
      await users.insertUser(req.body, newUUID);
      return res.json({message: "OK", content: newUUID})
    });
  } catch (e) {
    console.error(e)
    return res.json({message: "ERROR", content: e.message});
  }
};

exports.loginUser = async (req, res) => {
  console.log(req.body)

  let properties = [
    'email',
    'password',
    'public_key'
  ];

  for (let property of properties) {
    if (!req.body[property]) {
      return res.json({message: "ERROR", content: "One or more fields missing!"});
    }
  }

  try {
    let user = await users.getUserByEmail(req.body.email);
    if (!user) {
      return res.json({message: "ERROR", content: "User not found."});
    }
    bcrypt.compare(req.body.password, user.password, async function (err, result) {
      if (result) {
        await users.updatePublicKey(user.uuid, req.body.public_key)
        user.public_key = req.body.public_key
        return res.json({message: "OK", content: user})
      } else {
        return res.json({message: "ERROR", content: "Wrong password."});
      }
    });
  } catch (e) {
    console.error(e)
    return res.json({message: "ERROR", content: e.message});
  }
}

exports.getUserByUUID = async (req, res) => {
  let user = await users.getUserByUUID(req.params.uuid);
  let transactions = await getPastTransactions(req.params.uuid);
  for (let tr of transactions) {
    tr.items = await getItemsForTransaction(tr.uuid);
  }
  user.transactions = transactions
  console.log(user)
  return res.json(user);
};


