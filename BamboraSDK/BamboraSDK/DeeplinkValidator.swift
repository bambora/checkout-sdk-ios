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

internal class DeepLinkValidator {

    private static let allowedDomains = [
        "wallet-v1-test.api.epay.eu",
        "wallet-v1.api.epay.eu",
        "wallet-v1.api.epay.eu",
        "wallet-v1.api-eu.bambora.com",
        "authorize-v1-test.api.epay.eu",
        "authorize-v1.api.epay.eu",
        "authorize-v1.api-eu.bambora.com"
    ]

    /**
     Retrieves the epayReturnUrl from the url.
     - Parameter url: The URL that reopens the SDK. This URL contains the epayReturnUrl as a query parameter.
     - Returns: nil if the provided URL is not valid, otherwise the url is returned as a String.
     */
    static func processDeeplink(url: URL) -> URL? {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
           let queryItems = components.queryItems,
           let epayReturn = queryItems["epayreturn"],
           let urlString = epayReturn.removingPercentEncoding {
            if isAllowedDomain(url: urlString), let url = URL(string: urlString) {
                return url
            }
        }
        return nil
    }

    /**
     Checks if the provided URL's host name is an allowed domain.
     - Parameter url: The URL whose host name should be checked.
     - Returns: Bool.
        True, if the URL's host name is an allowed domain.
        False, if the URL's host name is not an allowed domain or is nil.
     */
    static func isAllowedDomain(url: String) -> Bool {
        if let host = URL(string: url)?.host {
            return allowedDomains.contains { $0 == host }
        }
        return false
    }
}
