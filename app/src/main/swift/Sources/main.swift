
import java_swift
import Foundation
import Dispatch
import sqlite3

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

    var handle: OpaquePointer? = nil

    func setCacheDir( cacheDir: String? ) {
        setenv( "TMPDIR", cacheDir!, 1 )

        // Required for SSL to work
        setenv( "URLSessionCAInfo", cacheDir! + "/cacert.pem", 1 )

        // MyText Proxy object must be loaded
        // on main thread before it is used.
        MyText("").withJavaObject { _ in }

        // Quick SQLite test
        NSLog("Open db: \(sqlite3_open(cacheDir!+"sqltest.db", &handle) == SQLITE_OK)")

        NSLog("Create table: \(sqlite3_exec(handle, """
            CREATE TABLE Test (
            Text TEXT
            )
            """, nil, nil, nil) == SQLITE_OK)")

        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .long
        f.timeZone = TimeZone.current

        var stmt: OpaquePointer?
        NSLog("Insert: \(sqlite3_prepare_v2(handle, """
            INSERT INTO Test (Text)
            VALUES (?);
            """, -1, &stmt, nil) == SQLITE_OK)")
        sqlite3_bind_text(stmt, 1, f.string(from: Date()), -1, nil)
        sqlite3_step(stmt)
        sqlite3_finalize(stmt)

        NSLog("Select: \(sqlite3_prepare_v2( handle, """
            SELECT Text
            FROM Test
            """, -1, &stmt, nil) == SQLITE_OK)")
        while sqlite3_step(stmt) == SQLITE_ROW {
            if let text = sqlite3_column_text(stmt, 0) {
                NSLog("Run: \(String(cString: text))")
            }
            else {
                NSLog("Null row")
            }
        }
        sqlite3_finalize(stmt)
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
        let uuidA = NSUUID()
        let uuidB = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: uuidA)) as! NSUUID

        basicTests(reps: 10)
        processText( text!, initial: true )
    }

    func basicTests(reps: Int) {
        for _ in 0..<reps {
            do {
                _ = try responder.throwException()
            }
            catch let e as Exception {
                NSLog( "*** Got Java Exception ***" )
                e.printStackTrace()
            }
            catch {
                NSLog( "Other Java Exception" )
            }
        }
        for _ in 0..<reps {
            let a = SwiftHelloTypes_Planet.MERCURY
            NSLog("Enum: \(a.surfaceWeight( 175.0/SwiftHelloTypes_Planet.EARTH.surfaceGravity() ))")
        }
        for _ in 0..<reps {
            let tester = responder.testResponder( loopback: 1 )!
            SwiftTestResponder().respond( to: tester )
        }
        for i in 0..<reps {
            var map = [String: SwiftHelloTypes_TextListener]()
            for j in 0..<10 {
                map["KEY\(i+j)"] = MyText("VALUE\(i+j)")
            }
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
        throw Exception("Swift test exception")
    }

    static var thread = 0
    var i = 0
    let session = URLSession( configuration: .default )
    let url = URL( string: "https://en.wikipedia.org/wiki/Main_Page" )!
    let regexp = try! NSRegularExpression( pattern:"(\\w+)", options:[] )

    func processText( _ text: String, initial: Bool ) {
        var out = [String]()
        for _ in 0..<10 {
            out.append( "Hello "+text+"!" )
        }

        do {
            var enc: UInt = 0
            let input = try NSString( contentsOf: url, usedEncoding: &enc )
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
        catch (let e) {
            responder.processedText("\(e)")
        }

        if initial {
            SwiftListenerImpl.thread += 1
            let background = SwiftListenerImpl.thread
            DispatchQueue.global(qos: .background).async {
                for i in 1..<100 {
                    NSLog( "Sleeping" )
                    Thread.sleep(forTimeInterval: 10)

                    // outgoing back to Java
                    _ = responder.debug( msg: "Process \(background)/\(i)" )
                    self.processText( "World #\(i)", initial: false )

                    Thread.sleep(forTimeInterval: 10)
                    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
                    self.session.dataTask( with: URLRequest( url: url ) ) {
                        (data, response, error) in
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data)
                                let text = try JSONSerialization.data(withJSONObject: json)
                                responder.processedText( String( data: text, encoding: .utf8 ) )
                            }
                            catch let e {
                                responder.processedText( "\(e)" )
                            }
                        }
                        else {
                            responder.processedText( "\(String(describing: error))" )
                        }
                        }.resume()
                }
            }
        }
    }
}

