//
//  AssetDownloadServiceInitializer.swift
//  Backbone
//
//  Created by Konrad Falkowski on 04/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import DLAssetDownloadService

/*
AssetDownloadService initializer class
*/
class AssetDownloadServiceInitializer {
    /**
    Initialize AssetDownload service
    */
    class func initialize() {
        let configuration = AssetDownloadServiceConfiguration.defaultConfiguration

        // Set data source to apropriate class
        AssetDownloadService.initialize(configuration: configuration, dataSource: nil)
    }
}
