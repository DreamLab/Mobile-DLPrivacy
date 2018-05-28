//
//  PrivacyHelper.swift
//  DLPrivacy
//
//  Created by Falkowski Konrad on 28/05/2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit
import WebKit

/// Helper for Privacy
class PrivacyHelper {

    /// JavaScript scripts used in underlaying web view
    private static let jsScripts = ["CMPEventListeners"]

    private var consentsData: PrivacyConsentsData

    /// Initializer
    ///
    /// - Parameter consentsData: Privacy Consents Data
    init(with consentsData: PrivacyConsentsData) {
        self.consentsData = consentsData
    }

    /// Return script with coookies form a domain
    ///
    /// - Parameter domain: domain
    /// - Returns: WKUserScript
    func jsScriptWithCookies(for domain: String) -> WKUserScript? {
        let pubConsent = consentsData.pubConsent ?? ""
        let euConsent = consentsData.euConsent ?? ""
        let adpConsent = consentsData.adpConsent ?? ""

        var jsString = ""
        if let url = Privacy.resourcesBundle.url(forResource: "CMPCookieSetters", withExtension: "js"),
            let script = try? String(contentsOf: url) {
            jsString = script
        }

        jsString += pubConsent.isEmpty ? "" : "setCookie('\(domain)','pubconsent','\(pubConsent)');"
        jsString += euConsent.isEmpty ? "" : "setCookie('\(domain)','euconsent','\(euConsent)');"
        jsString += adpConsent.isEmpty ? "" : "setCookie('\(domain)','adpconsent','\(adpConsent)');"

        guard !jsString.isEmpty else { return nil }

        return WKUserScript(source: jsString, injectionTime: .atDocumentStart, forMainFrameOnly: true)
    }

    /// Returns wildcard domain from a domain
    /// Example:
    ///     wildcardDomain(from: "this.is.not.last.domain.pl") -> "domain.pl"
    ///     wildcardDomain(from: "m.domain.pl") -> "domain.pl"
    ///     wildcardDomain(from: "domain.pl") -> "domain.pl"
    ///
    /// - Parameter domain: domain
    /// - Returns: wildcard domain
    func wildcardDomain(from domain: String) -> String {
        let minimumNumberOfComponents = 2
        var components = domain.components(separatedBy: ".")
        guard components.count > minimumNumberOfComponents else { return domain }

        components.removeFirst(components.count - minimumNumberOfComponents)
        let wildcardDomain = components.joined(separator: ".")

        return wildcardDomain
    }

    // MARK: WKWebView config

    /// Extend WKWebView configuration by adding user content controller and JS event listeners
    ///
    /// - Returns: WKWebViewConfiguration
    static func defaultWebViewConfiguration() -> WKWebViewConfiguration {
        let wkUserController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = wkUserController

        // Insert scripts
        PrivacyHelper.jsScripts.flatMap {
            guard let url = Privacy.resourcesBundle.url(forResource: $0, withExtension: "js"),
                let jsScript = try? String(contentsOf: url) else {
                    return nil
            }

            return WKUserScript(source: jsScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        }.forEach {
            wkUserController.addUserScript($0)
        }

        return config
    }
}
