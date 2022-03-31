package org.feup.cpm.group9.acmeshop

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.EditText
import android.widget.Toast

class LoginActivity : AppCompatActivity() {
    private val TAG = "org.feup.cpm.group9.acmeshop.LoginActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        findViewById<Button>(R.id.login_submit_btn).setOnClickListener {
            val email = findViewById<EditText>(R.id.login_email_edt).text.toString()
            val password = findViewById<EditText>(R.id.login_password_edt).text.toString()

            Log.i(TAG, "onCreate: login for: $email, $password")
            User.login(this, email, password) {
                Log.i(TAG, "onCreate: Login Result: $it")
                if (it) {
                    // TODO: Change to homescreen logged in
                    Toast.makeText(this, "User logged in", Toast.LENGTH_LONG).show()
                } else {
                    Toast.makeText(this, "Invalid Login info", Toast.LENGTH_LONG).show()
                }
            }
        }
    }
}