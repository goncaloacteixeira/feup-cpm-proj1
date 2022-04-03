package org.feup.cpm.group9.acmeshop.models

import android.content.Context
import android.util.Log
import com.android.volley.Request
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.google.gson.Gson
import org.feup.cpm.group9.acmeshop.API_URL

class Item(
    val uuid: String,
    val name: String,
    val description: String,
    val barcode: Number,
    val price: Double
) {
    @Transient
    var quantity = 1



    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as Item

        if (uuid != other.uuid) return false

        return true
    }

    override fun hashCode(): Int {
        return uuid.hashCode()
    }

    override fun toString(): String {
        return "Item(uuid='$uuid', name='$name', description='$description', barcode=$barcode, price=$price, quantity=$quantity)"
    }


    companion object {
        private val gson = Gson()

        fun getItemByUUID(context: Context, uuid: String, callback: (Item?) -> Unit) {
            val queue = Volley.newRequestQueue(context)
            val url = "$API_URL/items/$uuid"

            val request = JsonObjectRequest(
                Request.Method.GET, url, null,
                { response ->
                    Log.i("Item", "getItemByUUID: Response is: $response")
                    val item = gson.fromJson(response.toString(), Item::class.java)
                    callback(item)
                },
                { error ->
                    Log.i("Item", "getItemByUUID: error: $error")
                    callback(null)
                })

            queue.add(request)
        }

        fun getItemByBarcode(context: Context, barcode: Number, callback: (Item?) -> Unit) {
            val queue = Volley.newRequestQueue(context)
            val url = "$API_URL/items/barcode/$barcode"

            val request = JsonObjectRequest(
                Request.Method.GET, url, null,
                { response ->
                    Log.i("Item", "getItemByBarcode: Response is: $response")
                    val item = gson.fromJson(response.toString(), Item::class.java)
                    item.quantity = 1
                    callback(item)
                },
                { error ->
                    Log.i("Item", "getItemByBarcode: error: $error")
                    callback(null)
                })

            queue.add(request)
        }
    }
}