//
//  CustomCocoaLumberjackInitializer.swift
//  DLPrivacy
//
//  Created by Konrad Kierys on 15/07/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import Foundation
import CocoaLumberjack
import DLCocoaLumberjackHelper
import Crashlytics

/// Class that adds specific loggers for ArticleListView demo app
class CustomCocoaLumberjackInitializer {

    /// Initialize loggers
    class func initialize() {

        var loggers = [CocoaLumberjackLogger]()
        // For builds other than 'Debug' we want to log only
        // Info, Warning and Error
        if !EnvironmentSettings.isDebug {
            defaultDebugLevel = DDLogLevel.info
            DDLog.add(crashlyticsLogger())
        }

        loggers.append(.ttyLogger(formatter: CocoaLumberjackLogFormatter()))
        CocoaLumberjackInitializer.initializeWithLoggers(loggers, logLevel: defaultDebugLevel)

    }

    /// Initialize Crashlytics Logger
    ///
    /// - Returns: Crashlytics logger
    class func crashlyticsLogger() -> UniversalLogger {
        let crashlyticsLogger = UniversalLogger(formatter: CocoaLumberjackLogFormatter(), loggingFunction: CLSLogv)
        return crashlyticsLogger
    }
}
