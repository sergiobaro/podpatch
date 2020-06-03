// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "podpatch",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "podpatch", targets: ["podpatch"]),
        .library(name: "PodPatchLib", targets: ["PodPatchLib"])
    ],
    targets: [
        .target(
            name: "podpatch",
            dependencies: ["PodPatchLib"]
        ),
        .target(
            name: "PodPatchLib"
        ),
        .testTarget(
            name: "PodPatchLibTests",
            dependencies: ["PodPatchLib"]
        )
    ]
)
