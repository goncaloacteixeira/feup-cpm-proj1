package org.feup.cpm.group9.acmeshop.adapters

import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import org.feup.cpm.group9.acmeshop.R
import org.feup.cpm.group9.acmeshop.models.Item


class CurrentTransactionAdapter(
    private val itemList: ArrayList<Item>,
    val itemClickListener: (Item) -> Unit,
    val onPayClickListener: (ArrayList<Item>) -> Unit
) : RecyclerView.Adapter<CurrentTransactionAdapter.ViewHolder>() {
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
            holder.bind(itemViewModel)

            holder.name.text = itemViewModel.name
            holder.make.text = itemViewModel.make.uppercase()
            holder.price.text = holder.itemView.context!!.getString(
                R.string.price_template_eur,
                itemViewModel.price * itemViewModel.quantity
            )
            holder.quantity.text = itemViewModel.quantity.toString()

            holder.itemView.setOnClickListener { itemClickListener(itemViewModel) }
        } else {
            holder.bind(null)
            holder.button.text =
                holder.itemView.context!!.getString(R.string.pay_template_eur, calculateTotal())
            holder.button.setOnClickListener {
                onPayClickListener(itemList)
            }
        }
    }

    override fun getItemCount(): Int {
        return if (itemList.isNotEmpty()) itemList.size + 1 else 0
    }

    // Holds the views for adding it to image and text
    class ViewHolder(ItemView: View) : RecyclerView.ViewHolder(ItemView) {
        lateinit var name: TextView
        lateinit var make: TextView
        lateinit var price: TextView
        lateinit var quantity: TextView
        lateinit var button: Button

        fun bind(item: Item?) {
            if (item != null) {
                name = itemView.findViewById(R.id.item_name)
                make = itemView.findViewById(R.id.item_make)
                price = itemView.findViewById(R.id.item_price)
                quantity = itemView.findViewById(R.id.item_quantity)
            } else {
                button = itemView.findViewById(R.id.pay_btn)
            }
        }
    }

    private fun calculateTotal(): Double {
        var total = 0.0
        for (item in itemList) {
            total += item.quantity * item.price
        }
        return total
    }

    fun setItems(items: List<Item>) {
        itemList.clear()
        itemList.addAll(items)
        notifyDataSetChanged()
    }
}