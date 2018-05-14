//
//  Privacy+WKNavigationDelegate.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 10.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import WebKit
import CocoaLumberjack

// MARK: WKNavigationDelegate
extension Privacy: WKNavigationDelegate {

    // swiftlint:disable implicitly_unwrapped_optional

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DDLogInfo("Loading web page has been completed")

        webViewLoadingTimer?.invalidate()
        webViewLoadingTimer = nil
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleCMPLoadingError(error)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("error: \(error.localizedDescription) \(error as NSError)")

        handleCMPLoadingError(error)
    }

    // swiftlint:enable implicitly_unwrapped_optional
}
