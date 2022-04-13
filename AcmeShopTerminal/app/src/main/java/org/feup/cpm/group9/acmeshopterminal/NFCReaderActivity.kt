package org.feup.cpm.group9.acmeshopterminal

import android.content.Intent
import android.nfc.NfcAdapter
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.TextView
import android.widget.Toast
import org.feup.cpm.group9.acmeshopterminal.models.Transaction

const val READER_FLAGS = NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK

class NFCReaderActivity : AppCompatActivity() {
    private val TAG = "NFCReaderActivity"
    private val nfc: NfcAdapter? by lazy { NfcAdapter.getDefaultAdapter(this) }
    private val data: TextView by lazy { findViewById(R.id.data) }
    private val cardReader by lazy { CardReader(this::onDataCallback) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_nfcreader)

        if (nfc == null) {
            Toast.makeText(this, "NFC adapter not present!", Toast.LENGTH_LONG).show()
            finish()
        }
    }

    private fun onDataCallback(token: String) {
        runOnUiThread {
            data.text = token
            Transaction.validateToken(this, token) {
                Log.i(TAG, "onCreate: validateToken: $it")
                if (it == null) {
                    Toast.makeText(
                        this,
                        "Token not valid",
                        Toast.LENGTH_LONG
                    ).show()
                } else {
                    startTransactionActivity(it)
                }
            }
        }
    }

    private fun startTransactionActivity(transaction: Transaction) {
        val intent = Intent(this, TransactionActivity::class.java)
        intent.putExtra("transaction", transaction)
        intent.putExtra("items", transaction.items)
        startActivity(intent)
    }

    override fun onPause() {
        super.onPause()
        nfc?.disableReaderMode(this)
    }

    override fun onResume() {
        super.onResume()
        nfc?.enableReaderMode(this, cardReader, READER_FLAGS, null)
    }
}