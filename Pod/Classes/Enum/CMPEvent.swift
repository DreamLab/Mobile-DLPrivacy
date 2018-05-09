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
/// - error: Something went wrong with event listeners
@objc
enum CMPEvent: Int {

    case formLoaded
    case formReady
    case formSubmitted
    case welcomeScreenVisible
    case vendorsConsentsReceived
    case error

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
        case "cmpVendorsConsentsReceived":
            self = .vendorsConsentsReceived
        case "cmpError":
            self = .error
        default:
            return nil
        }
    }
}
