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

