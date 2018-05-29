package com.example.user.myapplication;

import android.opengl.GLSurfaceView;

import com.johnholdsworth.swiftbindings.SwiftHelloBinding;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

/**
 * Created by user on 29/05/2018.
 */

public class RendererWrapper implements GLSurfaceView.Renderer {

    SwiftHelloBinding.RenderListener listener;

    RendererWrapper(SwiftHelloBinding.RenderListener aListener) {
        listener =  aListener;
    }


    @Override
    public void onSurfaceCreated(GL10 gl10, EGLConfig eglConfig) {
        listener.onSurfaceCreated();
    }

    @Override
    public void onSurfaceChanged(GL10 gl10, int width, int height) {
        listener.onSurfaceChanged(width, height);

    }

    @Override
    public void onDrawFrame(GL10 gl10) {
        listener.onDrawFrame();
    }
}
