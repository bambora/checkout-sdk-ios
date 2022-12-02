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

/// Entrypoint of the Bambora Checkout SDK.
public struct Bambora {
    /**
     The Checkout instance.
     Use this instance to interact with the Checkout.
     Initialize using `checkout(sessionToken:customUrl:)`.
     */
    private(set) static var checkout: Checkout?

    /**
     Checks if the `Checkout` is currently initialized.
     - Returns: Bool.
        True, if the `Checkout` is initialized.
        False, if the `Checkout` is not initialized.
     */
    public static var isInitialized: Bool {
        return checkout != nil
    }

    /**
     Initialize checkout SDK.
     - Parameters:
        - sessionToken: The token that you receive when creating a session.
        - customUrl: Optional.
                     A custom base URL to connect to the Bambora backend.
                     If not provided, the SDK will use the default url.
     - Returns: An instance of Checkout, use this instance to interact with the Checkout.
     - Throws:
        - `BamboraError.sdkAlreadyInitializedError` when the SDK is already initialized.
     */
    public static func checkout(
        sessionToken: String,
        customUrl: String = BamboraConstants.productionURL
    ) throws -> Checkout {
        if checkout != nil {
            throw BamboraError.sdkAlreadyInitializedError
        }
        checkout = Checkout(sessionToken: sessionToken, baseUrl: customUrl)

        guard let checkout else {
            throw BamboraError.genericError
        }

        return checkout
    }

    /// Closes the Bambora Checkout and makes the `Checkout` instance nil.
    public static func close() {
        checkout?.closeViewController()
        checkout = nil
    }

    /**
     If `Checkout` is already initialized, the SDK will open the provided epayReturnUrl in the existing WebView.
     If `Checkout` is not initialized, the SDK will open the provided epayReturnUrl in a new WebView.
     - Parameter url: The URL that reopens your app. This URL should contain the epayReturnUrl as a query parameter.
     */
    public static func processDeeplink(url: URL) {
        if isInitialized {
            checkout?.processDeeplink(url: url)
        } else {
            do {
                if let epayReturnUrlString = try DeepLinkHandler.processDeeplink(url: url),
                   let epayReturnUrl = URL(string: epayReturnUrlString) {
                    let bamboraViewController = BamboraCheckoutViewController(
                        token: nil,
                        baseUrl: nil,
                        returnUrl: nil,
                        delegate: checkout?.delegate,
                        overrideWithURL: epayReturnUrl
                    )
                    bamboraViewController.show()
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
