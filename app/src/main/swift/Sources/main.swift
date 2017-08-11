
import java_swift
import Foundation
import Dispatch

// link back to Java side of Application
var responder: SwiftHelloBinding_ResponderForward!

// one-off call to bind the Java and Swift sections of app
@_silgen_name("Java_net_zhuoweizhang_swifthello_SwiftHello_bind")
public func bind_samples( __env: UnsafeMutablePointer<JNIEnv?>, __this: jobject?, __self: jobject? )-> jobject? {

    // This Swift instance forwards to Java through JNI
    responder = SwiftHelloBinding_ResponderForward( javaObject: __self )

    // This Swift instance receives native calls from Java
    var locals = [jobject]()
    return SwiftListenerImpl().localJavaObject( &locals )
}

// kotlin's call to bind the Java and Swift sections of app
@_silgen_name("Java_com_example_user_myapplication_MainActivity_bind_00024app_1debug")
public func bind_kotlin( __env: UnsafeMutablePointer<JNIEnv?>, __this: jobject?, __self: jobject? )-> jobject? {

    // This Swift instance forwards to Java through JNI
    responder = SwiftHelloBinding_ResponderForward( javaObject: __self )

    // This Swift instance receives native calls from Java
    var locals = [jobject]()
    return SwiftListenerImpl().localJavaObject( &locals )
}

struct MyText: SwiftHelloTypes_TextListener {
    let text: String?
    init(_ text: String) {
        self.text = text
    }
    func getText() -> String! {
        return text
    }
}

class SwiftListenerImpl: SwiftHelloBinding_Listener {

    func setCacheDir( cacheDir: String? ) {
        setenv( "URLSessionCAInfo", cacheDir! + "/cacert.pem", 1 )
        setenv( "TMPDIR", cacheDir!, 1 )
        // MyText Proxy object must be loaded
        // on main thread before it is used.
        MyText("").withJavaObject { _ in }
    }

    func testResponder( loopback: Int ) -> SwiftHelloTest_TestListener! {
        let test = SwiftTestListener()
        if loopback > 0 {
            test.setLoopback( loopback: responder.testResponder( loopback: loopback - 1 ) )
        }
        return test
    }

    // incoming from Java activity
    func processNumber( number: Double ) {
        // outgoing back to Java
        responder.processedNumber( number: number+42.0 )
    }

    // incoming from Java activity
    func processText( text: String? ) {
        basicTests(reps: 10)
        processText( text!, initial: true )
    }

    func basicTests(reps: Int) {
        for _ in 0..<reps {
            let tester = responder.testResponder( loopback: 1 )!
            SwiftTestResponder().respond( to: tester )
        }
        for i in 0..<reps {
            var map = [String: SwiftHelloTypes_TextListener]()
            map["KEY\(i)"] = MyText("VALUE\(i)")
            map["KEY\(i+1)"] = MyText("VALUE\(i+1)")
            responder.processMap( map: map )
        }
        for i in 0..<reps {
            var map = [String: [SwiftHelloTypes_TextListener]]()
            map["KEY\(i)"] = [MyText("VALUE\(i)"), MyText("VALUE\(i)a")]
            map["KEY\(i)"] = [MyText("VALUE\(i+1)"), MyText("VALUE\(i+1)a")]
            responder.processMapList( map: map )
        }
    }

    func processedMap( map: [String: SwiftHelloTypes_TextListener]? ) {
        if let map = map {
            for (key, val) in map {
                NSLog( "MAP: \(key) = \(val.getText())" )
            }
        }
    }

    func processedMapList( map: [String: [SwiftHelloTypes_TextListener]]? ) {
        if let map = map {
            for (key, val) in map {
                NSLog( "MAP: \(key) = \(val[0].getText())" )
                NSLog( "MAP: \(key) = \(val[1].getText())" )
            }
        }
    }

    func processStringMap( map: [String: String]? ) {
        NSLog( "processStringMap: \(map!)")
        responder.processedStringMap(map)
    }

    func processStringMapList( map: [String: [String]]? ) {
        NSLog( "processStringMapList: \(map!)")
        responder.processedStringMapList(map)
    }

    func throwException() throws -> Double {
        throw Exception("A test exception")
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
                responder.processedTextListener2dArray( text: [[MyText(out.joined(separator:", "))]] )

                var memory = rusage()
                getrusage( RUSAGE_SELF, &memory )
                NSLog( "Done \(memory.ru_maxrss) \(text)" )
            }
            }.resume()

        if initial {
            SwiftListenerImpl.thread += 1
            let background = SwiftListenerImpl.thread
            DispatchQueue.global().async {
                for i in 1..<50 {
                    NSLog( "Sleeping" )
                    sleep( 5 )
                    // outgoing back to Java
                    _ = responder.debug( msg: "Process \(background)/\(i)" )
                    self.processText( "World #\(i)", initial: false )
                }
            }
        }
    }
}
