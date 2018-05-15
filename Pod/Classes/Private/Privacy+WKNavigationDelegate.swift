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

        webViewHostPageLoaded = true
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleCMPLoadingError(error)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleCMPLoadingError(error)
    }

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return
        }

        // Open link in Safari browser
        if let linkUrl = navigationAction.request.url, UIApplication.shared.canOpenURL(linkUrl) {
            UIApplication.shared.openURL(linkUrl)
        }

        decisionHandler(.cancel)
    }

    // swiftlint:enable implicitly_unwrapped_optional
}
