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

import BamboraSDK
import Foundation

internal class BamboraSDKHelper: ObservableObject, CheckoutDelegate {
    private var checkout: Checkout?
    @Published var paymentData: Authorize?
    @Published var errorEvent: ErrorEvent?

    // MARK: - Checkout delegate
    func onEventDispatched(event: Event) {
        self.processReceivedEvent(event)
    }

    /// Notifies the SDK that the app was opened via a deeplink
    func processDeeplink(url: URL) {
        Bambora.processDeeplink(url: url)
    }

    /**
     Initializes the Bambora Checkout with the use of the token, custom base URL and session id.
     Also assigns a delegate to the Checkout.
     */
    func initializeCheckout(token: String, useCustomUrl: Bool, customUrl: String) throws {
        if useCustomUrl {
            checkout = try Bambora.checkout(
                sessionToken: token,
                customUrl: customUrl
            )
        } else {
            checkout = try Bambora.checkout(sessionToken: token)
        }
        checkout?.delegate = self
        checkout?.subscribeOnAllEvents()
        checkout?.show()
    }

    /// Determines how to process the `Event` that is received from the SDK.
    private func processReceivedEvent(_ receivedEvent: Event) {
        switch receivedEvent {
        case let authorized as Authorize:
            paymentData = authorized
        case is CheckoutViewClose:
            Bambora.close()
            print("Close event was called")
        case _ as CardTypeResolve:
            print("CardTypeResolve event was called")
        case _ as PaymentTypeSelection:
            print("PaymentSelection event was called")
        case let error as ErrorEvent:
            errorEvent = error
        default:
            print("Unknown Event")
        }
    }
}
