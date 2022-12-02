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

final class AuthorizeDecoderTest: XCTestCase {

    func test_decode_authorize_without_additional_fields_success() {
        let jsonResponse = """
        {
         "acceptUrl":"https://example.org/accept",
         "data": {
            "ui":"inline",
            "txnid":"123456789012345678",
            "orderid":"1234",
            "reference":"987654321098",
            "amount":"100",
            "currency":"DKK",
            "date":"20221123",
            "time":"0934",
            "subscriptionid":"123456",
            "feeid":"54321",
            "txnfee":"0",
            "expmonth":"2",
            "expyear":"25",
            "paymenttype":"2",
            "cardno":"123456XXXXXX1234",
            "eci":"1",
            "issuercountry":"DNK",
            "tokenid":"a1b2c3d4e5f6",
            "hash":"a1b23c4d56789e0fg1h234567890ijk1",
            "walletname":"MobilePay"
          }
        }
        """

        let event = CheckoutEventMapper.mapEventObject(eventType: .authorize, jsonPayload: jsonResponse)

        guard let authorizeEvent = event as? Authorize else {
            XCTFail("Could not cast event as Authorize")
            return
        }

        XCTAssertEqual(authorizeEvent.amount, "100")
        XCTAssertEqual(authorizeEvent.cardNumber, "123456XXXXXX1234")
        XCTAssertEqual(authorizeEvent.currency, "DKK")
        XCTAssertEqual(authorizeEvent.date, "20221123")
        XCTAssertEqual(authorizeEvent.eci, "1")
        XCTAssertEqual(authorizeEvent.expireMonth, "2")
        XCTAssertEqual(authorizeEvent.expireYear, "25")
        XCTAssertEqual(authorizeEvent.feeId, "54321")
        XCTAssertEqual(authorizeEvent.hash, "a1b23c4d56789e0fg1h234567890ijk1")
        XCTAssertEqual(authorizeEvent.issuerCountry, "DNK")
        XCTAssertEqual(authorizeEvent.orderId, "1234")
        XCTAssertEqual(authorizeEvent.paymentType, "2")
        XCTAssertEqual(authorizeEvent.reference, "987654321098")
        XCTAssertEqual(authorizeEvent.subscriptionId, "123456")
        XCTAssertEqual(authorizeEvent.time, "0934")
        XCTAssertEqual(authorizeEvent.tokenId, "a1b2c3d4e5f6")
        XCTAssertEqual(authorizeEvent.txnFee, "0")
        XCTAssertEqual(authorizeEvent.txnId, "123456789012345678")
        XCTAssertEqual(authorizeEvent.ui, "inline")
        XCTAssertEqual(authorizeEvent.walletName, "MobilePay")
        XCTAssertNil(authorizeEvent.additionalFields)
    }

    func test_decode_authorize_without_additional_fields_missing_nullable_fields_success() {
        let jsonResponse = """
        {
         "acceptUrl":"https://example.org/accept",
         "data": {
            "ui":"inline",
            "txnid":"123456789012345678",
            "orderid":"1234",
            "reference":"987654321098",
            "amount":"100",
            "currency":"DKK",
            "date":"20221123",
            "time":"0934",
            "feeid":"54321",
            "txnfee":"0",
            "paymenttype":"2",
            "hash":"a1b23c4d56789e0fg1h234567890ijk1",
          }
        }
        """

        let event = CheckoutEventMapper.mapEventObject(eventType: .authorize, jsonPayload: jsonResponse)

        guard let authorizeEvent = event as? Authorize else {
            XCTFail("Could not cast event as Authorize")
            return
        }

        XCTAssertEqual(authorizeEvent.amount, "100")
        XCTAssertNil(authorizeEvent.cardNumber)
        XCTAssertEqual(authorizeEvent.currency, "DKK")
        XCTAssertEqual(authorizeEvent.date, "20221123")
        XCTAssertNil(authorizeEvent.eci)
        XCTAssertNil(authorizeEvent.expireMonth)
        XCTAssertNil(authorizeEvent.expireYear)
        XCTAssertEqual(authorizeEvent.feeId, "54321")
        XCTAssertEqual(authorizeEvent.hash, "a1b23c4d56789e0fg1h234567890ijk1")
        XCTAssertNil(authorizeEvent.issuerCountry)
        XCTAssertEqual(authorizeEvent.orderId, "1234")
        XCTAssertEqual(authorizeEvent.paymentType, "2")
        XCTAssertEqual(authorizeEvent.reference, "987654321098")
        XCTAssertNil(authorizeEvent.subscriptionId)
        XCTAssertEqual(authorizeEvent.time, "0934")
        XCTAssertNil(authorizeEvent.tokenId)
        XCTAssertEqual(authorizeEvent.txnFee, "0")
        XCTAssertEqual(authorizeEvent.txnId, "123456789012345678")
        XCTAssertEqual(authorizeEvent.ui, "inline")
        XCTAssertNil(authorizeEvent.walletName)
        XCTAssertNil(authorizeEvent.additionalFields)
    }

    func test_decode_authorize_without_additional_fields_missing_nonnullable_field_failed() {
        let jsonResponse = """
        {
         "acceptUrl":"https://example.org/accept",
         "data": {
            "ui":"inline",
            "txnid":"123456789012345678",
            "reference":"987654321098",
            "amount":"100",
            "currency":"DKK",
            "date":"20221123",
            "time":"0934",
            "subscriptionid":"123456",
            "feeid":"54321",
            "txnfee":"0",
            "expmonth":"2",
            "expyear":"25",
            "paymenttype":"2",
            "cardno":"123456XXXXXX1234",
            "eci":"1",
            "issuercountry":"DNK",
            "tokenid":"a1b2c3d4e5f6",
            "hash":"a1b23c4d56789e0fg1h234567890ijk1",
            "walletname":"MobilePay"
          }
        }
        """

        let event = CheckoutEventMapper.mapEventObject(eventType: .authorize, jsonPayload: jsonResponse)

        XCTAssertTrue(event is ErrorEvent)
    }

    func test_decode_authorize_with_additional_fields_success() {
        let jsonResponse = """
        {
         "acceptUrl":"https://example.org/accept",
         "data": {
            "ui":"inline",
            "txnid":"123456789012345678",
            "orderid":"1234",
            "reference":"987654321098",
            "amount":"100",
            "currency":"DKK",
            "date":"20221123",
            "time":"0934",
            "subscriptionid":"123456",
            "feeid":"54321",
            "txnfee":"0",
            "expmonth":"2",
            "expyear":"25",
            "paymenttype":"2",
            "cardno":"123456XXXXXX1234",
            "eci":"1",
            "issuercountry":"DNK",
            "tokenid":"a1b2c3d4e5f6",
            "hash":"a1b23c4d56789e0fg1h234567890ijk1",
            "walletname":"MobilePay",
            "extra1":"extraValue1",
            "extra2":"extraValue2"
          }
        }
        """

        let event = CheckoutEventMapper.mapEventObject(eventType: .authorize, jsonPayload: jsonResponse)

        guard let authorizeEvent = event as? Authorize else {
            XCTFail("Could not cast event as Authorize")
            return
        }

        XCTAssertEqual(authorizeEvent.amount, "100")
        XCTAssertEqual(authorizeEvent.cardNumber, "123456XXXXXX1234")
        XCTAssertEqual(authorizeEvent.currency, "DKK")
        XCTAssertEqual(authorizeEvent.date, "20221123")
        XCTAssertEqual(authorizeEvent.eci, "1")
        XCTAssertEqual(authorizeEvent.expireMonth, "2")
        XCTAssertEqual(authorizeEvent.expireYear, "25")
        XCTAssertEqual(authorizeEvent.feeId, "54321")
        XCTAssertEqual(authorizeEvent.hash, "a1b23c4d56789e0fg1h234567890ijk1")
        XCTAssertEqual(authorizeEvent.issuerCountry, "DNK")
        XCTAssertEqual(authorizeEvent.orderId, "1234")
        XCTAssertEqual(authorizeEvent.paymentType, "2")
        XCTAssertEqual(authorizeEvent.reference, "987654321098")
        XCTAssertEqual(authorizeEvent.subscriptionId, "123456")
        XCTAssertEqual(authorizeEvent.time, "0934")
        XCTAssertEqual(authorizeEvent.tokenId, "a1b2c3d4e5f6")
        XCTAssertEqual(authorizeEvent.txnFee, "0")
        XCTAssertEqual(authorizeEvent.txnId, "123456789012345678")
        XCTAssertEqual(authorizeEvent.ui, "inline")
        XCTAssertEqual(authorizeEvent.walletName, "MobilePay")
        let expectedAdditionalFields = ["extra1": "extraValue1", "extra2": "extraValue2"]
        XCTAssertEqual(authorizeEvent.additionalFields, expectedAdditionalFields)
    }

    func test_decode_authorize_with_additional_fields_missing_nullable_fields_success() {
        let jsonResponse = """
        {
         "acceptUrl":"https://example.org/accept",
         "data": {
            "ui":"inline",
            "txnid":"123456789012345678",
            "orderid":"1234",
            "reference":"987654321098",
            "amount":"100",
            "currency":"DKK",
            "date":"20221123",
            "time":"0934",
            "feeid":"54321",
            "txnfee":"0",
            "paymenttype":"2",
            "hash":"a1b23c4d56789e0fg1h234567890ijk1",
            "extra1":"extraValue1",
            "extra2":"extraValue2"
          }
        }
        """

        let event = CheckoutEventMapper.mapEventObject(eventType: .authorize, jsonPayload: jsonResponse)

        guard let authorizeEvent = event as? Authorize else {
            XCTFail("Could not cast event as Authorize")
            return
        }

        XCTAssertEqual(authorizeEvent.amount, "100")
        XCTAssertNil(authorizeEvent.cardNumber)
        XCTAssertEqual(authorizeEvent.currency, "DKK")
        XCTAssertEqual(authorizeEvent.date, "20221123")
        XCTAssertNil(authorizeEvent.eci)
        XCTAssertNil(authorizeEvent.expireMonth)
        XCTAssertNil(authorizeEvent.expireYear)
        XCTAssertEqual(authorizeEvent.feeId, "54321")
        XCTAssertEqual(authorizeEvent.hash, "a1b23c4d56789e0fg1h234567890ijk1")
        XCTAssertNil(authorizeEvent.issuerCountry)
        XCTAssertEqual(authorizeEvent.orderId, "1234")
        XCTAssertEqual(authorizeEvent.paymentType, "2")
        XCTAssertEqual(authorizeEvent.reference, "987654321098")
        XCTAssertNil(authorizeEvent.subscriptionId)
        XCTAssertEqual(authorizeEvent.time, "0934")
        XCTAssertNil(authorizeEvent.tokenId)
        XCTAssertEqual(authorizeEvent.txnFee, "0")
        XCTAssertEqual(authorizeEvent.txnId, "123456789012345678")
        XCTAssertEqual(authorizeEvent.ui, "inline")
        XCTAssertNil(authorizeEvent.walletName)
        let expectedAdditionalFields = ["extra1": "extraValue1", "extra2": "extraValue2"]
        XCTAssertEqual(authorizeEvent.additionalFields, expectedAdditionalFields)
    }

    func test_decode_authorize_with_additional_fields_missing_nonnullable_field_failed() {
        let jsonResponse = """
        {
         "acceptUrl":"https://example.org/accept",
         "data": {
            "ui":"inline",
            "txnid":"123456789012345678",
            "reference":"987654321098",
            "amount":"100",
            "currency":"DKK",
            "date":"20221123",
            "time":"0934",
            "subscriptionid":"123456",
            "feeid":"54321",
            "txnfee":"0",
            "expmonth":"2",
            "expyear":"25",
            "paymenttype":"2",
            "cardno":"123456XXXXXX1234",
            "eci":"1",
            "issuercountry":"DNK",
            "tokenid":"a1b2c3d4e5f6",
            "hash":"a1b23c4d56789e0fg1h234567890ijk1",
            "walletname":"MobilePay",
            "extra1":"extraValue1",
            "extra2":"extraValue2"
          }
        }
        """

        let event = CheckoutEventMapper.mapEventObject(eventType: .authorize, jsonPayload: jsonResponse)

        XCTAssert(event is ErrorEvent)
    }
}
