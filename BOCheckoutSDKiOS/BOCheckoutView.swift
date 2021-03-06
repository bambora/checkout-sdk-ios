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
import WebKit

public class BOCheckoutView: UIView{
    var webView:WKWebView!
    var eventController: BOCheckoutEventController!
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        setupWebView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWebView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = self.bounds
    }
    
    private func setupWebView(){
        eventController = BOCheckoutEventController()
        let webConfiguration = WKWebViewConfiguration()
        
        let contentController = WKUserContentController()
        // Add ScriptMessageHandler
        contentController.add(
            eventController,
            name: eventController.getCheckoutEventIdentifier()
        )
        webConfiguration.userContentController = contentController
        webView = WKWebView(frame: self.bounds, configuration: webConfiguration)
        
        webView!.isOpaque = false
        webView!.backgroundColor = UIColor.clear
        webView!.scrollView.backgroundColor = UIColor.clear
        
        self.addSubview(webView)
    }
    
    public func initialize(checkoutToken:String) {
        let versionHash = getSDKVersionHash()
        let checkoutUrl = URL(string: "https://v1.checkout.bambora.com/" + checkoutToken + "?ui=inline#" + versionHash)
        let myRequest = URLRequest(url: checkoutUrl!)
        webView.load(myRequest)
    }
    
    private func getSDKVersionHash() -> String {
        let sdkVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let versionString = "CheckoutSDKiOS/" + sdkVersion!
        let data = (versionString).data(using: String.Encoding.utf8)
        let result = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return result
    }

    
    
    public func on(eventType: String, eventHandler:@escaping (BOCheckoutEventData) -> Void) {
       eventController.on(eventType: eventType.lowercased(), eventHandler: eventHandler)
    }
    
    public func off(eventType: String) {
       eventController.off(eventType: eventType.lowercased())
    }
}
