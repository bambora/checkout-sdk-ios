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
     Use this instance to interact with the Checkout. For example to subscribe to events.
     Initialize using `checkout(sessionToken:customUrl:)` or, after a return from another app, `checkoutAfterReturn(url:)`
     */
    private(set) static var checkout: Checkout?

    /**
     Checks if the SDK is currently initialized.
     - Returns: true if there is an active instance of `Checkout`, false otherwise.*/
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
        if isInitialized {
            throw BamboraError.sdkAlreadyInitializedError
        }
        checkout = try Checkout(sessionToken: sessionToken, baseUrl: customUrl)

        guard let checkout else {
            throw BamboraError.genericError
        }

        return checkout
    }

    /**
     Re-initialize the SDK after the user has been returned to your app after a wallet payment or challenge. The SDK will validate the provided url.
     Call `show()` again to show the final payment result.
     - Parameter url: The URL that you received when the user returned to your app.
     - Returns: An instance of Checkout, use this instance to interact with the Checkout.
     */
    public static func checkoutAfterReturn(with url: URL) throws -> Checkout {
        guard let epayReturnUrl = DeepLinkValidator.processDeeplink(url: url) else {
            throw BamboraError.genericError
        }

        if isInitialized {
            try checkout?.setEpayReturnUrl(epayReturnUrl)
        } else {
            checkout = try Checkout(epayReturnUrl: epayReturnUrl)
        }

        guard let checkout else {
            throw BamboraError.genericError
        }

        return checkout
    }

    /**
     Closes the Bambora Checkout and makes the `Checkout` instance nil.
     */
    public static func close() {
        checkout?.closeViewController()
        checkout = nil
    }
}
