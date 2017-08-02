
/// interface com.jh.SwiftHelloBinding$TextListener ///

package org.genie.com_jh;

@SuppressWarnings("JniMissingFunction")
public class SwiftHelloBinding_TextListenerProxy implements com.jh.SwiftHelloBinding.TextListener {

    long __swiftObject;

    SwiftHelloBinding_TextListenerProxy( long __swiftObject ) {
        this.__swiftObject = __swiftObject;
    }

    /// public abstract java.lang.String com.jh.SwiftHelloBinding$TextListener.getText()

    public native java.lang.String __getText( long __swiftObject );

    public java.lang.String getText() {
        return __getText( __swiftObject  );
    }

    public native void __finalize( long __swiftObject );

    public void finalize() {
        __finalize( __swiftObject );
    }

}
