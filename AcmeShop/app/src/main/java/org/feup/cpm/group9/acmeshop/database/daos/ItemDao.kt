package org.feup.cpm.group9.acmeshop.database.daos

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import org.feup.cpm.group9.acmeshop.models.Item
import org.feup.cpm.group9.acmeshop.models.User

@Dao
interface ItemDao {
    @Query("SELECT * FROM purchase_items")
    fun getCurrentPurchaseItems(): LiveData<List<Item>>

    @Insert
    fun insertAll(vararg users: Item)
}