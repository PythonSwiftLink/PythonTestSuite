// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PythonTestSuite",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PythonTestSuite",
            targets: ["PythonTestSuite"]),
    ],
    dependencies: [
        .package(url: "https://github.com/PythonSwiftLink/PythonLib", from: "0.1.0"),
        //.package(url: "https://github.com/PythonSwiftLink/PythonSwiftCore", branch: "testing"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PythonTestSuite",
            dependencies: [
                //"PythonTestSuite",
                //"PythonSwiftCore",
                "PythonLib"
            ],
            resources: [
                .copy("python_stdlib")
            ]
        ),
        
        
    ]
)
