package org.feup.cpm.group9.acmeshop


import android.app.Dialog
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.MenuItem
import android.view.Window
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.zxing.BarcodeFormat
import com.journeyapps.barcodescanner.BarcodeEncoder
import org.feup.cpm.group9.acmeshop.adapters.TransactionAdapter
import org.feup.cpm.group9.acmeshop.models.Item
import org.feup.cpm.group9.acmeshop.models.Transaction


class TransactionActivity : AppCompatActivity() {
    private val TAG = "TransactionActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_transaction)

        supportActionBar?.title = "Transaction"
        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        val transaction = intent.extras?.get("transaction") as Transaction
        val items = intent.extras?.get("items") as ArrayList<Item>
        transaction.items = items

        Log.i(TAG, "onCreate: transaction: $transaction, items: $items")

        val title = findViewById<TextView>(R.id.transaction_title)
        title.text = getString(R.string.your_transaction_on, Transaction.formatTimestampToDate(transaction.timestamp))

        val total = findViewById<TextView>(R.id.transaction_total)
        total.text = getString(R.string.price_template_eur, transaction.totalPrice)

        val data = populateData(items)
        val adapter = TransactionAdapter(data)

        val recyclerview = findViewById<RecyclerView>(R.id.transaction_items_rv)
        recyclerview.layoutManager = LinearLayoutManager(this)
        recyclerview.adapter = adapter

        val qrBtn = findViewById<Button>(R.id.qr_code_btn)
        val nfcBtn = findViewById<Button>(R.id.nfc_btn)

        qrBtn.setOnClickListener {
            showQRCode(transaction.token)
        }
        nfcBtn.setOnClickListener {
            val intent = Intent(this, NFCCardActivity::class.java)
            intent.putExtra("token", transaction.token)
            startActivity(intent)
        }
    }

    private fun populateData(items: ArrayList<Item>): ArrayList<Item> {
        val data = ArrayList<Item>()
        // reset quantities
        for (item in items) {
            item.quantity = 1
        }

        for (item in items) {
            if (data.contains(item)) {
                data[data.indexOf(item)].quantity++
            } else {
                data.add(item)
            }
        }
        return data
    }

    private fun showQRCode(token: String) {
        val dialog = Dialog(this)

        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        dialog.setCancelable(true)
        dialog.setContentView(R.layout.qr_code_dialog)

        val qrImg = dialog.findViewById<ImageView>(R.id.qr_code_img)
        val barcodeEncoder = BarcodeEncoder()
        val bitmap = barcodeEncoder.encodeBitmap(token, BarcodeFormat.QR_CODE, 600, 600)

        qrImg.setImageBitmap(bitmap)

        dialog.show()
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            android.R.id.home -> {
                finish()
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }
}