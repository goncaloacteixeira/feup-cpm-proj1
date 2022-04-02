package org.feup.cpm.group9.acmeshop.adapters

import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import org.feup.cpm.group9.acmeshop.R
import org.feup.cpm.group9.acmeshop.models.Item


class CurrentTransactionAdapter(private val itemList: ArrayList<Item>) : RecyclerView.Adapter<CurrentTransactionAdapter.ViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        return if (viewType == R.layout.item_row) {
            val view = LayoutInflater.from(parent.context)
                .inflate(R.layout.item_row, parent, false)

            ViewHolder(view)
        } else {
            val view = LayoutInflater.from(parent.context)
                .inflate(R.layout.pay_btn_row, parent, false)

            ViewHolder(view)
        }
    }

    override fun getItemViewType(position: Int): Int {
        return if (position == itemList.size) R.layout.pay_btn_row else R.layout.item_row
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        if (position != itemList.size) {
            val itemViewModel = itemList[position]
            holder.name?.text = itemViewModel.name
            holder.description?.text = itemViewModel.description
            holder.price?.text = holder.itemView.context!!.getString(R.string.price_template_eur, itemViewModel.price * itemViewModel.quantity)
            holder.quantity?.text = itemViewModel.quantity.toString()

        } else {
            holder.button?.setOnClickListener {


            }
        }
    }

    override fun getItemCount(): Int {
        return if (itemList.isNotEmpty()) itemList.size + 1 else 0
    }

    // Holds the views for adding it to image and text
    class ViewHolder(ItemView: View) : RecyclerView.ViewHolder(ItemView) {
        val name: TextView? = itemView.findViewById(R.id.item_name)
        val description: TextView? = itemView.findViewById(R.id.item_description)
        val price: TextView? = itemView.findViewById(R.id.item_price)
        val quantity: TextView? = itemView.findViewById(R.id.item_quantity)

        // button
        val button: Button? = itemView.findViewById(R.id.pay_btn)
    }

    fun addItem(item: Item) {
        Log.d("HomeAdapter", "addItem: $item")
        if (itemList.contains(item)) {
            val index = itemList.indexOf(item)
            itemList[index].quantity++
            notifyItemChanged(index)
        } else {
            itemList.add(item)
            notifyItemInserted(itemList.size)
        }
    }
}