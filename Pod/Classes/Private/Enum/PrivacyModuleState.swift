//
//  PrivacyModuleState.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 10.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

/// Enum representing module state in context of CMP website in WKWebView
///
/// - initialized: Module was initialized but did not start loading cmp site yet
/// - cmpLoading: CMP site is loading
/// - cmpLoaded: CMP site is loaded and can accept actions
/// - cmpError: CMP site loading failed
enum PrivacyModuleState {

    case initialized
    case cmpLoading
    case cmpLoaded
    case cmpError
}
