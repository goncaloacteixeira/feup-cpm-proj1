package org.feup.cpm.group9.acmeshop.models

import android.content.Context
import android.util.Log
import com.android.volley.Request
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.google.gson.Gson
import com.google.gson.annotations.SerializedName
import com.google.gson.reflect.TypeToken
import org.feup.cpm.group9.acmeshop.API_URL

class User(
    val name: String,
    val address: String,
    val email: String,
    val vat: Number,
    val password: String,
    @SerializedName("card_number")
    val cardNumber: Number,
    @SerializedName("card_type")
    val cardType: String,
    @SerializedName("card_validity")
    val cardValidity: String,
    @SerializedName("public_key")
    val publicKey: String,
    val uuid: String,
) {
    @Transient
    lateinit var transactions: List<Transaction>

    companion object {
        private val gson = Gson()

        fun getUser(context: Context, uuid: String, callback: (User?) -> Unit) {
            val queue = Volley.newRequestQueue(context)
            val url = "$API_URL/users/$uuid"

            val request = JsonObjectRequest(
                Request.Method.GET, url, null,
                { response ->
                    Log.i("User", "getUser: Response is: $response")
                    val user = gson.fromJson(response.toString(), User::class.java)

                    val transactionsArray = response.getJSONArray("transactions")
                    val transactionsType = object : TypeToken<List<Transaction>>() {}.type
                    val transactionsList = gson.fromJson<List<Transaction>>(transactionsArray.toString(), transactionsType)

                    for (i in 0 until transactionsArray.length()) {
                        val transaction = transactionsArray.getJSONObject(i)
                        val itemsType = object : TypeToken<List<Item>>() {}.type
                        val itemsList = gson.fromJson<List<Item>>(transaction.getJSONArray("items").toString(), itemsType)
                        transactionsList[i].items = itemsList
                    }

                    user.transactions = transactionsList

                    callback(user)
                },
                { error ->
                    Log.i("User", "login: error: $error")
                    callback(null)
                })

            queue.add(request)
        }
    }

    fun getTotalSpent(): Double {
        var total = 0.0
        for (transaction in transactions) {
            total += transaction.totalPrice
        }
        return total
    }

    override fun toString(): String {
        return "User(name='$name', address='$address', email='$email', vat=$vat, password='$password', cardNumber=$cardNumber, cardType='$cardType', cardValidity='$cardValidity', publicKey='$publicKey', uuid='$uuid', transactions=$transactions)"
    }


}