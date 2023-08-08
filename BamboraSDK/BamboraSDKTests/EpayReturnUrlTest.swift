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

final class EpayReturnUrlTest: XCTestCase {

    func test_get_epayreturnurl_success() {
        let deeplinkString = """
            bamborademoapp://bamborasdk/return/return?epayreturn=https://wallet-v1.api.epay.eu/allowed/domain
        """.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let deeplinkUrl = URL(string: deeplinkString) else {
            XCTFail("Could not create URL from String")
            return
        }

        let epayReturnUrl = DeepLinkValidator.processDeeplink(url: deeplinkUrl)

        XCTAssertNotNil(epayReturnUrl)
        XCTAssertEqual(epayReturnUrl?.absoluteString, "https://wallet-v1.api.epay.eu/allowed/domain")
    }

    func test_get_epayreturnurl_fail() {
        let deeplinkStringWrongValue = "bamborademoapp://bamborasdk/return/return?epayreturn?wrongvalue"
        let deeplinkStringWrongDomain = """
            bamborademoapp://bamborasdk/return/return?epayreturn=https://not-allowed-domain.eu
        """.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let deeplinkUrlWrongValue = URL(string: deeplinkStringWrongValue),
              let deeplinkUrlWrongDomain = URL(string: deeplinkStringWrongDomain) else {
            XCTFail("Could not create URL from String")
            return
        }

        let epayReturnUrlWrongValue = DeepLinkValidator.processDeeplink(url: deeplinkUrlWrongValue)
        let epayReturnUrlWrongDomain = DeepLinkValidator.processDeeplink(url: deeplinkUrlWrongDomain)

        XCTAssertNil(epayReturnUrlWrongValue)
        XCTAssertNil(epayReturnUrlWrongDomain)
    }
}
