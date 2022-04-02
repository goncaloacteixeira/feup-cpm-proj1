package org.feup.cpm.group9.acmeshop.ui.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import org.feup.cpm.group9.acmeshop.R
import org.feup.cpm.group9.acmeshop.databinding.FragmentHomeBinding

class HomeFragment : Fragment() {
    private var _binding: FragmentHomeBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        var factory = object : ViewModelProvider.Factory {
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                return  HomeViewModel(activity!!.application, activity!!.intent.extras?.get("uuid") as String) as T
            }
        }

        val homeViewModel : HomeViewModel by lazy {
            ViewModelProvider(this, factory).get(HomeViewModel::class.java)
        }

        _binding = FragmentHomeBinding.inflate(inflater, container, false)
        val root: View = binding.root

        val helloUser: TextView = binding.homeHelloUser
        val totalSpent: TextView = binding.homeTotalSpent
        val numberTransactions: TextView = binding.homeNumberTransactions

        homeViewModel.user.observe(viewLifecycleOwner) {
            helloUser.text = context?.getString(R.string.hello_user, it.name)
            totalSpent.text = context?.getString(R.string.price_template_eur, it.getTotalSpent())
            numberTransactions.text = it.transactions.size.toString()
        }

        return root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}