package org.feup.cpm.group9.acmeshop.ui.transactions

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import org.feup.cpm.group9.acmeshop.R
import org.feup.cpm.group9.acmeshop.TransactionActivity
import org.feup.cpm.group9.acmeshop.adapters.TransactionsAdapter
import org.feup.cpm.group9.acmeshop.databinding.FragmentTransactionsBinding
import org.feup.cpm.group9.acmeshop.models.Transaction
import org.feup.cpm.group9.acmeshop.ui.home.HomeViewModel

class TransactionsFragment : Fragment() {

    private var _binding: FragmentTransactionsBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!
    private lateinit var adapter: TransactionsAdapter
    private lateinit var transactionsViewModel: TransactionsViewModel

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        val factory = object : ViewModelProvider.Factory {
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                return  TransactionsViewModel(activity!!.application, activity!!.intent.extras?.get("uuid") as String) as T
            }
        }

        transactionsViewModel = ViewModelProvider(this, factory)[TransactionsViewModel::class.java]

        _binding = FragmentTransactionsBinding.inflate(inflater, container, false)
        val root: View = binding.root

        adapter = TransactionsAdapter(arrayListOf(), this::openTransaction)

        transactionsViewModel.user.observe(viewLifecycleOwner) {
            adapter.setItems(it.transactions)
        }
        return root
    }

    override fun onResume() {
        transactionsViewModel.updateUser(requireActivity().intent.extras?.get("uuid") as String)
        super.onResume()
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val recyclerView = view.findViewById<RecyclerView>(R.id.prev_transactions_rv)
        recyclerView.layoutManager = LinearLayoutManager(requireContext())
        recyclerView.adapter = adapter

        super.onViewCreated(view, savedInstanceState)
    }

    private fun openTransaction(transaction: Transaction) {
        val intent = Intent(requireContext(), TransactionActivity::class.java)
        intent.putExtra("transaction", transaction)
        intent.putExtra("items", transaction.items)
        startActivity(intent)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}