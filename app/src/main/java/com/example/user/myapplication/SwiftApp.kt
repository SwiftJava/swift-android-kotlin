package com.example.user.myapplication

import android.app.Application

class SwiftApp : Application() {

    override fun onCreate() {
        super.onCreate()
        sharedApplication = this
    }

    companion object {

        var sharedApplication: Application? = null
            private set
    }
}
