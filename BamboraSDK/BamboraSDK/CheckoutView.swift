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

import UIKit
import WebKit

internal class BamboraCheckoutView: UIView {

    private enum Constants {
        static let webViewParameter = "?ui=inline#"
        static let identifier = "CheckoutSDKiOS/"
        static let version = "2.0.0"
    }

    private var webView: WKWebView!
    private var wrapperView: UIView!
    private var eventController: EventController!
    private let delegate = Bambora.checkout?.delegate

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWrapperView()
        setupWebView()
        setupListeners()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWrapperView()
        setupWebView()
        setupListeners()
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: BamboraConstants.deeplinkNotification,
            object: nil
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let wrapperHeight = self.bounds.height * 0.8
        let wrapperFrame = CGRect(
            x: 0,
            y: self.bounds.height - wrapperHeight,
            width: self.bounds.width,
            height: wrapperHeight
        )
        wrapperView.frame = wrapperFrame
        webView.frame = wrapperFrame.inset(by: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
    }

    private func setupListeners() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deeplinkReceived(_:)),
            name: BamboraConstants.deeplinkNotification,
            object: nil
        )
    }

    /**
     Opens the URL that was passed in the notifcation.
     - Parameter notification: The notification that was received.
     */
    @objc private func deeplinkReceived(_ notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let urlString = userInfo["url"] as? String {
            if let url = URL(string: urlString) {
                self.openWebViewWith(url: url)
            }
        }
    }

    private func setupWebView() {
        let eventController = EventController(delegate: delegate)
        let webConfiguration = WKWebViewConfiguration()

        let contentController = WKUserContentController()
        contentController.add(eventController, name: eventController.identifier)

        webConfiguration.userContentController = contentController
        webView = WKWebView(frame: self.bounds, configuration: webConfiguration)

        webView.isOpaque = false
        webView.backgroundColor = UIColor.white
        webView.scrollView.backgroundColor = UIColor.clear
        webView.navigationDelegate = self

        self.addSubview(webView)
    }

    private func setupWrapperView() {
        wrapperView = UIView()
        wrapperView.backgroundColor = UIColor.white

        self.addSubview(wrapperView)
    }

    func initialize(checkoutToken: String, baseUrl: String, returnUrl: String) {
        let url = getCheckoutUrl(checkoutToken: checkoutToken, baseUrl: baseUrl, returnUrl: returnUrl)
        if let checkoutUrl = URL(string: url) {
            let myRequest = URLRequest(url: checkoutUrl)
            webView.load(myRequest)
        }
    }

    func openWebViewWith(url: URL) {
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }

    private func getInstalledWalletProducts() -> [WalletProduct] {
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

    private func getCheckoutUrl(checkoutToken: String, baseUrl: String, returnUrl: String) -> String {
        let paymentOptions = getEncodedPaymentOptions(returnUrl: returnUrl)
        return "\(baseUrl)\("/")\(checkoutToken)\(Constants.webViewParameter)\(paymentOptions)"
    }

    /// - Returns: The `PaymentOptions` as an UTF-8 encoded JSON string.
    private func getEncodedPaymentOptions(returnUrl: String) -> String {
        let sdkVersion = Constants.version
        let versionString = Constants.identifier + sdkVersion
        let paymentOptions = PaymentOptions(
            version: versionString,
            paymentAppsInstalled: getInstalledWalletProducts(),
            appReturnUrl: returnUrl
        )
        let jsonString = jsonStringFrom(dictionary: paymentOptions.jsonRepresentation)
        guard let data = jsonString.data(using: String.Encoding.utf8) else { return Constants.version }
        let result = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return result
    }

    private func jsonStringFrom(dictionary: [String: Any]) -> String {
        guard let json = JSONStringEncoder().encode(dictionary) else { return "{}" }
        return json
    }
}

extension BamboraCheckoutView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let nsError = error as NSError
        var bamboraError: BamboraError
        if nsError.code == NSURLErrorNotConnectedToInternet {
            bamboraError = .internetError
        } else if nsError.code == NSURLErrorUserAuthenticationRequired {
            bamboraError = .loadSessionError
        } else if nsError.code == NSURLErrorBadURL || nsError.code == NSURLErrorTimedOut {
            bamboraError = .loadSessionError
        } else {
            bamboraError = .genericError
        }

        delegate?.onWebViewError(error: bamboraError)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        decisionHandler(.allow)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        if (url.scheme != "http") && (url.scheme != "https") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Error: no app was found that can open \(url.scheme)")
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
