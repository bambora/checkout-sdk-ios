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
import SwiftUI

struct PaymentDataView: View {
    internal let paymentData: Authorize

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Group {
                HStack {
                    Text("Transaction ID:")
                    Spacer()
                    Text(paymentData.txnId)
                }
                HStack {
                    Text("Order ID:")
                    Spacer()
                    Text(paymentData.orderId)
                }
                HStack {
                    Text("Reference:")
                    Spacer()
                    Text(paymentData.reference)
                }
                HStack {
                    Text("Amount:")
                    Spacer()
                    Text(paymentData.amount)
                }
                HStack {
                    Text("Currency:")
                    Spacer()
                    Text(paymentData.currency)
                }
                HStack {
                    Text("Date:")
                    Spacer()
                    Text(paymentData.date)
                }
                HStack {
                    Text("Time:")
                    Spacer()
                    Text(paymentData.time)
                }
                HStack {
                    Text("Fee ID:")
                    Spacer()
                    Text(paymentData.feeId)
                }
                HStack {
                    Text("Transaction Fee:")
                    Spacer()
                    Text(paymentData.txnFee)
                }
                HStack {
                    Text("Payment Type ID:")
                    Spacer()
                    Text(paymentData.paymentType)
                }
            }
            Group {
                HStack {
                    Text("Wallet name:")
                    Spacer()
                    Text(paymentData.walletName ?? "n.a.")
                        .foregroundColor(paymentData.walletName == nil ? .gray : .white)
                }
                HStack {
                    Text("Card number:")
                    Spacer()
                    Text(paymentData.cardNumber ?? "n.a.")
                        .foregroundColor(paymentData.cardNumber == nil ? .gray : .white)
                }
                HStack {
                    Text("Expire month:")
                    Spacer()
                    Text(paymentData.expireMonth ?? "n.a.")
                        .foregroundColor(paymentData.expireMonth == nil ? .gray : .white)
                }
                HStack {
                    Text("Expire year:")
                    Spacer()
                    Text(paymentData.expireYear ?? "n.a.")
                        .foregroundColor(paymentData.expireYear == nil ? .gray : .white)
                }
                HStack {
                    Text("Subscription ID:")
                    Spacer()
                    Text(paymentData.subscriptionId ?? "n.a.")
                        .foregroundColor(paymentData.subscriptionId == nil ? .gray : .white)
                }
                HStack {
                    Text("Token ID:")
                    Spacer()
                    Text(paymentData.tokenId ?? "n.a.")
                        .foregroundColor(paymentData.tokenId == nil ? .gray : .white)
                }
                HStack {
                    Text("ECI:")
                    Spacer()
                    Text(paymentData.eci ?? "n.a.")
                        .foregroundColor(paymentData.eci == nil ? .gray : .white)
                }
                HStack {
                    Text("Issuer Country:")
                    Spacer()
                    Text(paymentData.issuerCountry ?? "n.a.")
                        .foregroundColor(paymentData.issuerCountry == nil ? .gray : .white)
                }
                HStack {
                    Text("Hash:")
                    Spacer()
                    Text(paymentData.hash)
                }
            }
            if let additionalFields = paymentData.additionalFields {
                ForEach(additionalFields.sorted(by: >), id: \.key) { field, data in
                    HStack {
                        Text("\(field.capitalized):")
                        Spacer()
                        Text(data)
                    }
                }
            }
        }
    }
}

struct PaymentDataView_Previews: PreviewProvider {

    static var previews: some View {
        PaymentDataView(paymentData: TestData.paymentData)
    }
}
