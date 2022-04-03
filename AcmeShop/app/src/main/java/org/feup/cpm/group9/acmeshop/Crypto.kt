package org.feup.cpm.group9.acmeshop

import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import android.util.Log
import java.security.Key
import java.security.KeyPair
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.util.Base64.getDecoder
import javax.crypto.Cipher

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
                    KeyProperties.PURPOSE_SIGN or
                            KeyProperties.PURPOSE_VERIFY or
                            KeyProperties.PURPOSE_ENCRYPT or
                            KeyProperties.PURPOSE_DECRYPT
                )
                    .setDigests(KeyProperties.DIGEST_SHA256)
                    .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_RSA_PKCS1)
                    .setSignaturePaddings(KeyProperties.SIGNATURE_PADDING_RSA_PKCS1)
                    .setKeySize(2048)
                    .build()
            )

            return kpg.generateKeyPair()
        }

        fun loadKey() : KeyPair {
            val keyStore: KeyStore = KeyStore.getInstance("AndroidKeyStore")
            keyStore.load(null)
            if (keyStore.getEntry(alias, null) == null) {
                generateKey()
            }
            val entry: KeyStore.Entry = keyStore.getEntry(alias, null)
            val privateKey = (entry as KeyStore.PrivateKeyEntry).privateKey
            val publicKey = keyStore.getCertificate(alias).publicKey

            return KeyPair(publicKey, privateKey)
        }

        fun decryptToken(tokenEnc: String): String {
            val cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding")
            cipher.init(Cipher.DECRYPT_MODE, loadKey().private)
            return String(cipher.doFinal(Base64.decode(tokenEnc, Base64.DEFAULT)))
        }
    }
}