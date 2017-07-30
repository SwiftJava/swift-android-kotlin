
package com.jh;

public interface SwiftHelloBinding {

    public interface Listener {

        public void setCacheDir( String cacheDir );

        public void processNumber( double number );

        public void processText( String text );

    }

    public interface Responder {

        public void processedNumber( double number );

        public void processedText( String text );

        public String[] debug( String msg );

        public SwiftHelloTest.TestListener testResponder();

    }

}
