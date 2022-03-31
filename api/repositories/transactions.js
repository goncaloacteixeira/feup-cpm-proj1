const dao = require('./dao');
const {token} = require("morgan");

exports.getPastTransactions = async (user_uuid) => {
  return await dao.all(
    "SELECT * FROM transactions WHERE user_uuid = ? ORDER BY timestamp DESC", // needs to verify if token is used
    [user_uuid]
  );
}

exports.getItemsForTransaction = async (tr_uuid) => {
  return await dao.all(
    "SELECT * FROM transaction_items, items WHERE transaction_uuid = ? AND transaction_items.item_uuid = items.uuid",
    [tr_uuid]
  );
}

exports.getTransactionByToken = async (tr_token) => {
  return await dao.get(
    "SELECT * FROM transactions WHERE token = ?",
    [tr_token]
  );
}

exports.validateToken = async (tr_token) => {
  return await dao.run(
    "UPDATE transactions SET token_valid = false WHERE token = ?",
    [tr_token]
  );
}