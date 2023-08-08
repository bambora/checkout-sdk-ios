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

/// Bambora Checkout Events.
public final class EventData {
    public var eventType: String = ""
    public var payload: String = ""
}

public protocol Event {}

public struct CheckoutViewClose: Event { }

public struct ErrorEvent: Event {
    public let payload: BamboraError

    public init(payload: BamboraError) {
        self.payload = payload
    }
}

public struct Authorize: Codable, Event {
    public let amount: String
    public let cardNumber: String?
    public let currency: String
    public let date: String
    public let eci: String?
    public let expireMonth: String?
    public let expireYear: String?
    public let feeId: String
    public let hash: String
    public let issuerCountry: String?
    public let orderId: String
    public let paymentType: String
    public let reference: String
    public let subscriptionId: String?
    public let time: String
    public let tokenId: String?
    public let txnFee: String
    public let txnId: String
    public let ui: String
    public let walletName: String?
    public let additionalFields: [String: String]?

    public init(amount: String,
                cardNumber: String,
                currency: String,
                date: String,
                eci: String,
                expireMonth: String,
                expireYear: String,
                feeId: String,
                hash: String,
                issuerCountry: String,
                orderId: String,
                paymentType: String,
                reference: String,
                subscriptionId: String,
                time: String,
                tokenId: String,
                txnFee: String,
                txnId: String,
                ui: String,
                walletName: String,
                additionalFields: [String: String]
    ) {
        self.amount = amount
        self.cardNumber = cardNumber
        self.currency = currency
        self.date = date
        self.eci = eci
        self.expireMonth = expireMonth
        self.expireYear = expireYear
        self.feeId = feeId
        self.hash = hash
        self.issuerCountry = issuerCountry
        self.orderId = orderId
        self.paymentType = paymentType
        self.reference = reference
        self.subscriptionId = subscriptionId
        self.time = time
        self.tokenId = tokenId
        self.txnFee = txnFee
        self.txnId = txnId
        self.ui = ui
        self.walletName = walletName
        self.additionalFields = additionalFields
    }

        enum OuterKeys: String, CodingKey {
            case acceptUrl, data
        }

        enum CodingKeys: String, CodingKey, CaseIterable {
            case cardNumber = "cardno"
            case expireMonth = "expmonth"
            case expireYear = "expyear"
            case feeId = "feeid"
            case issuerCountry = "issuercountry"
            case orderId = "orderid"
            case paymentType = "paymenttype"
            case subscriptionId = "subscriptionid"
            case tokenId = "tokenid"
            case txnFee = "txnfee"
            case txnId = "txnid"
            case walletName = "walletname"
            case amount, currency, date, eci, hash, reference, time, ui
        }

    public init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        let authorizeKeyValueArray = try outerContainer.decode([String: String].self, forKey: .data)

        let knownFields: [String] = CodingKeys.allCases.map { $0.rawValue }

        let additionalFields = authorizeKeyValueArray.filter({ !knownFields.contains($0.key) })

        guard let amount = authorizeKeyValueArray[CodingKeys.amount.rawValue],
              let currency = authorizeKeyValueArray[CodingKeys.currency.rawValue],
              let date = authorizeKeyValueArray[CodingKeys.date.rawValue],
              let feeId = authorizeKeyValueArray[CodingKeys.feeId.rawValue],
              let hash = authorizeKeyValueArray[CodingKeys.hash.rawValue],
              let orderId = authorizeKeyValueArray[CodingKeys.orderId.rawValue],
              let paymentType = authorizeKeyValueArray[CodingKeys.paymentType.rawValue],
              let reference = authorizeKeyValueArray[CodingKeys.reference.rawValue],
              let time = authorizeKeyValueArray[CodingKeys.time.rawValue],
              let txnFee = authorizeKeyValueArray[CodingKeys.txnFee.rawValue],
              let txnId = authorizeKeyValueArray[CodingKeys.txnId.rawValue],
              let ui = authorizeKeyValueArray[CodingKeys.ui.rawValue] else {
            throw BamboraError.genericError
        }

        self.amount = amount
        self.cardNumber = authorizeKeyValueArray[CodingKeys.cardNumber.rawValue]
        self.currency = currency
        self.date = date
        self.eci = authorizeKeyValueArray[CodingKeys.eci.rawValue]
        self.expireMonth = authorizeKeyValueArray[CodingKeys.expireMonth.rawValue]
        self.expireYear = authorizeKeyValueArray[CodingKeys.expireYear.rawValue]
        self.feeId = feeId
        self.hash = hash
        self.issuerCountry = authorizeKeyValueArray[CodingKeys.issuerCountry.rawValue]
        self.orderId = orderId
        self.paymentType = paymentType
        self.reference = reference
        self.subscriptionId = authorizeKeyValueArray[CodingKeys.subscriptionId.rawValue]
        self.time = time
        self.tokenId = authorizeKeyValueArray[CodingKeys.tokenId.rawValue]
        self.txnFee = txnFee
        self.txnId = txnId
        self.ui = ui
        self.walletName = authorizeKeyValueArray[CodingKeys.walletName.rawValue]
        self.additionalFields = additionalFields.isEmptyCheck
    }
}

public struct CardTypeResolve: Codable, Event {
    public let displayName: String
    public let fee: Fee
    public let groupId: Int
    public let id: Int
    public let name: String
    public let priority: Int
    public let type: String

    enum CodingKeys: String, CodingKey {
        case displayName = "displayname"
        case groupId = "groupid"
        case fee, id, name, priority, type
    }
}

public struct PaymentTypeSelection: Codable, Event {
    public let paymentType: String
}

public struct Fee: Codable {
    public let addFee: String
    public let amount: Int
    public let id: String

    enum CodingKeys: String, CodingKey {
        case addFee = "addfee"
        case amount, id
    }
}
