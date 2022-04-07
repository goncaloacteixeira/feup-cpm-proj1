package org.feup.cpm.group9.acmeshop.ui.transactions

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import org.feup.cpm.group9.acmeshop.models.User

class TransactionsViewModel(application: Application, uuid: String) : AndroidViewModel(application) {

    private val _text = MutableLiveData<String>().apply {
        value = "This is transactions Fragment"
    }
    val text: LiveData<String> = _text

    private val _user = MutableLiveData<User>().apply {
        User.getUser(getApplication(), uuid) {
            value = it
        }
    }

    fun updateUser(uuid: String) {
        User.getUser(getApplication(), uuid) {
            if (it != null) {
                _user.value = it
            }
        }
    }

    val user: LiveData<User> = _user
}