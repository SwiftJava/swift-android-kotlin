// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "swifthello",
    products: [
        .library(name: "swifthello", type: .dynamic, targets: ["swifthello"])
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftJava/java_swift.git", "2.1.1"..<"3.0.0"),
        .package(url: "https://github.com/SwiftJava/swift-android-sqlite.git", from: "1.0.0"),
        .package(url: "https://github.com/SwiftJava/Alamofire.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "swifthello",
            dependencies: ["java_swift", "Alamofire"],
            path: "Sources"
        ),
    ]
)
