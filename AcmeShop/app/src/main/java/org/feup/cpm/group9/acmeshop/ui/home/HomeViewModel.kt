package org.feup.cpm.group9.acmeshop.ui.home

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.room.Room
import org.feup.cpm.group9.acmeshop.database.AppDatabase
import org.feup.cpm.group9.acmeshop.models.Item
import org.feup.cpm.group9.acmeshop.models.User

class HomeViewModel(application: Application, uuid: String) : AndroidViewModel(application) {
    private val db = AppDatabase.getInstance(application)
    private val itemDao = db.itemDao()

    private val _text = MutableLiveData<String>().apply {
        value = "This is home Fragment"
    }

    private val _user = MutableLiveData<User>().apply {
        User.getUser(getApplication(), uuid) {
            value = it
        }
    }

    fun getPurchaseItems(): LiveData<List<Item>> {
        return itemDao.getCurrentPurchaseItems()
    }

    fun updateUser(uuid: String) {
        User.getUser(getApplication(), uuid) {
            _user.value = it
        }
    }

    val text: LiveData<String> = _text
    val user: LiveData<User> = _user
}