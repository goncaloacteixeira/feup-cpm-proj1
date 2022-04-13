package org.feup.cpm.group9.acmeshopterminal

import android.nfc.NfcAdapter.ReaderCallback
import android.nfc.Tag
import android.nfc.tech.IsoDep
import android.util.Log
import java.io.IOException
import java.util.*

private const val AID = "F0010203040506"
private const val SELECT_APDU_HEADER = "00A40400"
private val SELECT_OK_SW = byteArrayOf(0x90.toByte(), 0x00.toByte())

class CardReader(private val dataCallback: (String) -> Unit) : ReaderCallback {
  override fun onTagDiscovered(tag: Tag) {
    val isoDep = IsoDep.get(tag)                                 // Android smartcard reader emulator
    if (isoDep != null) {
      try {
        isoDep.connect()                                         // establish a connection with the card
        val result = isoDep.transceive(BuildSelectApdu(AID))    // send 'select AID x' and get result
        val rLen = result.size
        val status = byteArrayOf(result[rLen - 2], result[rLen - 1])
        val payload = Arrays.copyOf(result, rLen - 2)
        if (Arrays.equals(SELECT_OK_SW, status)) {
          val data = String(payload, Charsets.UTF_8)
          dataCallback(data)
        }
      } catch (e: IOException) {
        Log.e("CardReader", "Error communicating with card: $e")
      }
    }
  }

  private fun BuildSelectApdu(aid: String): ByteArray {
    return HexStringToByteArray(SELECT_APDU_HEADER + String.format("%02X", aid.length / 2) + aid)
  }

  private fun HexStringToByteArray(s: String): ByteArray {
    val data = ByteArray(s.length / 2)
    var k = 0
    while (k < s.length) {
      data[k / 2] = ((Character.digit(s[k], 16) shl 4) + Character.digit(s[k + 1], 16)).toByte()
      k += 2
    }
    return data
  }
}
