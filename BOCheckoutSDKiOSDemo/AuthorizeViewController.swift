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

import UIKit
import BOCheckoutSDKiOS

class AuthorizeViewController: UIViewController {
    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var feeIdLabel: UILabel!
    @IBOutlet weak var transactionFeeLabel: UILabel!
    @IBOutlet weak var paymentTypeIdLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var eciLabel: UILabel!
    @IBOutlet weak var issuerCountryLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    
    public var authorizePayload = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AuthorizePayload: " + authorizePayload)
        let bamboraCheckoutHelper = BOCheckoutHelper()
        
        let payloadData: NSDictionary = bamboraCheckoutHelper.parsePayloadToNSDictionary(payload: authorizePayload)
        
        setupLabels(data: payloadData)
    }
    
    func setupLabels(data:NSDictionary) {
        
        if let payload: NSDictionary = data["data"] as? NSDictionary {
            if let txnId: String = payload["txnid"] as? String{
                transactionIdLabel.text = txnId
            }
            
            if let orderId: String = payload["orderid"] as? String{
                orderIdLabel.text = orderId
            }
            
            if let reference: String = payload["reference"] as? String{
                referenceLabel.text = reference
            }
            
            if let amount: String = payload["amount"] as? String{
                let amountFromString = Int(amount)
                let realAmount = amountFromString! / 100
                amountLabel.text = String(realAmount)
            }
            
            if let currency: String = payload["currency"] as? String{
                currencyLabel.text = currency
            }
            
            if let date: String = payload["date"] as? String{
                dateLabel.text = date
            }
            
            if let time: String = payload["time"] as? String{
                timeLabel.text = time
            }
            
            if let feeId: String = payload["feeid"] as? String{
                feeIdLabel.text = feeId
            }
            
            if let txnFee: String = payload["txnfee"] as? String{
                if txnFee.count > 0 {
                    let feeAmountFromString = Int(txnFee)
                    let realAmount = feeAmountFromString! / 100
                    transactionFeeLabel.text = String(realAmount)
                } else {
                    transactionFeeLabel.text = "0"
                }
            }
            
            if let paymentType: String = payload["paymenttype"] as? String{
                paymentTypeIdLabel.text = paymentType
            }
            
            if let cardNo: String = payload["cardno"] as? String{
                cardNumberLabel.text = cardNo
            }
            
            if let eci: String = payload["eci"] as? String{
                eciLabel.text = eci
            }
            
            if let issuerCountry: String = payload["issuercountry"] as? String{
                issuerCountryLabel.text = issuerCountry
            }
            
            if let hash: String = payload["hash"] as? String{
                hashLabel.text = hash
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
