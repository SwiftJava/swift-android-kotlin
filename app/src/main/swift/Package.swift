import PackageDescription

let package = Package(
    name: "libswifthello.so",
    targets: [
    ],
    dependencies: [
        .Package(url: "https://github.com/SwiftJava/java_swift.git", versions: Version(2,1,1)..<Version(3,0,0)),
        .Package(url: "https://github.com/SwiftJava/swift-android-sqlite.git", majorVersion: 1),
        .Package(url: "https://github.com/SwiftJava/swift-android-injection.git", majorVersion: 1),
        .Package(url: "https://github.com/SwiftJava/Alamofire.git", majorVersion: 4),
        .Package(url: "https://github.com/johnno1962/Fortify.git", majorVersion: 1),
    ]
)
