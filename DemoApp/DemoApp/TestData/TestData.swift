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
import BamboraSDK

internal struct TestData {
    static let paymentData = Authorize(
        amount: "100",
        cardNumber: "123456XXXXXX1234",
        currency: "DKK",
        date: "20221027",
        eci: "1",
        expireMonth: "2",
        expireYear: "22",
        feeId: "12345",
        hash: "a1b23c4d56789e0fg1h234567890ijk1",
        issuerCountry: "DNK",
        orderId: "1234",
        paymentType: "1",
        reference: "987654321098",
        subscriptionId: "123546",
        time: "1123",
        tokenId: "a1b2c3d4e5f6",
        txnFee: "12",
        txnId: "123456789012345678",
        ui: "inline",
        walletName: "MobilePay",
        additionalFields: ["method": "card"]
    )
}
