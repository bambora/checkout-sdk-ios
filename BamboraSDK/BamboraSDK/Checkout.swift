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

    private let sessionToken: String
    internal let baseUrl: String
    internal var subscribedEvents = [EventType]()
    private var bamboraViewController: BamboraCheckoutViewController?
    /// Delegate which should be provided to receive the events that are generated during the payment.
    public var delegate: CheckoutDelegate?

    /**
     The value of return URL is based on the app scheme defined in the host app.
     If the app scheme cannot be retrieved, the return URL is an empty String.
     */
    private var returnUrl: String {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [AnyObject],
              let urlTypeDictionary = urlTypes.first as? [String: AnyObject],
              let urlSchemes = urlTypeDictionary["CFBundleURLSchemes"] as? [AnyObject],
              let returnURLScheme = urlSchemes.first as? String else { return "" }

        return "\(returnURLScheme)://bamborasdk/return"
    }

    internal init(sessionToken: String, baseUrl: String) {
        self.sessionToken = sessionToken
        self.baseUrl = baseUrl
    }

    /**
     Notifies the `BamboraCheckoutView` that the host app was opened via a deeplink.
     */
    internal func processDeeplink(url: URL) {
        do {
            if let urlString = try DeepLinkHandler.processDeeplink(url: url) {
                let userInfo: [String: String] = ["url": urlString]
                NotificationCenter.default.post(
                    name: BamboraConstants.deeplinkNotification,
                    object: nil,
                    userInfo: userInfo)
            }
        } catch {
            delegate?.onEventDispatched(event: ErrorEvent(payload: .genericError))
        }
    }

    /**
     If there an internet connection, the Bambora Checkout is shown on top of your app.
     If there is no internet connection, it dispatches an `ErrorEvent`.
     */
    public func show() {
        if Reachability.isConnectedToNetwork() {
            bamboraViewController = BamboraCheckoutViewController(
                token: sessionToken,
                baseUrl: baseUrl,
                returnUrl: returnUrl,
                delegate: delegate
            )
            bamboraViewController?.show()
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
        for eventType in EventType.allCases {
            if !subscribedEvents.contains(eventType) {
                self.subscribedEvents.append(eventType)
            }
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
}
