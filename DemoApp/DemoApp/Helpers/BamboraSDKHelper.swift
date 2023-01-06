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

/**
 Wrapper class that demonstrates how to interact with the Bambora Checkout SDK.
 */
internal class BamboraSDKHelper: ObservableObject, CheckoutDelegate {
    private var checkout: Checkout?
    @Published var paymentData: Authorize?
    @Published var errorEvent: ErrorEvent?

    // MARK: - Checkout delegate
    func onEventDispatched(event: Event) {
        self.processReceivedEvent(event)
    }

    /**
     Initializes the Bambora Checkout using the provided Token.
     */
    func openCheckout(using token: String) {
        do {
            checkout = try Bambora.checkout(sessionToken: token)
            setupCheckoutDelegate()
            checkout?.show()
        } catch {
            print(#function, error)
        }
    }

    /**
     Initializes the Bambora Checkout using the provided Token, and connects to the provided custom endpoint.
     */
    func openCheckout(using token: String, and customUrl: String) {
        do {
            checkout = try Bambora.checkout(sessionToken: token, customUrl: customUrl)
            setupCheckoutDelegate()
            checkout?.show()
        } catch {
            print(#function, error)
        }
    }

    /**
     Allows the SDK to handle the received deeplink return, coming from a wallet payment or 3DS challenge.
     Note that if the app was killed while the user was completing the wallet payment, the SDK will no longer be
     initialized, and the event delegate has to be re-configured. This is why `checkout` is re-assigned, and
     `setupCheckoutDelegate()` is called again.
     */
    func processDeeplink(url: URL) {
        do {
            checkout = try Bambora.checkoutAfterReturn(with: url)
            setupCheckoutDelegate()
            checkout?.show()
        } catch {
            print(#function, error)
        }
    }

    /**
     Assigns a delegate to the Checkout and subscribes to all events.
     */
    private func setupCheckoutDelegate() {
        checkout?.delegate = self
        checkout?.subscribeOnAllEvents()
    }

    /**
     Processes the `Event` that is received from the SDK.
     */
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
