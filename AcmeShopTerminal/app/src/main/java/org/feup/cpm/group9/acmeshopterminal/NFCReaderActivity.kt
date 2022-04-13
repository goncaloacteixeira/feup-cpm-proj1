package org.feup.cpm.group9.acmeshopterminal

import android.nfc.NfcAdapter
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.TextView
import android.widget.Toast

const val READER_FLAGS = NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK

class NFCReaderActivity : AppCompatActivity() {
    private val nfc: NfcAdapter? by lazy { NfcAdapter.getDefaultAdapter(this) }
    private val data: TextView by lazy { findViewById(R.id.data) }
    private val cardReader by lazy { CardReader { runOnUiThread { data.text = it }} }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_nfcreader)

        if (nfc == null) {
            Toast.makeText(this, "NFC adapter not present!", Toast.LENGTH_LONG).show()
            finish()
        }
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