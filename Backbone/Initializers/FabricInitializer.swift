//
//  HockeyAppInitializer.swift
//  Backbone
//
//  Created by Konrad Falkowski on 18/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

/**
Class to initialize Fabric SDK
*/
class FabricInitializer {

    /**
    Initialize Fabric SDK
    */
    class func initialize() {
        if !EnvironmentSettings.isDebug {
            Fabric.sharedSDK().debug = true
            Fabric.with([Crashlytics.self])
        }
    }
}
