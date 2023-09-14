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

final class ConstructCheckoutUrlTest: XCTestCase {
    private let baseUrl = "https://base.url.com"
    private let sessionToken = UUID().uuidString
    private let returnUrl = "bamborademoapp://bamborasdk/return"

    func test_construct_checkout_url_no_apps_installed() {
        let checkoutUrl = Checkout.constructCheckoutUrl(baseUrl, sessionToken, returnUrl, [])

        let expectedEncodedPaymentOptions = """
        eyJhcHBSZXR1cm5VcmwiOiJiYW1ib3JhZGVtb2FwcDovL2JhbWJvcmFzZGsvcmV0dXJuIiwicGF5bWVudEFwcHNJbnN0YW\
        xsZWQiOltdLCJ2ZXJzaW9uIjoiQ2hlY2tvdXRTREtpT1MvMi4wLjEifQ==
        """
        let expectedCheckoutUrl = "\(baseUrl)/\(sessionToken)?ui=inline#\(expectedEncodedPaymentOptions)"

        XCTAssertEqual(checkoutUrl, expectedCheckoutUrl)
    }

    func test_construct_checkout_url_mobilepay_installed() {
        let checkoutUrl = Checkout.constructCheckoutUrl(baseUrl, sessionToken, returnUrl, [.mobilePay])

        let expectedEncodedPaymentOptions = """
        eyJhcHBSZXR1cm5VcmwiOiJiYW1ib3JhZGVtb2FwcDovL2JhbWJvcmFzZGsvcmV0dXJuIiwicGF5bWVudEFwcHNJbnN0YW\
        xsZWQiOlsibW9iaWxlcGF5Il0sInZlcnNpb24iOiJDaGVja291dFNES2lPUy8yLjAuMSJ9
        """
        let expectedCheckoutUrl = "\(baseUrl)/\(sessionToken)?ui=inline#\(expectedEncodedPaymentOptions)"

        XCTAssertEqual(checkoutUrl, expectedCheckoutUrl)
    }

    func test_construct_checkout_url_vipps_installed() {
        let checkoutUrl = Checkout.constructCheckoutUrl(baseUrl, sessionToken, returnUrl, [.vipps])

        let expectedEncodedPaymentOptions = """
        eyJhcHBSZXR1cm5VcmwiOiJiYW1ib3JhZGVtb2FwcDovL2JhbWJvcmFzZGsvcmV0dXJuIiwicGF5bWVudEFwcHNJbnN0YW\
        xsZWQiOlsidmlwcHMiXSwidmVyc2lvbiI6IkNoZWNrb3V0U0RLaU9TLzIuMC4xIn0=
        """
        let expectedCheckoutUrl = "\(baseUrl)/\(sessionToken)?ui=inline#\(expectedEncodedPaymentOptions)"

        XCTAssertEqual(checkoutUrl, expectedCheckoutUrl)
    }

    func test_construct_checkout_url_swish_installed() {
        let checkoutUrl = Checkout.constructCheckoutUrl(baseUrl, sessionToken, returnUrl, [.swish])

        let expectedEncodedPaymentOptions = """
        eyJhcHBSZXR1cm5VcmwiOiJiYW1ib3JhZGVtb2FwcDovL2JhbWJvcmFzZGsvcmV0dXJuIiwicGF5bWVudEFwcHNJbnN0YW\
        xsZWQiOlsic3dpc2giXSwidmVyc2lvbiI6IkNoZWNrb3V0U0RLaU9TLzIuMC4xIn0=
        """
        let expectedCheckoutUrl = "\(baseUrl)/\(sessionToken)?ui=inline#\(expectedEncodedPaymentOptions)"

        XCTAssertEqual(checkoutUrl, expectedCheckoutUrl)
    }

    func test_construct_checkout_url_all_apps_installed() {
        let checkoutUrl = Checkout.constructCheckoutUrl(baseUrl, sessionToken, returnUrl, [.mobilePay, .vipps, .swish])

        let expectedEncodedPaymentOptions = """
        eyJhcHBSZXR1cm5VcmwiOiJiYW1ib3JhZGVtb2FwcDovL2JhbWJvcmFzZGsvcmV0dXJuIiwicGF5bWVudEFwcHNJbnN0YW\
        xsZWQiOlsibW9iaWxlcGF5IiwidmlwcHMiLCJzd2lzaCJdLCJ2ZXJzaW9uIjoiQ2hlY2tvdXRTREtpT1MvMi4wLjEifQ==
        """
        let expectedCheckoutUrl = "\(baseUrl)/\(sessionToken)?ui=inline#\(expectedEncodedPaymentOptions)"

        XCTAssertEqual(checkoutUrl, expectedCheckoutUrl)
    }
}
