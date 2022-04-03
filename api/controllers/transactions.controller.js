const transactions = require('../repositories/transactions');
const {getUserByUUID} = require("../repositories/users");
const crypto = require('crypto')
const buffer = require('buffer')

exports.getPastTransactions = async (req, res) => {
    let user_uuid = req.params.uuid;

    const past_transactions = await transactions.getPastTransactions(user_uuid);

    for (let tr of past_transactions) {
        tr.items = await transactions.getItemsForTransaction(tr.uuid);
    }

    console.log(past_transactions)

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

exports.processPayment = async (req, res) => {
    console.log(req.body)
    let {user_uuid, items, signature} = req.body

    let {public_key} = await getUserByUUID(user_uuid)

    let publicKey = "-----BEGIN PUBLIC KEY-----\n" + public_key + "-----END PUBLIC KEY-----"
    const verifier = crypto.createVerify('RSA-SHA256')
    verifier.update(user_uuid)

    const result = verifier.verify(publicKey, signature, "base64")

    if (result) {
        // build transaction -> send reply ok if validity is checked
    } else {
        // send reply -> error
    }

    console.log(result)

    res.send("OK")
}