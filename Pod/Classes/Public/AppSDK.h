//
//  AppSDK.h
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *AppSDK NS_EXTENSIBLE_STRING_ENUM;

/// Google Analytics
extern AppSDK const GoogleAnalytics;

/// Fabric (Crashylytics & Answers)
extern AppSDK const Fabric;

/// Instabug
extern AppSDK const Instabug;

/// Branch.io
extern AppSDK const Branch;

/// Pushwoosh
extern AppSDK const Pushwoosh;

/// Firebase (Analytics & Remote Config)
extern AppSDK const Firebase;

/// Gemius
extern AppSDK const Gemius;

/// Bitplaces SDK
extern AppSDK const Bitplaces;
