//
//  CocoaLumberjackInitializer.swift
//  Backbone
//
//  Created by Lukasz Harazny on 13/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import Foundation
import CocoaLumberjack
import DLCocoaLumberjackHelper

/**
Class to initialize CocoaLumberjack
*/
class CocoaLumberjackInitializer {

    /**
    Initialize loggers
    */
    class func initialize() {

        // For builds other than 'Debug' we want to log only
        // Info, Warning and Error
        if !EnvironmentSettings.isDebug {
            defaultDebugLevel = DDLogLevel.Info
        }
    }
}

// MARK: File logger
private extension CocoaLumberjackInitializer {

    /**
    Create file logger

    - returns: File logger
    */
    class func fileLogger() -> DDFileLogger {
        let fileLogger = DDFileLogger(logFileManager: DDLogFileManagerDefault())
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 1
        fileLogger.logFormatter = CocoaLumberjackLogFormatter()

        return fileLogger
    }

    /**
    Initialize TTYLogger

    - returns: Terminal/Xcode console logger
    */
    class func ttyLogger() -> DDTTYLogger {
        DDTTYLogger.sharedInstance().logFormatter = CocoaLumberjackConsoleLogFormatter()
        return DDTTYLogger.sharedInstance()
    }
}
