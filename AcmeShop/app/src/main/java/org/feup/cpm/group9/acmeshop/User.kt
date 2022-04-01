package org.feup.cpm.group9.acmeshop

import android.content.Context
import android.util.Base64
import android.util.Log
import com.android.volley.Request
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.google.gson.Gson
import com.google.gson.annotations.SerializedName
import org.json.JSONObject
import java.io.Serializable


class User(
    val name: String,
    val address: String,
    val email: String,
    val vat: Number,
    val password: String,
    @Transient
    val confirm_password: String,
    @SerializedName("card_number")
    val cardNumber: Number,
    @SerializedName("card_type")
    val cardType: String,
    @SerializedName("card_validity")
    val cardValidity: String
): Serializable {
    @SerializedName("public_key")
    lateinit var publicKey: String
    @Transient
    lateinit var uuid: String

    companion object {
        private val gson = Gson()

        fun signupUser(context: Context, user: User, callback: (Boolean) -> Unit) {
            if (user.confirm_password != user.password) {
                callback(false)
            }
            // TODO: check for missing values

            val queue = Volley.newRequestQueue(context)
            val url = "$API_URL/users"

            val publicKeyBytes: ByteArray =
                Base64.encode(Crypto.generateKey().public.encoded, Base64.NO_WRAP)
            user.publicKey = String(publicKeyBytes)

            val stringRequest = JsonObjectRequest(
                Request.Method.POST, url, JSONObject(gson.toJson(user)),
                { response ->
                    Log.i("User", "signupUser: Response is: $response")
                    callback(response.get("message") == "OK")
                },
                { error ->
                    Log.i("User", "signupUser: error: $error")
                    callback(false)
                })

            queue.add(stringRequest)
        }

        fun login(context: Context, email: String, password: String, callback: (User?) -> Unit) {
            val queue = Volley.newRequestQueue(context)
            val url = "$API_URL/users/login"
            val attributes = mapOf(
                "email" to email,
                "password" to password
            )

            val request = JsonObjectRequest(
                Request.Method.POST, url, JSONObject(attributes),
                { response ->
                    Log.i("User", "login: Response is: $response")
                    when (response.get("message")) {
                        "OK" -> {
                            val content = response.get("content")
                            var map: Map<String, Any> = HashMap()
                            map = gson.fromJson(content.toString(), map.javaClass)

                            val user = gson.fromJson(content.toString(), User::class.java)
                            user.uuid = map["uuid"] as String
                            callback(user)
                        }
                        else -> callback(null)
                    }
                },
                { error ->
                    Log.i("User", "login: error: $error")
                    callback(null)
                })

            queue.add(request)
        }
    }

    override fun toString(): String {
        return "User(name='$name', address='$address', email='$email', vat=$vat, password='$password', cardNumber=$cardNumber, cardType='$cardType', cardValidity='$cardValidity', publicKey=$publicKey)"
    }
}