package org.feup.cpm.group9.acmeshop.ui.home

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.floatingactionbutton.FloatingActionButton
import org.feup.cpm.group9.acmeshop.R
import org.feup.cpm.group9.acmeshop.adapters.CurrentTransactionAdapter
import org.feup.cpm.group9.acmeshop.databinding.FragmentHomeBinding
import org.feup.cpm.group9.acmeshop.models.Item
import java.util.*
import kotlin.collections.ArrayList

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
        val factory = object : ViewModelProvider.Factory {
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                return  HomeViewModel(activity!!.application, activity!!.intent.extras?.get("uuid") as String) as T
            }
        }

        val homeViewModel : HomeViewModel by lazy {
            ViewModelProvider(this, factory)[HomeViewModel::class.java]
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

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        // getting the recyclerview by its id
        val recyclerview = view.findViewById<RecyclerView>(R.id.home_current_transaction_rv)

        // this creates a vertical layout Manager
        recyclerview.layoutManager = LinearLayoutManager(requireContext())

        // ArrayList of class ItemsViewModel
        val data = ArrayList<Item>()

        for (i in 1..20) {
            data.add(Item(UUID.randomUUID().toString(), "Example name", "Example Description", 123123123123, 11.52))
        }

        // This will pass the ArrayList to our Adapter
        val adapter = CurrentTransactionAdapter(data)

        // Setting the Adapter with the recyclerview
        recyclerview.adapter = adapter


        view.findViewById<FloatingActionButton>(R.id.add_item_fab).setOnClickListener {
            adapter.addItem(Item(UUID.randomUUID().toString(), "Added by FAB", "Example Description", 123123123123, 25.0))
        }

        super.onViewCreated(view, savedInstanceState)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}