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

/// Errors which can be thrown in the SDK.
public enum BamboraError: Error {
    case internetError
    case loadSessionError
    case genericError
    case sdkNotInitializedError
    case sdkAlreadyInitializedError
}

extension BamboraError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .internetError:
            return "No internet connection."
        case .loadSessionError:
            return "There was a problem while loading the session."
        case .genericError:
            return "An unexpected error has occured."
        case .sdkNotInitializedError:
            return "Please initialize the Bambora SDK before you use this operation."
        case .sdkAlreadyInitializedError:
            return "SDK already initialized. Close the SDK first by calling Bambora.close()"
        }
    }
}

extension BamboraError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .internetError:
            return NSLocalizedString("No internet connection",
                                     comment: "No internet connection")
        case .loadSessionError:
            return NSLocalizedString("There was a problem while loading the session.",
                                     comment: "There was a problem while loading the session.")
        case .genericError:
            return NSLocalizedString("An unexpected error has occured.",
                                     comment: "An unexpected error has occured.")
        case .sdkNotInitializedError:
            return NSLocalizedString("Please initialize the Bambora SDK before you use this operation.",
                                     comment: "Please initialize the Bambora SDK before you use this operation.")
        case .sdkAlreadyInitializedError:
            return NSLocalizedString("SDK already initialized. Close the SDK first by calling Bambora.close()",
                                     comment: "SDK already initialized. Close the SDK first by calling Bambora.close()")
        }
    }
}
