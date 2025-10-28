package com.redizeuz.ussdplus

import android.Manifest
import android.content.ContentResolver
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.provider.Telephony
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val CHANNEL = "ussd_plus/sms"
    private val TAG = "MainActivity"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSMS" -> {
                    if (checkSmsPermission()) {
                        try {
                            val smsList = readSMS()
                            result.success(smsList)
                        } catch (e: Exception) {
                            Log.e(TAG, "Error reading SMS: ${e.message}")
                            result.error("SMS_ERROR", "Failed to read SMS: ${e.message}", null)
                        }
                    } else {
                        result.error("PERMISSION_DENIED", "SMS permission not granted", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun checkSmsPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) == PackageManager.PERMISSION_GRANTED
        } else {
            // Pre-Marshmallow devices don't need runtime permissions
            true
        }
    }
    
    private fun readSMS(): List<Map<String, Any>> {
        val smsList = mutableListOf<Map<String, Any>>()
        val contentResolver: ContentResolver = contentResolver
        
        try {
            val cursor: Cursor? = contentResolver.query(
                Telephony.Sms.CONTENT_URI,
                arrayOf(
                    Telephony.Sms._ID,
                    Telephony.Sms.ADDRESS,
                    Telephony.Sms.BODY,
                    Telephony.Sms.DATE
                ),
                null,
                null,
                "${Telephony.Sms.DATE} DESC" // Sort by date descending
            )
            
            cursor?.use {
                val idColumn = it.getColumnIndexOrThrow(Telephony.Sms._ID)
                val addressColumn = it.getColumnIndexOrThrow(Telephony.Sms.ADDRESS)
                val bodyColumn = it.getColumnIndexOrThrow(Telephony.Sms.BODY)
                val dateColumn = it.getColumnIndexOrThrow(Telephony.Sms.DATE)
                
                var count = 0
                while (it.moveToNext() && count < 100) { // Limit to most recent 100 SMS
                    val sms = mapOf(
                        "_id" to it.getLong(idColumn),
                        "address" to (it.getString(addressColumn) ?: ""),
                        "body" to (it.getString(bodyColumn) ?: ""),
                        "date" to it.getLong(dateColumn)
                    )
                    smsList.add(sms)
                    count++
                }
            }
            
            Log.d(TAG, "Read ${smsList.size} SMS messages")
        } catch (e: Exception) {
            Log.e(TAG, "Error reading SMS from content provider: ${e.message}")
            e.printStackTrace()
        }
        
        return smsList
    }
}
