package com.example.user.myapplication

import android.os.Bundle
import android.support.design.widget.FloatingActionButton
import android.support.design.widget.Snackbar
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.Toolbar
import android.view.Menu
import android.view.MenuItem
import android.widget.TextView

import com.jh.SwiftHello.Listener
import com.jh.SwiftHello.Responder
import com.jh.SwiftHelloTest.TestListener
import com.jh.SwiftHelloTest.TestResponderImpl

import java.io.*

class MainActivity : AppCompatActivity(), Responder {

    /** Implemented in src/main/swift/Sources/main.swift **/

    internal external fun bind(self: Responder): Listener

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val toolbar = findViewById(R.id.toolbar) as Toolbar
        setSupportActionBar(toolbar)

        val fab = findViewById(R.id.fab) as FloatingActionButton
        fab.setOnClickListener { view ->
            Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                    .setAction("Action", null).show()
        }
        loadNativeDependencies()
        listener = bind(this)
        val context = SwiftApp.sharedApplication?.getApplicationContext()
        val cacheDir = context?.getCacheDir()?.getPath()
        val pemfile = cacheDir + "/cacert.pem"
        val pemStream = SwiftApp.sharedApplication?.getResources()?.openRawResource(R.raw.cacert)
        copyResource(pemStream, pemfile)
        listener.setCacheDir(cacheDir)
        listener.processText("World")
    }

    private fun copyResource(`in`: InputStream?, to: String) {
        try {
            val out = FileOutputStream(to)
            `in`?.copyTo(out)
            `in`?.close()
            out?.close()
        } catch (e: IOException) {
            e.printStackTrace()
            System.out.println("" + e)
        }

    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        val id = item.itemId


        if (id == R.id.action_settings) {
            return true
        }

        return super.onOptionsItemSelected(item)
    }

    override fun processedNumber(number: Double) {
        val myText = findViewById(R.id.mytext) as TextView
        myText.text = "Result of swift return42() function is " + number
    }

    override fun processedText(text: String) {
        runOnUiThread {
            val myText = findViewById(R.id.mytext) as TextView
            myText.text = "Processed text: " + text
        }
    }

    override fun debug(msg: String): Array<String> {
        System.out.println("Swift: " + msg)
        return arrayOf("!" + msg, msg + "!")
    }

    override fun testResponder(): TestListener {
        return TestResponderImpl()
    }

    companion object {

        internal lateinit var listener: Listener

        private fun loadNativeDependencies() {
            // Load libraries
            System.loadLibrary("swifthello")
        }
    }
}
