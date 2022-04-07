package org.feup.cpm.group9.acmeshop

import android.graphics.Color
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.drawerlayout.widget.DrawerLayout
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.navigateUp
import androidx.navigation.ui.setupActionBarWithNavController
import androidx.navigation.ui.setupWithNavController
import com.github.pavlospt.roundedletterview.RoundedLetterView
import com.google.android.material.navigation.NavigationView
import org.feup.cpm.group9.acmeshop.databinding.ActivityHomePageBinding
import java.util.*

class HomePageActivity : AppCompatActivity() {

    private lateinit var appBarConfiguration: AppBarConfiguration
    private lateinit var binding: ActivityHomePageBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityHomePageBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setSupportActionBar(binding.appBarHomePage.toolbar)

        val drawerLayout: DrawerLayout = binding.drawerLayout
        val navView: NavigationView = binding.navView
        val navController = findNavController(R.id.nav_host_fragment_content_home_page)
        // Passing each menu ID as a set of Ids because each
        // menu should be considered as top level destinations.
        appBarConfiguration = AppBarConfiguration(
            setOf(
                R.id.nav_home, R.id.nav_transactions, R.id.nav_slideshow
            ), drawerLayout
        )
        setupActionBarWithNavController(navController, appBarConfiguration)
        navView.setupWithNavController(navController)

        val loginUser: LoginUser = (intent.extras?.get("user") as LoginUser)
        setupDrawer(navView, loginUser)
    }

    private fun setupDrawer(navView: NavigationView, loginUser: LoginUser) {
        navView.getHeaderView(0).findViewById<TextView>(R.id.drawer_user_name).text = loginUser.name
        navView.getHeaderView(0).findViewById<TextView>(R.id.drawer_user_email).text = loginUser.email
        val letter = loginUser.name[0].toString()
        val rnd = Random()
        val color: Int = Color.argb(255, rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256))

        val roundedLetterView = navView.getHeaderView(0).findViewById<RoundedLetterView>(R.id.drawer_user_picture)
        roundedLetterView.backgroundColor = color
        roundedLetterView.titleText = letter
    }

    override fun onSupportNavigateUp(): Boolean {
        val navController = findNavController(R.id.nav_host_fragment_content_home_page)
        return navController.navigateUp(appBarConfiguration) || super.onSupportNavigateUp()
    }
}