package org.feup.cpm.group9.acmeshop

import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.EditText
import android.widget.Spinner
import androidx.appcompat.app.AppCompatActivity

class SignUpActivity : AppCompatActivity() {
    private val TAG = "org.feup.cmp.group9.acmeshop.SignUpActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sign_up)

        findViewById<Button>(R.id.signup_submin_btn).setOnClickListener {
            val name = findViewById<EditText>(R.id.user_name_edt).text.toString()
            val address = findViewById<EditText>(R.id.user_address_edt).text.toString()
            val email = findViewById<EditText>(R.id.user_email_edt).text.toString()
            val vat = findViewById<EditText>(R.id.user_vat_edt).text.toString().toInt()
            val password = findViewById<EditText>(R.id.user_password_edt).text.toString()
            val confirmPassword = findViewById<EditText>(R.id.user_confirm_password_edt).text.toString()
            val cardNumber = findViewById<EditText>(R.id.user_card_number_edt).text.toString().toDouble()
            val cardType = findViewById<Spinner>(R.id.user_card_type_edt).selectedItem.toString().lowercase()
            val cardValidity = findViewById<EditText>(R.id.user_card_validity_edt).text.toString()

            val user = LoginUser(name, address, email, vat, password, confirmPassword, cardNumber, cardType, cardValidity)

            LoginUser.signupUser(this, user) {
                Log.i(TAG, "onCreate: Signup: $user")
                Log.i(TAG, "onCreate: Result: $it")
                if (it) {
                    finish()
                }
            }
        }
    }
}