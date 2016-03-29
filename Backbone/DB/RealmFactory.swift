//
//  RealmFactory.swift
//  Backbone
//
//  Created by Konrad Falkowski on 18/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import Foundation
import DLRealmHelpers

/**
Factory for creating Realm objects
*/
class RealmFactory: DBFactoryProtocol {

    /// Realm configuration
    var configuration: DBConfigurationProtocol = RealmConfiguration()

    /// Realm transaction manager
    var transactionManager: TransactionManagerProtocol {
        return RealmTransactionManager.sharedInstance
    }
}
