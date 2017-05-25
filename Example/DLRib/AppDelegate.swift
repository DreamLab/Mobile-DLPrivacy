//
//  AppDelegate.swift
//  DLRib
//
//  Created by Konrad Falkowski on 17/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import UIKit
import CocoaLumberjack
import DLCocoaLumberjackHelper
import DLAppHelper

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()

        earlyInitialize()
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initialize()
        displayDebugInfo()
        DDLogInfo("Application did finish launching")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        DDLogInfo("Application will resign active")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        DDLogInfo("Application did enter background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        DDLogInfo("Application will enter foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        DDLogInfo("Application did become active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DDLogInfo("Application will be terminated")
    }
}

// MARK: App initialization
extension AppDelegate {
    /**
     Initialize frameworks, libraries and other components needed by the app
     Initialization is done before didFinishLaunchingWithOptions
     */
    fileprivate func earlyInitialize() {
        CustomCocoaLumberjackInitializer.initialize()
        CocoaLumberjackInitializer.initialize()

        DDLogInfo("Application did start early initializing")

        DDLogInfo("Application did finish early initializing")
    }

    /**
     Initialize frameworks, libraries and other components needed by the app
     Initialization is done in didFinishLaunchingWithOptions
     */
    fileprivate func initialize() {
        DDLogInfo("Application did start initializing")

        FabricInitializer.initialize()

        DDLogInfo("Application did finish initializing")
    }

    fileprivate func displayDebugInfo() {
        if let window = window, EnvironmentSettings.currentEnv != .live {
            AppHelper.displayEnvironmentAndVersionOnView(window, environmentString: EnvironmentSettings.currentEnv.rawValue)
        }
    }
}
