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

import UIKit
import SwiftUI

/**
 ViewController which contains the WebView that shows the Bambora Checkout.
 */
internal class BamboraCheckoutViewController: UIViewController {

    private var paymentData: Authorize?
    private let token: String?
    private let baseUrl: String?
    private let returnUrl: String?
    private let delegate: CheckoutDelegate?
    private var overrideWithURL: URL?
    private var viewTranslation = CGPoint(x: 0, y: 0)

    /**
     Initialization of the ViewController.
     - Parameters:
       - sessionToken: The token that you receive when creating a session.
       - baseUrl: The URL of the Bambora backend to which the SDK will connect.
       - returnUrl: The deeplink that was specified in the URL scheme of the host app.
       - delegate: A delegate which transfers the events from the WebView to the host app.
       - overrideWithURL: Optional.
            If provided, the WebView will open this URL.
            Otherwise the Checkout WebView will be initialized.
     */
    init(
        token: String?,
        baseUrl: String?,
        returnUrl: String?,
        delegate: CheckoutDelegate?,
        overrideWithURL: URL? = nil
    ) {
        self.token = token
        self.baseUrl = baseUrl
        self.returnUrl = returnUrl
        self.delegate = delegate
        self.overrideWithURL = overrideWithURL
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isBeingDismissed {
            delegate?.onWebViewClosed()
        }
    }

    private let checkoutWebView: BamboraCheckoutView = {
        let checkoutView = BamboraCheckoutView()
        checkoutView.translatesAutoresizingMaskIntoConstraints = false
        return checkoutView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()

        checkoutWebView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }

    /**
     Shows the ViewController on top of the host app.
     If the overrideWithUrl is provided, it opens that URL.
     Otherwise it initializes the Checkout WebView.
     */
    func show() {
        if var topController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            self.modalPresentationStyle = .automatic
            if let overrideUrl = overrideWithURL {
                checkoutWebView.openWebViewWith(url: overrideUrl)
            } else {
                initializeWith(token: token ?? "", baseUrl: baseUrl ?? "", returnUrl: returnUrl ?? "")
            }
            topController.present(self, animated: true)
        }
    }

    /// Dismisses the ViewController.
    func dismiss() {
        dismiss(animated: true)
    }

    /// Dismisses the View, only when it has been dragged down far enough.
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                }
            )
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 1,
                    options: .curveEaseOut,
                    animations: {
                        self.view.transform = .identity
                    }
                )
            } else {
                self.dismiss()
            }
        default:
            break
        }
    }

    /**
     Initialization of the WebView.
     - Parameters:
        - sessionToken: The token that you receive when creating a session.
        - baseUrl: The URL of the Bambora backend to which the SDK will connect.
        - returnUrl: The deeplink that was specified in the URL scheme of the host app.
     */
    func initializeWith(token: String, baseUrl: String, returnUrl: String) {
        checkoutWebView.initialize(checkoutToken: token, baseUrl: baseUrl, returnUrl: returnUrl)
    }

    private func setupConstraints() {
        self.view.addSubview(checkoutWebView)

        NSLayoutConstraint.activate([
            checkoutWebView.topAnchor.constraint(equalTo: view.topAnchor),
            checkoutWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
