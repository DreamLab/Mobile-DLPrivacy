//
//  CMPApiFetcher.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 24.07.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import CocoaLumberjack

/// Class responsible for communication with CMP API
class CMPApiFetcher {

    /// API base url
    private let apiBaseUrl: String

    /// Underlaying url session
    private let session: URLSession

    // MARK: Init

    /// Initializer
    ///
    /// - Parameters:
    ///   - apiBaseUrl: String
    ///   - timeoutInterval: TimeInterval
    init(apiBaseUrl: String, timeoutInterval: TimeInterval) {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = timeoutInterval
        sessionConfiguration.httpAdditionalHeaders = [
            "User-Agent": DreamLabUserAgent.defaultDreamLabUserAgent
        ]

        self.apiBaseUrl = apiBaseUrl
        self.session = URLSession(configuration: sessionConfiguration)
    }

    // MARK: Methods

    /// Fetch consents status
    ///
    /// - Parameters:
    ///   - consents: PrivacyConsentsData
    ///   - completion: Completion handler
    func getConsentsStatus(for consents: PrivacyConsentsData, completion: @escaping (_ status: CMPConsentsStatus?) -> Void) {
        let pubconsent = consents.pubConsent ?? ""
        let adpconsent = consents.adpConsent ?? ""

        let urlString = "\(apiBaseUrl)/func/verify?pubconsent=\(pubconsent)&adpconsent=\(adpconsent)"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = session.dataTask(with: url) { (data, _, _) in
            guard let apiData = data else {
                completion(nil)
                return
            }

            let json = try? JSONSerialization.jsonObject(with: apiData, options: .allowFragments) as? [String: Any]

            guard let rawStatus = json??["status"] as? String else {
                completion(nil)
                return
            }

            DDLogInfo("Retrieved raw consents status: \(rawStatus)")

            let status = CMPConsentsStatus(from: rawStatus)
            completion(status)
        }

        task.resume()
    }
}
