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
        case Alpha = "Alpha", Debug = "Debug", Live = "Live"
    }

    /**
    Check if this is debug or release build

    - returns: true if debug else false
    */
    class var isDebug: Bool {
        return currentEnv == .Debug
    }

    /**
    Check if application runs unit tests

    - returns: Bool
    */
    class var isUnitTest: Bool {
        if let _ = NSClassFromString("XCTest") {
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
            return .Alpha
        #elseif DEBUG
            return .Debug
        #else
            return .Live
        #endif
    }

    /**
     Returns current environment suffix

     - returns: String enviroment suffix
     */
    class func environmentSuffix() -> String {
        var suffix = ""

        switch EnvironmentSettings.currentEnv {
        case .Alpha:
            suffix += "~alpha"
        case .Debug:
            suffix += "~debug"
        case .Live:
            // Do not add anything
            break
        }

        return suffix
    }
}
