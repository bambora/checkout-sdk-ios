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

class CheckoutViewController: UIViewController {
    @IBOutlet weak var checkoutWebView: BOCheckoutView!
    @IBOutlet weak var paymentTypeInfoHeaderLabel: UILabel!
    @IBOutlet weak var paymentTypeDisplayNameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var completePaymentButton: UIButton!
    
    var authorizePayload = ""
    let apiKey = "RHZ6RkdBcTVEOExMVmpOS29vM2NAVDEwNTExMzcwMTpQZ3VtUDVhUWs2NWdFcExUcU5Pd29CV1drNVVlZFI5REpCTjdibU9r"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Set event listner functions
        checkoutWebView!.on(eventType: "*", eventHandler: anyEventHandler)
        checkoutWebView!.on(eventType: BOCheckoutEventsType.Authorize.rawValue, eventHandler: authorizeEventHandler)
        checkoutWebView!.on(eventType: BOCheckoutEventsType.CardTypeResolve.rawValue, eventHandler: cardTypeResolveEventHandler)
        setCheckoutSessionAndOpenPaymentWindow()
    }
    
    func openCheckoutPaymentWindowWith(token: String) {
        //Initilize and open the payment window with a checkout session token
        checkoutWebView!.initialize(checkoutToken: token )
    }
    
    
    func anyEventHandler(eventData: BOCheckoutEventData){
        print("Any: EventType: " + eventData.eventType + " Payload: " + eventData.payload)
        
    }
    
    func authorizeEventHandler(eventData: BOCheckoutEventData){
        cancelButton.isHidden = true
        paymentTypeInfoHeaderLabel.isHidden = true
        paymentTypeDisplayNameLabel.isHidden = true
        completePaymentButton.isHidden = false
        authorizePayload = eventData.payload
    }
    
    func cardTypeResolveEventHandler(eventData: BOCheckoutEventData){
        print("CardTypeResolve: EventType: " + eventData.eventType + " Payload: " + eventData.payload)
        let bamboraCheckoutHelper = BOCheckoutHelper()
        let parsedData: NSDictionary = bamboraCheckoutHelper.parsePayloadToNSDictionary(payload: eventData.payload)
        
        if let paymentTypeDisplayName: String = parsedData["displayname"] as? String{
            paymentTypeDisplayNameLabel.text = paymentTypeDisplayName
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //retrieve the destination view controller for free
        if let authorizeViewController = (segue.destination as? AuthorizeViewController) {
            authorizeViewController.authorizePayload = authorizePayload
        }
    }
    func createCheckoutSessionRequest() -> Dictionary<String, Any> {
        let orderId = arc4random_uniform(999999)
        
        let checkoutOrder = ["id": String(orderId),
                             "amount": 375,
                             "currency": "EUR"] as [String : Any]
        let checkoutUrl = ["accept": "https://checkout-sdk-demo.bambora.com/accept",
                           "cancel": "https://checkout-sdk-demo.bambora.com/cancel"]
        let checkoutRequest = ["order": checkoutOrder,
                               "url": checkoutUrl]
        return checkoutRequest
    }
    
    
    func setCheckoutSessionAndOpenPaymentWindow(){
        do {
            let params = createCheckoutSessionRequest()
            let data = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions(rawValue: 0))
            let url = NSURL(string: "https://api.v1.checkout.bambora.com/sessions")
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url! as URL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("iOS SDK Demo", forHTTPHeaderField: "X-EPay-System")
            request.addValue("Basic \(apiKey)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.httpBody = data
            
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    if statusCode == 500  {
                        print("HTTP Error \(statusCode) when getting session token. Error: \(error?.localizedDescription ?? "")")
                    } else {
                        do{
                            let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>
                            
                            if let meta = jsonResponse!["meta"] as? Dictionary<String, AnyObject> {
                                if let metaResult = meta["result"] as? Bool {
                                    if metaResult == true {
                                        let token = (jsonResponse!["token"] as? String)!
                                        DispatchQueue.main.async {
                                            self.openCheckoutPaymentWindowWith(token: token)
                                        }
                                    } else {
                                        print("Meta result is false")
                                    }
                                }
                            }
                        } catch {}
                    }
                }
            }
            
            task.resume()
            
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

