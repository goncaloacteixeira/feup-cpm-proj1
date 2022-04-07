package org.feup.cpm.group9.acmeshop.database

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import org.feup.cpm.group9.acmeshop.database.daos.ItemDao
import org.feup.cpm.group9.acmeshop.models.Item

@Database(entities = [Item::class], version = 1)
abstract class AppDatabase : RoomDatabase() {
    companion object {
        @Volatile
        private var instance: AppDatabase? = null

        fun getInstance(context: Context): AppDatabase {
            if (instance == null) {
                instance = Room.databaseBuilder(context, AppDatabase::class.java, "database")
                    .allowMainThreadQueries()
                    .build()
            }
            return instance as AppDatabase
        }
    }

    abstract fun itemDao(): ItemDao
}