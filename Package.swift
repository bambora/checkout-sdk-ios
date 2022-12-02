// swift-tools-version:5.3
//
// Copyright (c) 2022 Bambora ( https://bambora.com/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import PackageDescription

let package = Package(
    name: "BamboraSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "BamboraSDK",
            targets: ["BamboraSDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/airsidemobile/JOSESwift", from: "2.2.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift", from: "1.5.0"),
        .package(url: "https://github.com/securing/IOSSecuritySuite", from: "1.9.1"),
        .package(url: "https://github.com/filom/ASN1Decoder", from: "1.8.0")
    ],
    targets: [
        .target(
            name: "BamboraSDK",
            dependencies: ["JOSESwift", "CryptoSwift", "IOSSecuritySuite", "ASN1Decoder"],
            path: "BamboraSDK/BamboraSDK"
        )
    ]
)