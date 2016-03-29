//
//  DatabaseInitializer.swift
//  Backbone
//
//  Created by Konrad Falkowski on 18/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import Foundation

/**
Class to initialize database
*/
class DatabaseInitializer {

    /**
    Initialize database
    */
    class func initialize() {
        // Set schema version
        // IMPORTANT:
        // - It should be executed before accessing any database instances
        // - It should be increased every time after applying new changes to DB model
        var configuration = DBAccess.factory.configuration
        configuration.schemaVersion = 0
    }
}
