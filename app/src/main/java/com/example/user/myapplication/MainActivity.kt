
package com.example.user.myapplication

import android.os.Bundle
import android.support.design.widget.FloatingActionButton
import android.support.design.widget.Snackbar
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.Toolbar
import android.view.Menu
import android.view.MenuItem
import android.widget.TextView

import com.johnholdsworth.swiftbindings.SwiftHelloBinding.Listener
import com.johnholdsworth.swiftbindings.SwiftHelloBinding.Responder

import com.johnholdsworth.swiftbindings.SwiftHelloTypes.TextListener
import com.johnholdsworth.swiftbindings.SwiftHelloTypes.ListenerMap
import com.johnholdsworth.swiftbindings.SwiftHelloTypes.ListenerMapList
import com.johnholdsworth.swiftbindings.SwiftHelloTypes.StringMap
import com.johnholdsworth.swiftbindings.SwiftHelloTypes.StringMapList

import com.johnholdsworth.swiftbindings.SwiftHelloTest.TestListener
import com.johnholdsworth.swiftbindings.SwiftHelloTest.SwiftTestListener

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
        val context = SwiftApp.sharedApplication.getApplicationContext()
        val cacheDir = context?.getCacheDir()?.getPath()
        val pemfile = cacheDir + "/cacert.pem"
        val pemStream = SwiftApp.sharedApplication.getResources()?.openRawResource(R.raw.cacert)
        copyResource(pemStream, pemfile)
        listener.setCacheDir(cacheDir)

        try {
            listener.throwException()
        }
        catch (e: Exception) {
            System.out.println("**** Got exception ****")
            e.printStackTrace()
        }

        listener.processStringMap( StringMap(hashMapOf("hello" to "world")) )
        listener.processStringMapList( StringMapList(hashMapOf(("hello" to Array(1, {"world"})) )))

        val tester = listener.testResponder(2)
        for (i in 0..9) {
            SwiftTestListener().respond(tester)
        }

        listener.processText("World")
    }

    private fun copyResource(`in`: InputStream?, to: String) {
        try {
            val out = FileOutputStream(to)
            `in`?.copyTo(out)
            `in`?.close()
            out.close()
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

    override fun processedTextListener(text: TextListener) {
        processedText( text.getText() );
    }

    override fun processedTextListenerArray(text: Array<out TextListener>?) {
        processedText( text!![0].getText() );
    }

    override fun processedTextListener2dArray(text: Array<out Array<TextListener>>?) {
        processedText( text!![0][0].getText() );
    }

    override fun processMap(map: ListenerMap?) {
        listener.processedMap( map )
    }

    override fun processMapList(map: ListenerMapList?) {
        listener.processedMapList( map )
    }

    override fun processedStringMap(map: StringMap?) {
        System.out.println("StringMapList: "+map!!)
    }

    override fun processedStringMapList(map: StringMapList?) {
        System.out.println("StringMap: "+map!!)
    }

    override fun debug(msg: String): Array<String> {
        System.out.println("Swift: " + msg)
        return arrayOf("!" + msg, msg + "!")
    }

    override fun testResponder(loopback: Int): TestListener {
        val test = SwiftTestListener()
        if ( loopback > 0 ) {
            test.setLoopback( listener.testResponder(loopback - 1 ) )
        }
        return test
    }

    companion object {

        internal lateinit var listener: Listener

        private fun loadNativeDependencies() {
            // Load libraries
            System.loadLibrary("swifthello")
        }
    }
}

