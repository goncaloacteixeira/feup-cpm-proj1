package org.feup.cpm.group9.acmeshop.adapters

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import org.feup.cpm.group9.acmeshop.R
import org.feup.cpm.group9.acmeshop.models.Transaction

class TransactionsAdapter(private val itemList: ArrayList<Transaction>, private val onItemClickListener: (Transaction) -> Unit): RecyclerView.Adapter<TransactionsAdapter.ViewHolder>() {
    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): TransactionsAdapter.ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.transaction_row, parent, false)

        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val transaction = itemList[position]

        holder.datetime.text = Transaction.formatTimestampToDateTime(transaction.timestamp)
        holder.total.text = holder.itemView.context!!.getString(R.string.price_template_eur, transaction.totalPrice)
        holder.items.text = holder.itemView.context!!.getString(R.string.number_items_template, transaction.items.size)

        holder.itemView.setOnClickListener { onItemClickListener(transaction) }
    }

    override fun getItemCount(): Int {
        return itemList.size
    }

    fun setItems(items: List<Transaction>) {
        itemList.clear()
        itemList.addAll(items)
        notifyDataSetChanged()
    }

    class ViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
        val datetime: TextView = itemView.findViewById(R.id.transaction_datetime)
        val total: TextView = itemView.findViewById(R.id.transaction_total_lbl)
        val items: TextView = itemView.findViewById(R.id.transaction_num_items)
    }
}