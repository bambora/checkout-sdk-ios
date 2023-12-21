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

final class CheckoutTest: XCTestCase {

    private var defaultCheckout: Checkout?

    private let sessionToken = UUID().uuidString

    private let eventsToSubscribe = [
        EventType.authorize,
        EventType.paymentTypeSelection,
        EventType.cardTypeResolve
    ]
    private let eventsToUnsubscribe = [
        EventType.paymentTypeSelection,
        EventType.cardTypeResolve
    ]

    override func setUp() {
        do {
            defaultCheckout = try Bambora.checkout(sessionToken: sessionToken)
        } catch {
            print("Error initializing CheckoutTest: \(error.localizedDescription)")
        }
    }

    override func tearDown() {
        guard defaultCheckout != nil else {
            XCTFail("defaultCheckout is null")
            return
        }

        Bambora.close()
    }

    func test_production_url() {
        guard let defaultCheckout else {
            XCTFail("defaultCheckout is null")
            return
        }

        let expectedEncodedPaymentOptions =
            """
            eyJhcHBSZXR1cm5VcmwiOiIiLCJwYXltZW50QXBwc0luc3RhbGxlZCI6W10sInZlcnNpb24iOiJDaGVja291dFNES2lPUy8yLjAuMiJ9
            """
        let expectedCheckoutUrl =
            "\(BamboraConstants.productionURL)/\(sessionToken)?ui=inline#\(expectedEncodedPaymentOptions)"

        XCTAssertEqual(defaultCheckout.checkoutUrl.absoluteString, expectedCheckoutUrl)
    }

    func test_close_SDK() {
        guard defaultCheckout != nil else {
            XCTFail("defaultCheckout is null")
            return
        }

        Bambora.close()

        XCTAssertEqual(nil, Bambora.checkout)
    }

    func test_subscribe_to_all_events() {
        guard let defaultCheckout else {
            XCTFail("defaultCheckout is null")
            return
        }
        defaultCheckout.subscribeOnAllEvents()

        XCTAssertEqual(4, defaultCheckout.subscribedEvents.count)
        XCTAssertTrue(
            defaultCheckout.subscribedEvents.contains(
                [.authorize, .paymentTypeSelection, .cardTypeResolve, .error]
            )
        )
    }

    func test_subscribe_to_single_event() {
        guard let defaultCheckout else {
            XCTFail("defaultCheckout is null")
            return
        }
        defaultCheckout.on(event: .authorize)

        XCTAssertEqual(1, defaultCheckout.subscribedEvents.count)
        XCTAssertTrue(defaultCheckout.subscribedEvents.contains(.authorize))
    }

    func test_subscribe_to_multiple_events() {
        guard let defaultCheckout else {
            XCTFail("defaultCheckout is null")
            return
        }
        defaultCheckout.on(events: eventsToSubscribe)

        XCTAssertEqual(3, defaultCheckout.subscribedEvents.count)
        XCTAssertTrue(defaultCheckout.subscribedEvents.contains([.authorize, .paymentTypeSelection, .cardTypeResolve]))
    }

    func test_unsubscribe_from_single_event() {
        guard let defaultCheckout else {
            XCTFail("defaultCheckout is null")
            return
        }
        defaultCheckout.on(events: eventsToSubscribe)

        XCTAssertEqual(3, defaultCheckout.subscribedEvents.count)

        defaultCheckout.off(event: .paymentTypeSelection)

        XCTAssertEqual(2, defaultCheckout.subscribedEvents.count)
        XCTAssertTrue(defaultCheckout.subscribedEvents.contains([.authorize, .cardTypeResolve]))
    }

    func test_unsubscribe_from_multiple_events() {
        guard let defaultCheckout else {
            XCTFail("defaultCheckout is null")
            return
        }
        defaultCheckout.on(events: eventsToSubscribe)

        XCTAssertEqual(3, defaultCheckout.subscribedEvents.count)

        defaultCheckout.off(events: eventsToUnsubscribe)

        XCTAssertEqual(1, defaultCheckout.subscribedEvents.count)
        XCTAssertTrue(defaultCheckout.subscribedEvents.contains(.authorize))
    }

    func test_subscribe_to_same_event_twice() {
        guard let defaultCheckout else {
            XCTFail("defaultCheckout is null")
            return
        }
        defaultCheckout.on(events: [.authorize, .cardTypeResolve, .authorize])

        XCTAssertEqual(2, defaultCheckout.subscribedEvents.count)
        XCTAssertTrue(defaultCheckout.subscribedEvents.contains([.authorize, .cardTypeResolve]))
    }

    func test_subscribe_to_all_with_already_subscribed_event() {
        guard let defaultCheckout else {
            XCTFail("defaultCheckout is null")
            return
        }
        defaultCheckout.on(event: .authorize)

        XCTAssertEqual(1, defaultCheckout.subscribedEvents.count)
        XCTAssertTrue(defaultCheckout.subscribedEvents.contains([.authorize]))

        defaultCheckout.subscribeOnAllEvents()

        XCTAssertEqual(4, defaultCheckout.subscribedEvents.count)
        XCTAssertTrue(
            defaultCheckout.subscribedEvents.contains(
                [.authorize, .paymentTypeSelection, .cardTypeResolve, .error]
            )
        )
    }
}
