import PackageDescription

let package = Package(
	name: "libswifthello.so",
	targets: [
	],
    dependencies: [
        .Package(url: "https://github.com/SwiftJava/java_swift.git", versions: Version(1,0,0)..<Version(2,0,0)),
        .Package(url: "https://github.com/SwiftJava/java_lang.git", versions: Version(1,0,0)..<Version(2,0,0)),
        ]

)
