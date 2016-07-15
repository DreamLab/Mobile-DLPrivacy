//
//  AppDelegate.swift
//  DLRib
//
//  Created by Konrad Falkowski on 17/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import UIKit
import DLCocoaLumberjackHelper
import DLAppHelper

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()

        earlyInitialize()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        initialize()
        displayDebugInfo()
        DDLogInfo("Application did finish launching")

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        DDLogInfo("Application will resign active")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        DDLogInfo("Application did enter background")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        DDLogInfo("Application will enter foreground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        DDLogInfo("Application did become active")
    }

    func applicationWillTerminate(application: UIApplication) {
        DDLogInfo("Application will be terminated")
    }
}

// MARK: App initialization
extension AppDelegate {
    /**
     Initialize frameworks, libraries and other components needed by the app
     Initialization is done before didFinishLaunchingWithOptions
     */
    private func earlyInitialize() {
        CustomCocoaLumberjackInitializer.initialize()

        DDLogInfo("Application did start early initializing")

        DDLogInfo("Application did finish early initializing")
    }

    /**
     Initialize frameworks, libraries and other components needed by the app
     Initialization is done in didFinishLaunchingWithOptions
     */
    private func initialize() {
        DDLogInfo("Application did start initializing")

        FabricInitializer.initialize()
        ASNotificationServiceInitializer.initialize()

        DDLogInfo("Application did finish initializing")
    }

    private func displayDebugInfo() {
        if let window = window where EnvironmentSettings.currentEnv != .Live {
            AppHelper.displayEnvironmentAndVersionOnView(window, environmentString: EnvironmentSettings.currentEnv.rawValue)
        }
    }
}
