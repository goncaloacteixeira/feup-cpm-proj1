package org.feup.cpm.group9.acmeshop

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.TextView

var TR_TOKEN: String = "undefined"

class NFCCardActivity : AppCompatActivity() {
    private val data: TextView by lazy { findViewById(R.id.data) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_nfccard)

        val token = this.intent.extras?.get("token") as String
        data.text = token

        TR_TOKEN = token
    }
}