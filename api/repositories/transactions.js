const dao = require('./dao');

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

exports.getTransactionByUUID = async (tr_uuid) => {
  return await dao.get(
    "SELECT * FROM transactions WHERE uuid = ?",
    [tr_uuid]
  )
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

exports.addTransaction = async ({tr_uuid, token, user_uuid}) => {
  return await dao.run(
      "INSERT INTO transactions(uuid, token, user_uuid) VALUES (?,?,?)",
      [tr_uuid, token, user_uuid]
  )
}

exports.addTransactionItem = async ({tr_uuid, item_uuid}) => {
  return await dao.run(
      "INSERT INTO transaction_items(transaction_uuid, item_uuid) VALUES (?,?)",
      [tr_uuid, item_uuid]
  )
}