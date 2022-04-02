package org.feup.cpm.group9.acmeshop

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Button
import androidx.activity.result.ActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    private val TAG = "org.feup.cpm.group9.acmeshop.MainActivity"

    private val startForResultLogin = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result: ActivityResult ->
        if (result.resultCode == Activity.RESULT_OK) {
            val loginUser: LoginUser = result.data?.extras?.get("result") as LoginUser
            Log.i(TAG, "Login Result: $loginUser")
            val intent = Intent(this, HomePageActivity::class.java)
            intent.putExtra("user", loginUser)
            startActivity(intent)
            finish()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<Button>(R.id.signup_btn).setOnClickListener {
            val intent = Intent(this, SignUpActivity::class.java)
            startActivity(intent)
        }

        findViewById<Button>(R.id.login_btn).setOnClickListener {
            val intent = Intent(this, LoginActivity::class.java)
            startForResultLogin.launch(intent)
        }
    }
}