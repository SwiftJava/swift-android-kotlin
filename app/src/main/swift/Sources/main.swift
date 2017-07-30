
import java_swift
@_exported import Foundation
import Dispatch

// link back to Java side of Application
var responder: SwiftHelloBinding_ResponderForward!

// one-off call to bind the Java and Swift sections of app
@_silgen_name("Java_com_example_user_myapplication_MainActivity_bind_00024app_1debug")
public func bind( __env: UnsafeMutablePointer<JNIEnv?>, __this: jobject?, __self: jobject? )-> jobject? {
    // This Swift instance forwards to Java through JNI
    responder = SwiftHelloBinding_ResponderForward( javaObject: __self )
    // This Swift instance receives native calls from Java
    return SwiftListenerImpl().javaObject
}

class SwiftListenerImpl: SwiftHelloBinding_ListenerBase {

    override func setCacheDir( cacheDir: String? ) {
        setenv( "URLSessionCAInfo", cacheDir! + "/cacert.pem", 1 )
        setenv( "TMPDIR", cacheDir!, 1 )
    }

    // incoming from Java activity
    override func processNumber( number: Double ) {
        // outgoing back to Java
        responder.processedNumber( number+42.0 )
    }

    // incoming from Java activity
    override func processText( text: String? ) {
        for _ in 0..<100 {
            let tester = responder.testResponder()!
            SwiftTestResponder().respond( to: tester )
        }
        processText( text!, initial: true )
    }

    static var thread = 0
    let session = URLSession( configuration: .default )
    let url = URL( string: "https://en.wikipedia.org/wiki/Main_Page" )!
    let regexp = try! NSRegularExpression( pattern:"(\\w+)", options:[] )

    func processText( _ text: String, initial: Bool ) {
        var out = [String]()
        for _ in 0..<10 {
            out.append( "Hello "+text+"!" )
        }

        session.dataTask( with: URLRequest( url: url ) ) {
            (data, response, error) in
            NSLog( "Response: \(data?.count ?? -1) \(String( describing: error ))")
            if let data = data, let input = NSString( data: data, encoding: String.Encoding.utf8.rawValue ) {
                for match in self.regexp.matches( in: String( describing: input ), options: [],
                                                  range: NSMakeRange( 0, input.length ) ) {
                    out.append( "\(input.substring( with: match.range ))" )
                }

                NSLog( "Display" )
                // outgoing back to Java
                responder.processedText( out.joined(separator:", ") )

                var memory = rusage()
                getrusage( RUSAGE_SELF, &memory )
                NSLog( "Done \(memory.ru_maxrss) \(text)" )
            }
        }.resume()

        if initial {
            SwiftListenerImpl.thread += 1
            let background = SwiftListenerImpl.thread
            DispatchQueue.global().async {
                for i in 1..<5000 {
                    NSLog( "Sleeping" )
                    sleep( 2 )
                    // outgoing back to Java
                    _ = responder.debug( "Process \(background)/\(i)" )
                    self.processText( "World #\(i)", initial: false )
                }
            }
        }
    }
}
