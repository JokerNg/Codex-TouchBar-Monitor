// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "CodexTouchBarMonitor",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "CodexTouchBarMonitor", targets: ["CodexTouchBarMonitor"])
    ],
    targets: [
        .binaryTarget(
            name: "Sparkle",
            url: "https://github.com/sparkle-project/Sparkle/releases/download/2.9.6/Sparkle-for-Swift-Package-Manager.zip",
            checksum: "8d5fb41d960b43f4a68aa14126bf62b098544ec8d191cdcc73eb14e63a8e7606"
        ),
        .executableTarget(
            name: "CodexTouchBarMonitor",
            dependencies: ["Sparkle"],
            path: "Sources",
            linkerSettings: [
                .unsafeFlags(["-Xlinker", "-rpath", "-Xlinker", "@executable_path/../Frameworks"])
            ]
        )
    ]
)
