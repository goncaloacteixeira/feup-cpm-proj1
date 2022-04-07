package org.feup.cpm.group9.acmeshop.ui.home

import android.app.Dialog
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.*
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.room.Room
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanIntentResult
import com.journeyapps.barcodescanner.ScanOptions
import org.feup.cpm.group9.acmeshop.R
import org.feup.cpm.group9.acmeshop.TransactionActivity
import org.feup.cpm.group9.acmeshop.adapters.CurrentTransactionAdapter
import org.feup.cpm.group9.acmeshop.database.AppDatabase
import org.feup.cpm.group9.acmeshop.databinding.FragmentHomeBinding
import org.feup.cpm.group9.acmeshop.models.Item
import org.feup.cpm.group9.acmeshop.models.User
import java.util.*
import kotlin.collections.ArrayList


class HomeFragment : Fragment() {
    private val TAG = "HomeFragment"
    private var _binding: FragmentHomeBinding? = null
    private lateinit var db: AppDatabase

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!
    private lateinit var adapter: CurrentTransactionAdapter
    private lateinit var homeViewModel: HomeViewModel

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

        homeViewModel = ViewModelProvider(this, factory)[HomeViewModel::class.java]


        db = AppDatabase.getInstance(requireContext())

        // ArrayList of class ItemsViewModel
        val data = ArrayList<Item>()

        // This will pass the ArrayList to our Adapter
        adapter = CurrentTransactionAdapter(data, this::showDialog, this::pay)

        // define a menu for the fragment
        setHasOptionsMenu(true)

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

        homeViewModel.getPurchaseItems().observe(viewLifecycleOwner) {
            Log.d(TAG, "onCreateView: new update: $it")
            adapter.setItems(it)
        }

        return root
    }

    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        // Inflate the menu; this adds items to the action bar if it is present.
        inflater.inflate(R.menu.home_page, menu)
        super.onCreateOptionsMenu(menu, inflater)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.action_dev_add_item -> {
                val id = (0..500).random().toString()
                Item.getItemByUUID(requireContext(), id) {
                    if (it != null) {
                        db.itemDao().insertAll(it)
                    }
                }
            }
        }

        return false
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        // getting the recyclerview by its id
        val recyclerview = view.findViewById<RecyclerView>(R.id.home_current_transaction_rv)

        // this creates a vertical layout Manager
        recyclerview.layoutManager = LinearLayoutManager(requireContext())

        // Setting the Adapter with the recyclerview
        recyclerview.adapter = adapter

        val barcodeLauncher = registerForActivityResult(ScanContract()) { result: ScanIntentResult ->
            if (result.contents == null) {
                Toast.makeText(requireContext(), "Cancelled", Toast.LENGTH_LONG).show()
            } else {
                Toast.makeText(
                    requireContext(),
                    "Scanned: " + result.contents,
                    Toast.LENGTH_LONG
                ).show()

                Item.getItemByBarcode(requireContext(), result.contents.toLong()) {item ->
                    if (item != null) {
                        db.itemDao().insertAll(item)
                    }
                }
            }
        }

        view.findViewById<FloatingActionButton>(R.id.add_item_fab).setOnClickListener {
            val options = ScanOptions()
            options.setDesiredBarcodeFormats(ScanOptions.UPC_A)
            options.setOrientationLocked(false)
            options.setBeepEnabled(false)
            options.setBarcodeImageEnabled(true)
            barcodeLauncher.launch(options)
        }

        super.onViewCreated(view, savedInstanceState)
    }

    private fun showDialog(item: Item) {
        val dialog = Dialog(requireContext())
        
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        dialog.setCancelable(true)
        dialog.setContentView(R.layout.basket_item_dialog)
        val name = dialog.findViewById(R.id.basket_item_name) as TextView
        val make = dialog.findViewById(R.id.basket_item_make) as TextView
        val description = dialog.findViewById(R.id.basket_item_description) as TextView
        val quantity = dialog.findViewById(R.id.basket_item_quantity) as TextView

        name.text = item.name
        make.text = item.make.uppercase()
        description.text = item.description
        quantity.text = item.quantity.toString()

        val increaseBtn = dialog.findViewById<Button>(R.id.basket_increase_btn)
        val decreaseBtn = dialog.findViewById<Button>(R.id.basket_decrease_btn)
        val removeBtn = dialog.findViewById<Button>(R.id.basket_remove_item_btn)
        increaseBtn.setOnClickListener {
            quantity.text = (quantity.text.toString().toInt() + 1).toString()
        }
        decreaseBtn.setOnClickListener {
            if (quantity.text.toString().toInt() > 1) {
                quantity.text = (quantity.text.toString().toInt() - 1).toString()
            }
        }
        removeBtn.setOnClickListener {
            quantity.text = "0"
            dialog.dismiss()
        }
        
        dialog.setOnDismissListener {
            Log.d(TAG, "showDialog: dismissed")
            item.quantity = quantity.text.toString().toInt()

            if (item.quantity == 0) {
                db.itemDao().remove(item)
            } else {
                Log.d(TAG, "showDialog: updated: $item")
                db.itemDao().update(item)
            }
        }

        dialog.show()
    }

    private fun pay(items: ArrayList<Item>) {
        User.pay(requireContext(), requireActivity().intent.extras?.get("uuid") as String, items) { tr ->
            if (tr != null) {
                // Start Transaction Activity
                val intent = Intent(requireContext(), TransactionActivity::class.java)
                intent.putExtra("transaction", tr)
                intent.putExtra("items", tr.items)

                Toast.makeText(context, "Transaction completed", Toast.LENGTH_LONG).show()

                startActivity(intent)

                db.itemDao().clearTable()
                homeViewModel.updateUser( requireActivity().intent.extras?.get("uuid") as String)
            } else {
                Toast.makeText(context, "Transaction failed!", Toast.LENGTH_LONG).show()
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}