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

struct StartSessionView: View {
    @ObservedObject private var bamboraSDKHelper: BamboraSDKHelper
    @State private var token: String = ""
    @State private var tokenError: String?
    @State private var customUrl = UserDefaults.standard.string(forKey: Constants.Keys.customUrl) ?? ""
    @State private var customUrlError: String?
    @State private var showDetailsScreen: Bool = false
    @State private var useCustomUrl = UserDefaults.standard.bool(forKey: Constants.Keys.checkboxStatus)

    init(bamboraSDKHelper: BamboraSDKHelper) {
        self.bamboraSDKHelper = bamboraSDKHelper
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer(minLength: 50)
                    Image("wordline")
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                    Text("Bambora Checkout iOS")
                        .foregroundColor(Constants.Theme.accentColor)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    VStack(spacing: 20) {
                        TextFieldView(
                            placeholder: "Session ID",
                            text: $token,
                            errorText: tokenError,
                            isFocused: {_ in })

                        if useCustomUrl {
                            TextFieldView(
                                placeholder: "Custom URL",
                                text: $customUrl,
                                errorText: customUrlError,
                                isFocused: {_ in })
                        }

                        ActionButton("Open Checkout", openCheckout)

                        Toggle(isOn: $useCustomUrl) {
                            Text("Use custom URL")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 5)
                    }

                    Spacer()

                    NavigationLink("", isActive: $showDetailsScreen) {
                        if let paymentData = bamboraSDKHelper.paymentData {
                            PaymentCompleteView(paymentData: paymentData) {
                                token = ""
                                showDetailsScreen = false
                            }
                        }
                    }

                }
                .onReceive(bamboraSDKHelper.$paymentData) { paymentData in
                    if paymentData != nil {
                        showDetailsScreen = true
                    }
                }
                .onReceive(bamboraSDKHelper.$errorEvent) { error in
                    if let error {
                        print(error.payload.localizedDescription)
                    }
                }
            }
            .padding(.horizontal, 20)
            .frame(maxHeight: .infinity)
            .background(Constants.Theme.backgroundColor)
            .ignoresSafeArea()
        }
    }

    private func openCheckout() {
        guard validateInput() else { return }
        UserDefaults.standard.setValue(useCustomUrl, forKey: Constants.Keys.checkboxStatus)
        do {
            try bamboraSDKHelper.initializeCheckout(token: token, useCustomUrl: useCustomUrl, customUrl: customUrl)
        } catch {
            print(#function, error)
        }
    }

    private func validateInput() -> Bool {
        tokenError = token.isEmpty ? "Session ID cannot be empty" : nil

        if useCustomUrl {
            if customUrl.isEmpty {
                customUrlError = "Custom URL cannot be empty"
            } else if !customUrl.isValidURL {
                customUrlError = "Not a valid URL"
            } else {
                customUrlError = nil
                UserDefaults.standard.setValue(customUrl, forKey: Constants.Keys.customUrl)
            }
        }

        if tokenError == nil && customUrlError == nil {
            return true
        }
        return false
    }
}

struct StartSessionView_Previews: PreviewProvider {

    static var previews: some View {
        StartSessionView(bamboraSDKHelper: BamboraSDKHelper())
    }
}
