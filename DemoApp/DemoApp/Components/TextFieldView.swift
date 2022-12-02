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

import SwiftUI

struct TextFieldView: View {
    private enum Constants {
        static let offset: CGFloat = -18
        static let headerTextSize: CGFloat = 13
        static let normalTextSize: CGFloat = 16
    }

    private var placeholder: String
    private var errorText: String?
    private var isSecureTextEntry: Bool
    private var autocorrection: Bool
    private var autocapitalization: UITextAutocapitalizationType
    private var keyboardType: UIKit.UIKeyboardType
    private var isFocused: (Bool) -> Void
    private var buttonCallback: (() -> Void)?

    @Binding private var text: String
    @State private var isSecureTextOn: Bool = true

    private func clearText() { text = "" }

    public init(
        placeholder: String = "Placeholder",
        text: Binding<String>,
        errorText: String?,
        isSecureTextEntry: Bool = false,
        isFocused: @escaping (Bool) -> Void,
        autocorrection: Bool = false,
        autocapitalization: UITextAutocapitalizationType = .none,
        keyboardType: UIKit.UIKeyboardType = .default,
        buttonCallback: (() -> Void)? = nil
    ) {
        self._text = text
        self.errorText = errorText
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.isFocused = isFocused
        self.autocorrection = autocorrection
        self.autocapitalization = autocapitalization
        self.keyboardType = keyboardType
        self.buttonCallback = buttonCallback
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty, placeholder: {
                        Text(placeholder).foregroundColor(.gray)
                    })
                    .font(.body)
                    .disableAutocorrection(.none)
                    .autocapitalization(.none)
                    .keyboardType(keyboardType)
                    .foregroundColor(Color.white)
                    .padding(.leading, 13)
                if errorText != nil {
                    errorImage
                } else {
                    EmptyView()
                }
            }
            .frame(height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(errorText == nil ? Color(UIColor.lightGray) : .red, lineWidth: 1)
            )
            if let errorText = errorText {
                Text(errorText)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 10)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var errorImage: some View {
        Image(systemName: "exclamationmark.circle.fill")
            .foregroundColor(.red)
            .padding(.trailing, 10)
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {

        TextFieldView(
            text: .constant("some example text"),
            errorText: "this is a short error",
            isFocused: { _ in }
        )
            .previewLayout(.sizeThatFits)

        TextFieldView(
            placeholder: "Password",
            text: .constant("some example text"),
            errorText: "",
            isSecureTextEntry: true,
            isFocused: { _ in },
            autocorrection: false,
            autocapitalization: .none,
            keyboardType: .default
        )
            .previewLayout(.sizeThatFits)

        TextFieldView(
            placeholder: "Password",
            text: .constant("some example text"),
            errorText: "this is a very long error this, is a very long error, this is a very long error",
            isSecureTextEntry: true,
            isFocused: { _ in }
        )
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)

        TextFieldView(
            placeholder: "Password",
            text: .constant("some example text"),
            errorText: "",
            isSecureTextEntry: true,
            isFocused: { _ in },
            autocorrection: false,
            autocapitalization: .none,
            keyboardType: .default
        )
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
