# DLPrivacy

Module for gathering user consents for tools used across all company applications (Onet S.A.)

## Installation

> Module has one dependency: 'CocoaLumberjack/Swift', '~> 3.3.0' - logger tool which you can initialize however you want or don't do it at all

DLPrivacy module can be installed in two ways:

**1) Manually**

Adding soure files contained inside 'Pod' directory to your project. This approach may require, from Swift applications, bridging header with  ```DLPrivacy.h``` import.

**2) Using Cocoapods**

This is the recommended way of installing this module. 

In your Podfile add: ```pod 'DLPrivacy'``` and execute ```pod install``` or ```pod update``` command.

>  Because module Podspec defines it as static framework - Cocoapods in version 1.5.x are required (as module contains both Swift and Obj-C files)

Then in code simply import module:
```
import DLPrivacy
```

## Usage (Basic)

> Example below is written using Swift code snippets

Module have four points of interests:

- *Privacy* class which is entry point for contact with module
- *PrivacyFormView* class which is a view returned by the module for the application. This is where all user interactions is happening
- *PrivacyDelegate* delegate which is responsible for passing information about user choices and consents form changes
- *AppSDK* enum which contains predefined SDK for which user can give his consent

Start by initializing module:
```
Privacy.shared.initialize(withThemeColor: UIColor, buttonTextColor: UIColor, font: UIFont, appBrandingSite: String? = nil, delegate: PrivacyDelegate)
```

Parameter "appBrandingSite" is optional - you can pass your application site id to have CMP form branded.

> Module is defined as singleton so strong reference to it should not be needed

Then you can use method ```Privacy.shared.didAskUserForConsents``` to check if consents form should be shown immediately at application start. 
If this returns true, you should then show consents for to the user iimmediately. To do so:

Retrieve consents form view from module:
```
let privacyView = Privacy.shared.getPrivacyConsentsView()
```

Then add it to your application view hierarchy however you like and call: ```privacyView.showConsentsWelcomeScreen()``` to show initial consents form screen, explaining to the user what this is.
At this time (if all goes well) user will perform his interactions with the form and close it. Your application will be informed of that fact and user consents by delegate method:
```
func privacyModule(_ module: Privacy, shouldHideConsentsForm form: PrivacyFormView, andApplyConsents consents: [AppSDK: Bool])
```

At this point you should remove form view from you application views hierarchy and apply changes to your SDK used in app (turn on only those for which user gave his consent).

If something would have changed in consents form, you are obligated to show it again to the user. You know when to do that when your *PrivacyDelegate* object receives call to the method:
```
func privacyModule(_ module: Privacy, shouldShowConsentsForm form: PrivacyFormView)
```

If you want to show consents form again (for example when user select this from your application menu option) you just have to add form view to hierarchy and call ```privacyView.showConsentsWelcomeScreen()``` 

> IMPORTANT
> When user is asked again for consents (after he save his choice once) view will show him afterwards screen with information that changes will be applied when app is restarted. Then when user goes to  background, *DLPrivacy* module will kill your application (while it's in background) so changes to privacy can be applied when user goes back to your app.

## Usage (Advanced)

> Example below is written using Swift code snippets

### Skipping welcome screen

If you would like to skip initial consents form screen (welcome screen explaining what is going on) and go directly to settings screen - you can do that by calling meethod ```showConsentsSettingsScreen()``` on *PrivacyFormView* object (instead of calling ```showConsentsWelcomeScreen()``` method).

### Get saved user consents

If you would like to get user consents (without showing him the form view) you can get last saved user choices by calling method:
```
let sdkInMyApp: [AppSDK] = [.GoogleAnalytics, .Gemius]
_ = Privacy.shared.getSDKConsents(sdkInMyApp)
```
where *sdkInMyApp* is an array of SDK you would like to enable in your app (only those predefined ones).

### Check if application can show personalized ads

To check if application can show personalized ads (either rectangle/native ads or video ads) use property on *Privacy* module:
```
let canAdsBePersonalized = Privacy.shared.canShowPersonalizedAds
DDLogInfo("Personalized Ads: \(canAdsBePersonalized)")
```

### Check if application can raport analytics to internal systems like Kropka or MediaStats
To check if application can can raport analytics to internal systems use property on *Privacy* module:
```
let internalAnalyticsEnabled = Privacy.shared.internalAnalyticsEnabled
DDLogInfo("Internal analytics enabled: \(internalAnalyticsEnabled)")
```

### Retrieve ad identifiers used by *DLSponsoring* and *DLSplash* modules or other entities

Get identifiers required by those modules. Returns PrivacyConsentsData class with available consents data.
```
let consents: PrivacyConsentsData = Privacy.shared.consentsData
DDLogInfo("Consents data: \(consents.adpConsent) \(consents.pubConsent) \(consents.venConsent)")
```

### Retrieve consent for SDK not defined in module

> If something is not defined in module, please contact us and we can just add it so you don't have to use this method

If your application is using SDK not predefined inside *DLPrivacy* module you can still retrieve user consent for it. To do so you have to know vendor name for under which this SDK should fall and also 
what purposes you want consent for.

Start by defining you SDK:
```
let mySDK = AppSDK(rawValue: "mySDKName")
```

Then ask for consent:
```
Privacy.shared.getCustomSDKConsent(mySDK, vendorName: "myVendor", purposeId: [.measurement]) { consent in
    DDLogInfo("Consent for my custom SDK: \(consent)")
}
```

## Usage in Application - How to do that? What and when?

In your application - after application update with this module - you should start initializing this module as early as possible. Your responsibility is to show consents form at first app launch after update.
To do so check for flag  ```Privacy.shared.didAskUserForConsents```, to determine if user already saw this form. If this is false (user did not saw the form) you should show it to him on the full screen. Get view instance using ```Privacy.shared.getPrivacyConsentsView()``` method and then request consents form by calling ```showConsentsWelcomeScreen()``` method on view instance.

Next steps would be to apply user consents to SDK's in your app after form is dismissed (you will know that from delegate method).

On the next app launches you can ask *Privacy* module for cached user consents and apply it during your normal app launch. You can fetch those consents using method: ```Privacy.shared.getSDKConsents(...)```.

User must have the possibility to change his given consents at any time - there should be option somewhere in you app (for example in side menu if applicable) to show again consents form. Then after user made his choices *Privacy* module will show him information that changes will be applied on next app launch. You don't have to worry about that (module takes care of that and should kill your app when it's goes to background so next app launch will be performed with new user consents).

To show again consents form simply grab a view from *Privacy* module -  ```Privacy.shared.getPrivacyConsentsView()``` , add it to your view hierarchy and call either  ```showConsentsWelcomeScreen()``` or ```showConsentsSettingsScreen()```.

In addition to those requirements - there is one more - you should always respond to delegate methods that something has change in vendors list and you should show consents form again to the user (this is ```func privacyModule(_ module: Privacy, shouldShowConsentsForm form: PrivacyFormView)``` method)

Getting user consents using *Privacy* module methods, like ```Privacy.shared.getSDKConsents(...)```,  ```Privacy.shared.canShowPersonalizedAds ``` or  ```Privacy.shared.consentsData``` should be done only after user submitted consents form for at least once (which is equal to ```Privacy.shared.didAskUserForConsents``` flag being set to true).

If you have any questions - feel free to contact us.

## Demo application

Example usage, together with comments what you can do with module is located in *Example/DLPrivacy/ViewController.swift*

## Author

Adam Szeremeta, adam.szeremeta@dreamlab.pl

## License

For internal use only
