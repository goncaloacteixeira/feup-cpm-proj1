package org.feup.cpm.group9.acmeshopterminal

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.Toast
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanIntentResult
import com.journeyapps.barcodescanner.ScanOptions
import org.feup.cpm.group9.acmeshopterminal.models.Transaction

class MainActivity : AppCompatActivity() {
    private val TAG = "MainActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val qrCodeLauncher = registerForActivityResult(ScanContract()) { result: ScanIntentResult ->
            if (result.contents == null) {
                Toast.makeText(this, "Cancelled", Toast.LENGTH_LONG).show()
            } else {
                Transaction.validateToken(this, result.contents) {
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

        findViewById<Button>(R.id.qr_code_btn).setOnClickListener {
            val options = ScanOptions()
            options.setDesiredBarcodeFormats(ScanOptions.QR_CODE)
            options.setOrientationLocked(false)
            options.setBeepEnabled(false)
            options.setBarcodeImageEnabled(true)
            qrCodeLauncher.launch(options)
        }
        findViewById<Button>(R.id.nfc_btn).setOnClickListener {
            val intent = Intent(this, NFCReaderActivity::class.java)
            startActivity(intent)
        }
    }

    private fun startTransactionActivity(transaction: Transaction) {
        val intent = Intent(this, TransactionActivity::class.java)
        intent.putExtra("transaction", transaction)
        intent.putExtra("items", transaction.items)
        startActivity(intent)
    }
}