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

/**
 Responsible for receiving and handling the dispatched events from the WebView and passes it on to the delegate.
 */
internal class EventController: NSObject, WKScriptMessageHandler {

    let identifier = "CheckoutSDKiOS"
    private let delegate: CheckoutDelegate?

    init(delegate: CheckoutDelegate?) {
        self.delegate = delegate
        super.init()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == identifier {
            if let messageBody: NSDictionary = message.body as? NSDictionary {
                let eventData = EventData()
                if let type: String = messageBody["eventType"] as? String {
                    eventData.eventType = type.lowercased()
                }
                if let payload: String = messageBody["payload"] as? String {
                    eventData.payload = payload
                }

                delegate?.onJavascriptEventDispatched(eventType: eventData.eventType, jsonPayload: eventData.payload)
            }
        }
    }
}
