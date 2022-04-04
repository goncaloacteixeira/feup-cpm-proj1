package org.feup.cpm.group9.acmeshop

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity


class LoginActivity : AppCompatActivity() {
    private val TAG = "org.feup.cpm.group9.acmeshop.LoginActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        findViewById<Button>(R.id.login_submit_btn).setOnClickListener {
            val email = findViewById<EditText>(R.id.login_email_edt).text.toString()
            val password = findViewById<EditText>(R.id.login_password_edt).text.toString()

            Log.i(TAG, "onCreate: login for: $email, $password")
            LoginUser.login(this, email, password) { user ->
                Log.i(TAG, "onCreate: Login Result: $user")
                if (user != null) {
                    Toast.makeText(this, "User logged in: UUID: ${user.uuid}", Toast.LENGTH_LONG).show()
                    val returnIntent = Intent()
                    returnIntent.putExtra("result", user)
                    setResult(RESULT_OK, returnIntent)
                    finish()
                } else {
                    Toast.makeText(this, "Invalid Login info", Toast.LENGTH_LONG).show()
                }
            }
        }
    }
}