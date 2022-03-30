const transactions = require('../repositories/transactions');

exports.getPastTransactions = async (req, res) => {
  let user_uuid = req.params.uuid;

  const past_transactions = await transactions.getPastTransactions(user_uuid);

  for (let tr of past_transactions) {
    tr.items = await transactions.getItemsForTransaction(tr.uuid);
  }

  res.send(past_transactions);
}