package org.feup.cpm.group9.acmeshop

import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import java.security.*
import java.util.*

class Crypto {


    companion object {
        private const val alias = "ACME_KEY"

        fun generateKey(): KeyPair {
            val kpg = KeyPairGenerator.getInstance(
                KeyProperties.KEY_ALGORITHM_RSA, "AndroidKeyStore"
            )

            kpg.initialize(
                KeyGenParameterSpec.Builder(
                    alias,
                    KeyProperties.PURPOSE_SIGN or KeyProperties.PURPOSE_VERIFY or KeyProperties.PURPOSE_ENCRYPT
                )
                    .setDigests(KeyProperties.DIGEST_SHA256, KeyProperties.DIGEST_SHA512)
                    .setKeySize(2048)
                    .build()
            )

            return kpg.generateKeyPair()
        }

        fun loadKey() : PrivateKey {
            val keyStore: KeyStore = KeyStore.getInstance("AndroidKeyStore")
            keyStore.load(null)
            val entry: KeyStore.Entry = keyStore.getEntry(alias, null)
            return (entry as KeyStore.PrivateKeyEntry).privateKey
        }
    }
}