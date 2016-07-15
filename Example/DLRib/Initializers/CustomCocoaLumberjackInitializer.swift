//
//  CustomCocoaLumberjackInitializer.swift
//  DLRib
//
//  Created by Konrad Kierys on 15/07/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import Foundation
import CocoaLumberjack
import DLCocoaLumberjackHelper
import Crashlytics

/**
 Class that adds specific loggers for ArticleListView demo app
 */
class CustomCocoaLumberjackInitializer: CocoaLumberjackInitializer {

    /**
     Initialize loggers
     */
    override class func initialize() {

        // For builds other than 'Debug' we want to log only
        // Info, Warning and Error
        if !EnvironmentSettings.isDebug {
            defaultDebugLevel = DDLogLevel.Info
            DDLog.addLogger(crashlyticsLogger())
        }
        DDLog.addLogger(ttyLogger(CocoaLumberjackLogFormatter()))
    }

    /**
     Initialize Crashlytics Logger

     - returns: Crashlytics logger
     */
    class func crashlyticsLogger() -> UniversalLogger {
        let crashlyticsLogger = UniversalLogger(formatter: CocoaLumberjackLogFormatter(), loggingFunction: CLSLogv)
        return crashlyticsLogger
    }
}
