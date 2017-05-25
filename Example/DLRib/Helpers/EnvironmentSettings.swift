//
//  EnvironmentSettings.swift
//  DLRib
//
//  Created by Konrad Falkowski on 17/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import Foundation

/*
Class to read current environment
*/
final class EnvironmentSettings {

    enum Environment: String {
        case alpha = "Alpha", debug = "Debug", live = "Live"
    }

    /**
    Check if this is debug or release build

    - returns: true if debug else false
    */
    class var isDebug: Bool {
        return currentEnv.rawValue == Environment.debug.rawValue
    }

    /**
    Check if application runs unit tests

    - returns: Bool
    */
    class var isUnitTest: Bool {
        if NSClassFromString("XCTest") != nil {
            return true
        }

        return false
    }

    /**
    Returns current environment depends on defined macro

    - returns: Environment enum value
    */
    class var currentEnv: Environment {
        #if ALPHA
            return .alpha
        #elseif DEBUG
            return .debug
        #else
            return .live
        #endif
    }

    /**
     Returns current environment suffix

     - returns: String enviroment suffix
     */
    class func environmentSuffix() -> String {
        var suffix = ""

        switch EnvironmentSettings.currentEnv {
        case .alpha:
            suffix += "~alpha"
        case .debug:
            suffix += "~debug"
        case .live:
            // Do not add anything
            break
        }

        return suffix
    }
}
