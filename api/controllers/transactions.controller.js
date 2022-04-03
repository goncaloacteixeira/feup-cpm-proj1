const transactions = require('../repositories/transactions');
const {getUserByUUID} = require("../repositories/users");
const crypto = require('crypto')
const buffer = require('buffer')
const uuid = require('uuid');

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
        const tr_uuid = uuid.v4()
        await transactions.addTransaction({tr_uuid: tr_uuid, token: uuid.v4(), user_uuid})
        for (let item of items) {
            await transactions.addTransactionItem({tr_uuid: tr_uuid, item_uuid: '1' /* TODO - change this to actual */})
        }
        const tr = await transactions.getTransactionByUUID(tr_uuid)
        tr.items = await transactions.getItemsForTransaction(tr_uuid)

        // encrypt with public key to avoid Man in the Middle attacks
        tr.token = encrypt_token(tr.token, publicKey)

        console.log("public_key:", publicKey)
        console.log("token:", tr.token)
        // console.log("Signature OK: Transaction", tr)
        return res.json({message: "OK", content: tr})

    } else {
        console.log("Signature invalid")
        return res.json({message: "ERROR"})
    }
}

function encrypt_token(token, public_key) {
    const encrypted = crypto.publicEncrypt({
        key: public_key,
        padding: crypto.constants.RSA_PKCS1_PADDING
    }, token);
    return encrypted.toString("base64")
    // console.log(encrypted.toString("base64"))
}