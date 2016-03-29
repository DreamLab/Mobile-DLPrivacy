//
//  DBFactoryProtocol.swift
//  Backbone
//
//  Created by Konrad Falkowski on 18/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import Foundation
import DLRealmHelpers

/**
Factory for creating database objects
*/
protocol DBFactoryProtocol {

    /// Database configuration
    var configuration: DBConfigurationProtocol {get}

    /// Database transaction manager
    var transactionManager: TransactionManagerProtocol {get}
}
