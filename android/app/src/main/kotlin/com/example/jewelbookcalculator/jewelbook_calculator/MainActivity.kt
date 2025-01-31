package com.example.jewelbook_bapa

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.jewelbook_bapa/android_id"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAndroidId") {
                val androidId = getAndroidId()
                result.success(androidId)
            } else if (call.method == "shareToWhatsApp") {
                val pdfPath = call.argument<String>("pdfPath")
                pdfPath?.let {
                    shareToWhatsApp(it)
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getAndroidId(): String {
        return Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
    }

    private fun shareToWhatsApp(pdfPath: String) {
        val file = File(pdfPath)
        if (file.exists()) {
            // Create URI for the file using FileProvider
            val uri: Uri = FileProvider.getUriForFile(
                this,
                "com.example.jewelbook_bapa.fileprovider",
                file
            )

            // Create intent to share the file with WhatsApp
            val intent = Intent(Intent.ACTION_SEND)
            intent.type = "application/pdf"
            intent.putExtra(Intent.EXTRA_STREAM, uri)
            intent.putExtra(Intent.EXTRA_TEXT, "Bill")
            intent.setPackage("com.whatsapp") // Ensure the intent is sent to WhatsApp

            // Handle the intent execution
            try {
                startActivity(Intent.createChooser(intent, "Share PDF to WhatsApp"))
            } catch (e: Exception) {
                Log.e("MainActivity", "WhatsApp is not installed or URL cannot be launched.")
            }
        } else {
            // Log or handle the case where the file doesn't exist
            Log.e("MainActivity", "File does not exist at path: $pdfPath")
        }
    }
}
