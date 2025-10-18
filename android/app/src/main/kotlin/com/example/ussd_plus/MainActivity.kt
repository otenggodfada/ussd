package com.example.ussd_plus

import android.Manifest
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val CHANNEL = "ussd_plus/sms"
    private val SMS_PERMISSION_REQUEST_CODE = 1001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSMS" -> {
                    if (checkSmsPermission()) {
                        val smsList = readSMS()
                        result.success(smsList)
                    } else {
                        requestSmsPermission()
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
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.READ_SMS
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestSmsPermission() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.READ_SMS),
            SMS_PERMISSION_REQUEST_CODE
        )
    }

    private fun readSMS(): List<Map<String, Any>> {
        val smsList = mutableListOf<Map<String, Any>>()
        val cursor: Cursor? = contentResolver.query(
            Uri.parse("content://sms/inbox"),
            null,
            null,
            null,
            "date DESC LIMIT 100"
        )

        cursor?.use {
            val bodyIndex = it.getColumnIndexOrThrow("body")
            val addressIndex = it.getColumnIndexOrThrow("address")
            val dateIndex = it.getColumnIndexOrThrow("date")
            val idIndex = it.getColumnIndexOrThrow("_id")

            while (it.moveToNext()) {
                val sms = mapOf(
                    "_id" to it.getString(idIndex),
                    "body" to it.getString(bodyIndex),
                    "address" to it.getString(addressIndex),
                    "date" to it.getString(dateIndex)
                )
                smsList.add(sms)
            }
        }

        return smsList
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        
        when (requestCode) {
            SMS_PERMISSION_REQUEST_CODE -> {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Permission granted, you can now read SMS
                } else {
                    // Permission denied
                }
            }
        }
    }
}
