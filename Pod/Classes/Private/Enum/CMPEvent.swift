//
//  CMPEvent.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

/// Events possible to receive from CMP tool
///
/// - formLoaded: JavaScript form was loaded
/// - formReady: Form is ready to perform actions
/// - formSubmitted: Form was submitted by the user
/// - welcomeScreenVisible: Form was asked to show welcome screen and returned response
/// - settingsScreenVisible: Form was asked to show settings screen and returned response
/// - vendorsConsentsReceived: Vendors consents data
/// - shouldShowConsentsForm: Vendors list has changed and app should show again consents form
/// - canShowPersonalizedAds: Form answered if app can show personalized ads
/// - sponsoringAdsConsents:
/// - error: Something went wrong with event listeners
enum CMPEvent {

    case formLoaded
    case formReady
    case formSubmitted
    case welcomeScreenVisible
    case settingsScreenVisible
    case vendorsConsentsReceived
    case shouldShowConsentsForm
    case canShowPersonalizedAds
    case sponsoringAdsConsents
    case error

    // swiftlint:disable cyclomatic_complexity

    /// Initialize CMPEvent from JavaScript message
    ///
    /// - Parameter message: String
    init?(from message: String) {
        switch message {
        case "isLoaded":
            self = .formLoaded
        case "cmpReady":
            self = .formReady
        case "onSubmit":
            self = .formSubmitted
        case "cmpWelcomeVisible":
            self = .welcomeScreenVisible
        case "cmpSettingsVisible":
            self = .settingsScreenVisible
        case "cmpVendorsConsentsReceived":
            self = .vendorsConsentsReceived
        case "shouldShowConsentsForm":
            self = .shouldShowConsentsForm
        case "canShowPersonalizedAds":
            self = .canShowPersonalizedAds
        case "sponsoringAdsConsents":
            self = .sponsoringAdsConsents
        case "cmpError":
            self = .error
        default:
            return nil
        }
    }

    // swiftlint:enable cyclomatic_complexity
}
