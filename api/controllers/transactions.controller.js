const transactions = require('../repositories/transactions');
const {getUserByUUID} = require("../repositories/users");

exports.getPastTransactions = async (req, res) => {
  let user_uuid = req.params.uuid;

  const past_transactions = await transactions.getPastTransactions(user_uuid);

  for (let tr of past_transactions) {
    tr.items = await transactions.getItemsForTransaction(tr.uuid);
  }

  res.send(past_transactions);
}

exports.validateToken = async (req, res) => {
  let token = req.params.token;

  const {token_valid, uuid, total_price, timestamp, user_uuid} = await transactions.getTransactionByToken(token);

  if (token_valid === 1) {
    console.log("Token is valid. TR UUID:", uuid);
    const items = await transactions.getItemsForTransaction(uuid);
    const user = await getUserByUUID(user_uuid);

    await transactions.validateToken(token);

    return res.send({
      uuid: uuid,
      user: user,
      timestamp: timestamp,
      total_price: total_price,
      items: items
    })
  } else {
    console.log("Token not valid. TR UUID:", uuid);
    return res.status(400).send("Token not valid.");
  }
}