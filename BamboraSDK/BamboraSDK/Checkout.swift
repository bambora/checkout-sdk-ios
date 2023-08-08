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
import WebKit

/// The layer between your app and the SDK.
public final class Checkout: NSObject {

    internal var checkoutUrl: URL

    /// The delegate that will receive events that are generated during the payment.
    public var delegate: CheckoutDelegate?
    internal var subscribedEvents = [EventType]()

    private var bamboraViewController: BamboraCheckoutViewController?

    /**
     The value of return URL is based on the app scheme defined in the host app.
     If the app scheme cannot be retrieved, the return URL is an empty String.
     */
    private static var returnUrl: String {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [AnyObject],
              let urlTypeDictionary = urlTypes.first as? [String: AnyObject],
              let urlSchemes = urlTypeDictionary["CFBundleURLSchemes"] as? [AnyObject],
              let returnURLScheme = urlSchemes.first as? String else { return "" }

        return "\(returnURLScheme)://bamborasdk/return"
    }

    private static var installedWalletProducts: [WalletProduct] {
        var apps: [WalletProduct] = []
        let app = UIApplication.shared
        for product in WalletProduct.allCases {
            if let url = URL(string: product.deepLink) {
                if app.canOpenURL(url) {
                    apps.append(product)
                }
            }
        }
        return apps
    }

    internal init(sessionToken: String, baseUrl: String) throws {
        if let url = URL(
            string: Self.constructCheckoutUrl(baseUrl, sessionToken, Self.returnUrl, Self.installedWalletProducts)
        ) {
            self.checkoutUrl = url
        } else {
            throw BamboraError.urlParseError
        }
    }

    internal init(epayReturnUrl: URL) throws {
        self.checkoutUrl = epayReturnUrl
    }

    internal func setEpayReturnUrl(_ epayReturnUrl: URL) throws {
        self.checkoutUrl = epayReturnUrl
    }

    /**
     Will show the Checkout on top of your app.
     If the device has no working internet connection, an error is returned.
     */
    public func show() {
        if Reachability.isConnectedToNetwork() {
            if bamboraViewController != nil {
                let userInfo: [String: String] = ["url": checkoutUrl.absoluteString]
                NotificationCenter.default.post(
                    name: BamboraConstants.deeplinkNotification,
                    object: nil,
                    userInfo: userInfo)
            } else {
                bamboraViewController = BamboraCheckoutViewController(
                    url: checkoutUrl,
                    delegate: delegate
                )
                bamboraViewController?.show()
            }
        } else {
            delegate?.onEventDispatched(event: ErrorEvent(payload: .internetError))
        }
    }

    /// Closes the `BamboraCheckoutViewController`.
    internal func closeViewController() {
        bamboraViewController?.dismiss()
    }

    /// Subscribe on all SDK events.
    public func subscribeOnAllEvents() {
        for eventType in EventType.allCases where !subscribedEvents.contains(eventType) {
            self.subscribedEvents.append(eventType)
        }
    }

    /**
     Subscribe on a single SDK event.
     - Parameter event: single `EventType`.
     */
    public func on(event: EventType) {
        if !subscribedEvents.contains(event) {
            self.subscribedEvents.append(event)
        }
    }

    /**
     Subscribe on multiple SDK events.
    - Parameter events: array of `EventType`.
     */
    public func on(events: [EventType]) {
        events.forEach {
            if !subscribedEvents.contains($0) {
                subscribedEvents.append($0)
            }
        }
    }

    /**
     Unsubscribe on a single SDK event.
     - Parameter event: single `EventType`.
     */
    public func off(event: EventType) {
        if subscribedEvents.contains(event) {
            subscribedEvents.removeAll {
                $0 == event
            }
        }
    }

    /**
     Unsubscribe on multiple SDK events.
     - Parameter events: array of `EventType`.
     */
    public func off(events: [EventType]) {
        events.forEach { event in
            if subscribedEvents.contains(event) {
                subscribedEvents.removeAll {
                    $0 == event
                }
            }
        }
    }

    // MARK: Generate Checkout URL
    private enum Constants {
        static let webViewParameter = "?ui=inline#"
        static let identifier = "CheckoutSDKiOS/"
        static let version = "2.0.1"
    }

    internal static func constructCheckoutUrl(
        _ baseUrl: String,
        _ sessionToken: String,
        _ returnUrl: String,
        _ installedWalletProducts: [WalletProduct]
    ) -> String {
        let paymentOptions = getEncodedPaymentOptions(
            returnUrl: returnUrl,
            installedWalletProducts: installedWalletProducts
        )
        return "\(baseUrl)\("/")\(sessionToken)\(Constants.webViewParameter)\(paymentOptions)"
    }

    /// - Returns: The `PaymentOptions` as an UTF-8 encoded JSON string.
    private static func getEncodedPaymentOptions(
        returnUrl: String,
        installedWalletProducts: [WalletProduct]
    ) -> String {
        let sdkVersion = Constants.version
        let versionString = Constants.identifier + sdkVersion
        let paymentOptions = PaymentOptions(
            version: versionString,
            paymentAppsInstalled: installedWalletProducts,
            appReturnUrl: returnUrl
        )
        let jsonString = jsonStringFrom(dictionary: paymentOptions.jsonRepresentation)
        guard let data = jsonString.data(using: String.Encoding.utf8) else { return Constants.version }
        let result = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return result
    }

    private static func jsonStringFrom(dictionary: [String: Any]) -> String {
        guard let json = JSONStringEncoder().encode(dictionary) else { return "{}" }
        return json
    }
}
