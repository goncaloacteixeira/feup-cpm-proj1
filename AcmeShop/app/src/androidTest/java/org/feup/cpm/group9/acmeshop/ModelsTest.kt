package org.feup.cpm.group9.acmeshop

import android.content.Context
import android.util.Log
import androidx.test.platform.app.InstrumentationRegistry
import org.feup.cpm.group9.acmeshop.models.Item
import org.feup.cpm.group9.acmeshop.models.Transaction
import org.feup.cpm.group9.acmeshop.models.User
import org.junit.Before
import org.junit.Test

class ModelsTest {
    private val TAG = "ModelsTest"
    lateinit var instrumentationContext: Context

    @Before
    fun setup() {
        instrumentationContext = InstrumentationRegistry.getInstrumentation().targetContext
    }

    @Test
    fun testGetUser() {
        User.getUser(instrumentationContext, "35") {
            Log.i(TAG, "testGetUser: User: $it")
            assert(it != null)
        }
        Thread.sleep(1000)
    }

    @Test
    fun getUserTransactions() {
        Transaction.getTransactionsForUser(instrumentationContext, "35") {
            Log.i(TAG, "getUserTransactions: Transactions: $it")
            assert(it != null)
        }
        Thread.sleep(2000)
    }

    @Test
    fun getItem() {
        Item.getItemByUUID(instrumentationContext, "1") {
            Log.i(TAG, "getItemByUUID: Item: $it")
            assert(it != null)
        }
        Thread.sleep(2000)
    }
}