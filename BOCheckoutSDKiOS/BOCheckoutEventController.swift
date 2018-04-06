//
// Copyright (c) 2018 Bambora ( https://bambora.com/ )
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
//

import WebKit

public class BOCheckoutEventController: NSObject, WKScriptMessageHandler {
    
    var registredEvents = Dictionary<String, BOCheckoutEventHandlerCollection>()
    let checkoutEventIdentifier = "CheckoutSDKiOS"
    
    public func on(eventType: String, eventHandler:@escaping (BOCheckoutEventData) -> Void) {
        var eventHandlerCollection: BOCheckoutEventHandlerCollection = BOCheckoutEventHandlerCollection()
        if registredEvents[eventType] != nil {
            eventHandlerCollection = registredEvents[eventType]!
        }
        
        eventHandlerCollection.addEventHandler(eventHandler: eventHandler)
        registredEvents[eventType] = eventHandlerCollection
    }
    
    public func off(eventType: String) {
        if registredEvents[eventType] != nil {
            registredEvents.removeValue(forKey: eventType)
        }
    }
    
    public func getCheckoutEventIdentifier() ->String{
        return checkoutEventIdentifier
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == checkoutEventIdentifier) {
            if let messageBody: NSDictionary = message.body as? NSDictionary {
                let eventData: BOCheckoutEventData! = BOCheckoutEventData()
                if let type: String = messageBody["eventType"] as? String {
                    eventData.eventType = type.lowercased()
                }
                if let payload: String = messageBody["payload"] as? String {
                    eventData.payload = payload
                }
                print(message.body)
                //For subscribing to a specefik event
                registredEvents[eventData.eventType]?.raise(eventData: eventData)
                //For subscribing to ANY event
                registredEvents["*"]?.raise(eventData: eventData)
            }
        }
    }
}
