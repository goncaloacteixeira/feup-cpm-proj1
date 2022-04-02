package org.feup.cpm.group9.acmeshop.models

import android.content.Context
import android.util.Log
import com.android.volley.Request
import com.android.volley.toolbox.JsonArrayRequest
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.google.gson.Gson
import com.google.gson.annotations.SerializedName
import com.google.gson.reflect.TypeToken
import org.feup.cpm.group9.acmeshop.API_URL

class Transaction(
    val uuid: String,
    val token: String,
    @SerializedName("total_price")
    val totalPrice: Double,
    @SerializedName("token_valid")
    val tokenValid: Number,
    @Transient
    var items: List<Item>
) {
    companion object {
        private val gson = Gson()

        fun getTransactionsForUser(context: Context, userUUID: String, callback: (List<Transaction>?) -> Unit) {
            val queue = Volley.newRequestQueue(context)
            val url = "$API_URL/transactions/user/$userUUID"

            val request = JsonArrayRequest(
                Request.Method.GET, url, null,
                { response ->
                    Log.i("Transaction", "getTransactionsForUser: Response is: $response")
                    val transactionsType = object : TypeToken<List<Transaction>>() {}.type
                    val transactionsList =
                        gson.fromJson<List<Transaction>>(response.toString(), transactionsType)

                    for (i in 0 until response.length()) {
                        val transaction = response.getJSONObject(i)
                        val itemsType = object : TypeToken<List<Item>>() {}.type
                        val itemsList = gson.fromJson<List<Item>>(transaction.getJSONArray("items").toString(), itemsType)
                        transactionsList[i].items = itemsList
                    }

                    callback(transactionsList)
                },
                { error ->
                    Log.i("Transaction", "getTransactionsForUser: error: $error")
                    callback(null)
                })

            queue.add(request)
        }
    }

    override fun toString(): String {
        return "Transaction(uuid='$uuid', token='$token', totalPrice=$totalPrice, tokenValid=$tokenValid, items=$items)"
    }
}