
import java_swift
import Foundation

public class SwiftTestListener: SwiftHelloTest_TestListenerBase {

    override public func booleanMethod( arg: Bool ) -> Bool {
        return arg
    }

    override public func booleanArrayMethod( arg: [Bool]? ) -> [Bool]? {
        return arg
    }

    override public func boolean2dArrayMethod( arg: [[Bool]]? ) -> [[Bool]]? {
        return arg
    }

    override public func byteMethod( arg: Int8 ) -> Int8 {
        return arg
    }

    override public func byteArrayMethod( arg: [Int8]? ) -> [Int8]? {
        return arg
    }

    override public func byte2dArrayMethod( arg: [[Int8]]? ) -> [[Int8]]? {
        return arg
    }

    override public func charMethod( arg: UInt16 ) -> UInt16 {
        return arg
    }

    override public func charArrayMethod( arg: [UInt16]? ) -> [UInt16]? {
        return arg
    }

    override public func char2dArrayMethod( arg: [[UInt16]]? ) -> [[UInt16]]? {
        return arg
    }

    override public func shortMethod( arg: Int16 ) -> Int16 {
        return arg
    }

    override public func shortArrayMethod( arg: [Int16]? ) -> [Int16]? {
        return arg
    }

    override public func short2dArrayMethod( arg: [[Int16]]? ) -> [[Int16]]? {
        return arg
    }

    override public func intMethod( arg: Int ) -> Int {
        return arg
    }

    override public func intArrayMethod( arg: [Int32]? ) -> [Int32]? {
        return arg
    }

    override public func int2dArrayMethod( arg: [[Int32]]? ) -> [[Int32]]? {
        return arg
    }

    override public func longMethod( arg: Int64 ) -> Int64 {
        return arg
    }

    override public func longArrayMethod( arg: [Int64]? ) -> [Int64]? {
        return arg
    }

    override public func long2dArrayMethod( arg: [[Int64]]? ) -> [[Int64]]? {
        return arg
    }

    override public func floatMethod( arg: Float ) -> Float {
        return arg
    }

    override public func floatArrayMethod( arg: [Float]? ) -> [Float]? {
        return arg
    }

    override public func float2dArrayMethod( arg: [[Float]]? ) -> [[Float]]? {
        return arg
    }

    override public func doubleMethod( arg: Double ) -> Double {
        return arg
    }

    override public func doubleArrayMethod( arg: [Double]? ) -> [Double]? {
        return arg
    }

    override public func double2dArrayMethod( arg: [[Double]]? ) -> [[Double]]? {
        return arg
    }

    override public func StringMethod( arg: String? ) -> String? {
        return arg
    }

    override public func StringArrayMethod( arg: [String]? ) -> [String]? {
        return arg
    }

    override public func String2dArrayMethod( arg: [[String]]? ) -> [[String]]? {
        return arg
    }

}

public class SwiftTestResponder {

    static var tcount = 0

    public func respond( to responder: SwiftHelloTest_TestListener ) {
        SwiftTestResponder.tcount += 1
        NSLog("Testing \(SwiftTestResponder.tcount)...")

        if true {
            let reference: Bool = true
            let referenceArray = [(reference)]
            //let reference2dArray = [referenceArray]

            let response = responder.booleanMethod( reference )
            if response != reference {
                NSLog("Bool: \(response) != \(reference)")
            }
            let responseArray = responder.booleanArrayMethod( referenceArray )!
            if responseArray != referenceArray {
                NSLog("Bool: \(responseArray) != \(referenceArray)")
            }
            //_ = responder.boolean2dArrayMethod( reference2dArray )
        }

        if true {
            let reference: Int8 = 123
            let referenceArray = [(reference)]
            //let reference2dArray = [referenceArray]

            let response = responder.byteMethod( reference )
            if response != reference {
                NSLog("Int8: \(response) != \(reference)")
            }
            let responseArray = responder.byteArrayMethod( referenceArray )!
            if responseArray != referenceArray {
                NSLog("Int8: \(responseArray) != \(referenceArray)")
            }
            //_ = responder.byte2dArrayMethod( reference2dArray )
        }

        if true {
            let reference: UInt16 = 123
            let referenceArray = [(reference)]
            //let reference2dArray = [referenceArray]

            let response = responder.charMethod( reference )
            if response != reference {
                NSLog("UInt16: \(response) != \(reference)")
            }
            let responseArray = responder.charArrayMethod( referenceArray )!
            if responseArray != referenceArray {
                NSLog("UInt16: \(responseArray) != \(referenceArray)")
            }
            //_ = responder.char2dArrayMethod( reference2dArray )
        }

        if true {
            let reference: Int16 = 123
            let referenceArray = [(reference)]
            //let reference2dArray = [referenceArray]

            let response = responder.shortMethod( reference )
            if response != reference {
                NSLog("Int16: \(response) != \(reference)")
            }
            let responseArray = responder.shortArrayMethod( referenceArray )!
            if responseArray != referenceArray {
                NSLog("Int16: \(responseArray) != \(referenceArray)")
            }
            //_ = responder.short2dArrayMethod( reference2dArray )
        }

        if true {
            let reference: Int = 123
            let referenceArray = [Int32(reference)]
            //let reference2dArray = [referenceArray]

            let response = responder.intMethod( reference )
            if response != reference {
                NSLog("Int: \(response) != \(reference)")
            }
            let responseArray = responder.intArrayMethod( referenceArray )!
            if responseArray != referenceArray {
                NSLog("Int: \(responseArray) != \(referenceArray)")
            }
            //_ = responder.int2dArrayMethod( reference2dArray )
        }

        if true {
            let reference: Int64 = 123
            let referenceArray = [(reference)]
            //let reference2dArray = [referenceArray]

            let response = responder.longMethod( reference )
            if response != reference {
                NSLog("Int64: \(response) != \(reference)")
            }
            let responseArray = responder.longArrayMethod( referenceArray )!
            if responseArray != referenceArray {
                NSLog("Int64: \(responseArray) != \(referenceArray)")
            }
            //_ = responder.long2dArrayMethod( reference2dArray )
        }

        if true {
            let reference: Float = 123
            let referenceArray = [(reference)]
            //let reference2dArray = [referenceArray]

            let response = responder.floatMethod( reference )
            if response != reference {
                NSLog("Float: \(response) != \(reference)")
            }
            let responseArray = responder.floatArrayMethod( referenceArray )!
            if responseArray != referenceArray {
                NSLog("Float: \(responseArray) != \(referenceArray)")
            }
            //_ = responder.float2dArrayMethod( reference2dArray )
        }

        if true {
            let reference: Double = 123
            let referenceArray = [(reference)]
            //let reference2dArray = [referenceArray]

            let response = responder.doubleMethod( reference )
            if response != reference {
                NSLog("Double: \(response) != \(reference)")
            }
            let responseArray = responder.doubleArrayMethod( referenceArray )!
            if responseArray != referenceArray {
                NSLog("Double: \(responseArray) != \(referenceArray)")
            }
            //_ = responder.double2dArrayMethod( reference2dArray )
        }

        if true {
            let reference: String = "123"
            let referenceArray = [(reference)]
            //let reference2dArray = [referenceArray]

            let response = responder.StringMethod( reference )
            if response != reference {
                NSLog("String: \(response ?? "nil") != \(reference)")
            }
            let responseArray = responder.StringArrayMethod( referenceArray )!
            if responseArray != referenceArray {
                NSLog("String: \(responseArray) != \(referenceArray)")
            }
            //_ = responder.String2dArrayMethod( reference2dArray )
        }

    }

}
