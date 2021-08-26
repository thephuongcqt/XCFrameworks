// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCFrameworks",
    platforms: [.iOS(.v11)],
    products: [
       .library(name: "XCFrameworks", targets: ["XCFrameworks"])
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .branch("development")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", .upToNextMajor(from: "5.0.0")),        
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0"))
    ],
    targets: [
        .target(
            name: "XCFrameworks",
            dependencies: [
                "RxDataSources",  
                .product(name: "RxMoya", package: "Moya"),
                .product(name: "RxBlocking", package: "RxSwift"),
                .product(name: "RxTest", package: "RxSwift")
            ]
        ),
    ]
)
