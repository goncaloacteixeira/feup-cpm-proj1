package org.feup.cpm.group9.acmeshopterminal.adapters

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import org.feup.cpm.group9.acmeshopterminal.R
import org.feup.cpm.group9.acmeshopterminal.models.Item

class TransactionAdapter(private val itemList: ArrayList<Item>): RecyclerView.Adapter<TransactionAdapter.ViewHolder>() {
    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_row, parent, false)

        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val itemViewModel = itemList[position]

        holder.name.text = itemViewModel.name
        holder.make.text = itemViewModel.make.uppercase()
        holder.price.text = holder.itemView.context!!.getString(
            R.string.price_template_eur,
            itemViewModel.price * itemViewModel.quantity
        )
        holder.quantity.text = itemViewModel.quantity.toString()
    }

    class ViewHolder(ItemView: View) : RecyclerView.ViewHolder(ItemView) {
        val name: TextView = itemView.findViewById(R.id.item_name)
        val make: TextView = itemView.findViewById(R.id.item_make)
        val price: TextView = itemView.findViewById(R.id.item_price)
        val quantity: TextView = itemView.findViewById(R.id.item_quantity)
    }

    override fun getItemCount(): Int {
        return itemList.size
    }

}