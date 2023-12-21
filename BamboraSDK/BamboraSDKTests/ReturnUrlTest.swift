////
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

@testable import BamboraSDK
import XCTest

final class ReturnUrlTest: XCTestCase {

    func test_get_returnurl_success() {
        let deeplinkString = """
            bamborademoapp://bamborasdk/return/return?epayreturn=https://wallet-v1.api-eu.bambora.com/allowed/domain
        """.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let deeplinkUrl = URL(string: deeplinkString) else {
            XCTFail("Could not create URL from String")
            return
        }

        let returnUrl = DeepLinkValidator.processDeeplink(url: deeplinkUrl)

        XCTAssertNotNil(returnUrl)
        XCTAssertEqual(returnUrl?.absoluteString, "https://wallet-v1.api-eu.bambora.com/allowed/domain")
    }
    
    func test_get_returnurl_fail() {
        let deeplinkStringWrongValue = "bamborademoapp://bamborasdk/return/return?epayreturn?wrongvalue"
        let deeplinkStringWrongDomain = "bamborademoapp://bamborasdk/return/return?epayreturn=https://example.com"
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let deeplinkUrlWrongValue = URL(string: deeplinkStringWrongValue),
              let deeplinkUrlWrongDomain = URL(string: deeplinkStringWrongDomain) else {
            XCTFail("Could not create URL from String")
            return
        }

        let returnUrlWrongValue = DeepLinkValidator.processDeeplink(url: deeplinkUrlWrongValue)
        let returnUrlWrongDomain = DeepLinkValidator.processDeeplink(url: deeplinkUrlWrongDomain)

        XCTAssertNil(returnUrlWrongValue)
        XCTAssertNil(returnUrlWrongDomain)
    }
}
