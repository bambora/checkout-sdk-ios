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

/// Maps events to `Event` and `EventType`.
internal class CheckoutEventMapper {
    /**
     Maps `EventType` and String to `Event`.
     Decodes jsonPayload to `Event` body when available.
     - Parameters:
       - eventType: Instance of EventType enum
       - jsonPayload: payload for EventType
     - Returns: instance of `Event`.
         If eventType cannot be mapped to an `Event`, it will return an `ErrorEvent`.
     */
    internal static func mapEventObject(eventType: EventType, jsonPayload: String) -> Event {
        switch eventType {
        case .authorize:
            if let data = jsonPayload.data(using: .utf8),
               let decoded = try? JSONDecoder().decode(Authorize.self, from: data) {
                    return decoded
            }
        case .paymentTypeSelection:
            if let data = jsonPayload.data(using: .utf8),
               let decoded = try? JSONDecoder().decode(String.self, from: data) {
                    return PaymentTypeSelection(paymentType: decoded)
            }
        case .cardTypeResolve:
            if let data = jsonPayload.data(using: .utf8),
               let decoded = try? JSONDecoder().decode(CardTypeResolve.self, from: data) {
                    return decoded
            }
        default:
            return ErrorEvent(payload: .genericError)
        }
        return ErrorEvent(payload: .genericError)
    }

    /**
     Map String to `EventType`.
     - Parameter eventType: String that can be mapped to `EventType`.
     - Returns: instance of `EventType`.
         If eventType cannot be mapped to an `EventType`, it will return `EventType.error`.
     */
    internal static func mapEventType(eventType: String) -> EventType {
        switch eventType {
        case "paymenttypeselection":
            return .paymentTypeSelection
        case "cardtyperesolve":
            return .cardTypeResolve
        case "authorize":
            return .authorize
        default:
            return .error
        }
    }
}
