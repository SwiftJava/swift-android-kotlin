// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "swifthello",
    products:[
        .library(
            name: "swifthello", 
            type: .dynamic, 
            targets:["swifthello"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftJava/java_swift.git", "2.1.0"..<"3.0.0"),
    ],
    targets: [
        .target(name: "swifthello", dependencies: ["java_swift"], path: "Sources"),
    ]
)
