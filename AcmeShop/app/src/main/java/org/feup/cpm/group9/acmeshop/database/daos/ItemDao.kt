package org.feup.cpm.group9.acmeshop.database.daos

import androidx.lifecycle.LiveData
import androidx.room.*
import org.feup.cpm.group9.acmeshop.models.Item
import org.feup.cpm.group9.acmeshop.models.User

@Dao
interface ItemDao {
    @Query("SELECT * FROM purchase_items")
    fun getCurrentPurchaseItems(): LiveData<List<Item>>

    @Query("SELECT * FROM purchase_items WHERE uuid = :uuid LIMIT 1")
    fun getByUUID(uuid: String): Item?

    @Insert
    fun insertAll(vararg users: Item)

    @Query("DELETE FROM purchase_items")
    fun clearTable()

    @Delete
    fun remove(item: Item)

    @Update
    fun update(item: Item)
}