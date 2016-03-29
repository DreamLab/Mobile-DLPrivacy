//
//  DBAccess.swift
//  Backbone
//
//  Created by Konrad Falkowski on 18/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import Foundation
import DLRealmHelpers

/**
Class for application access to DB
*/
class DBAccess {

    /// Factory for creating database objects
    static var factory: DBFactoryProtocol = RealmFactory()

    /// Property for managing schema version
    static var configuration: DBConfigurationProtocol {
        return factory.configuration
    }

    /// Database transaction manager
    static var transactionManager: TransactionManagerProtocol {
        return factory.transactionManager
    }
}
