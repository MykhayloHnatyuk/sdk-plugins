# MobileAppTracker Module

## Description

Lets you use the MobileAppTracking SDK for Titanium to track app installs and events for attribution.

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

The Android module zip is located at `mobile/android/dist`.

The iOS module zip is located at `mobile/ios`.

## Accessing the MobileAppTracker Module

To access this module from JavaScript, you would do the following:

    var mobileapptracker = require("ti.mobileapptracker");

The mobileapptracker variable is a reference to the Module object.

## Usage

For a complete example of usage, see the implementation in the `/TestMAT/Resources/app.js` file.

First initialize the MAT tracker with the `initTracker` function, passing in your MAT advertiser ID and key:

    mobileapptracker.initTracker("YOUR_ADVERTISER_ID","YOUR_ADVERTISER_KEY");


### Installs and Updates

As the success of attributing app events after the initial install is dependent upon first tracking that install, 
we require that the install is the first event tracked. To track install of your mobile app, use the “trackInstall” 
method. If users have already installed your app prior to SDK implementation, then these users should be tracked as updates.

#### Track Installs

To track installs of your mobile app, use the Track Install method. Track Install is used to track when users install your 
mobile app on their device and will only record one conversion per install in reports.

    mobileapptracker.trackInstall();

The “trackInstall” method automatically tracks updates of your app if the app version differs from the last app version it saw.

#### Handling Installs Prior to SDK Implementation - Track as Updates

What if your app already has thousands or millions of users prior to SDK implementation? What happens when these users update 
the app to the new version that contains the MAT SDK?

MAT provides you two ways to make sure that the existing users do not count towards new app installs.

1. Call SDK method "trackUpdate" instead of "trackInstall".

    If you are integrating MAT into an existing app where you have users you’ve seen before, you can track an update yourself with the trackUpdate method.

        mobileapptracker.trackUpdate();

2. Import prior installs to the platform.

These methods are useful if you already have an app in the store and plan to add the MAT SDK in a new version. 
Learn how to [handle installs prior to SDK implementation here](http://support.mobileapptracking.com/entries/22621001-Handling-Installs-prior-to-SDK-implementation).

If the code used to differentiate installs versus app updates is not properly implemented, then you will notice 
a [spike of total installs](http://support.mobileapptracking.com/entries/22900598-Spike-of-Total-Installs-on-First-day-of-SDK) on the first day of the SDK implementation.


### Events

After the install has been tracked, the “trackAction” method is intended to be used to track user actions such as reaching a 
certain level in a game or making an in-app purchase. The “trackAction” method allows you to define the event name dynamically.

    trackAction(String eventIdOrName, boolean isId, String refId, double revenue, String currency)

where

    eventIdOrName = name or event ID of event to track
    isId = whether eventName is passing event name or event ID # from MAT
    referenceId = advertiser ref ID to associate with event
    revenue = revenue amount to associate with event as double
    currency = ISO 4217 currency code of revenue

You need to supply the "eventIdOrName" field with the appropriate value for the event; e.g. "registration". If the event does
not exist, it will be dynamically created in our site and incremented. You may pass a revenue value, currency code,
or whether you are using an event ID or event name, as optional fields.


#### Registration

If you have a registration process, it's recommended to track it by calling trackAction set to “registration”.
Using the aforementioned import code, you would call the following:

    mobileapptracker.trackAction("registration", false, "some_username". 0, “USD”);

You can find these events in the platform by viewing Reports > Event Logs. Then filter the report by the “registration” event.

While our platform always blocks the tracking of duplicate installs, by default it does not block duplicate event requests. 
However, a registration event may be an event that you only want tracked once per device/user. 
Please see [block duplicate requests setting for events](http://support.mobileapptracking.com/entries/22927312-Block-Duplicate-Request-Setting-for-Events) for further information.


#### Purchases

The best way to analyze the value of your publishers and marketing campaigns is to track revenue from in-app purchases.
By tracking in-app purchases for a user, the data can be correlated back to the install and analyzed on a cohort basis 
to determine revenue per install and lifetime value.

Using the aforementioned import code, you would call the following:

    mobileapptracker.trackAction("purchase", false, "", 0.99, “USD”);

__Track In-App Purchases__
The basic way to track purchases is to track an event with a name of purchase and then define the revenue (sale amount) and currency code.

Note: Pass the revenue in as a Double and the currency of the amount if necessary.  Currency is set to "USD" by default.
See [Setting Currency Code](http://support.mobileapptracking.com/entries/23697946-Customize-SDK-Settings) for currencies we support.

You can find these events in platform by viewing Reports > Logs > Events. Then filter the report by the “purchase” event.

#### Opens

The SDK allows you to analyze user engagement by tracking unique opens. The SDK has built in functionality to only track one “open” event
per user on any given day to minimize footprint. All subsequent “open” events fired on the same day are ignored and will not show up on the platform.

Using the aforementioned import code, you would call the following:

    mobileapptracker.trackAction("open", false, "", 0, “USD”);

You can find counts of Opens by viewing Reports > Mobile Apps. Include the parameter of Opens to see the aggregated count.
The platform does not provide logs of Opens. If you track Opens using a name other than "open" then these tracked events will
cost the same price as all other events to track.

#### Other Events

You can track other events in your app dynamically by calling “trackAction”. The “trackAction” method is intended for tracking
any user actions. This method allows you to define the event name.

To dynamically track an event, replace “eventIdOrName” with the name of the event you want to track. The tracking engine
will then look up the event by the name. If an event with the defined name doesn’t exist, the tracking engine will automatically
create an event for you with that name. An Event Name has to be alphanumeric.

You can find these events in platform by viewing Reports->Logs->Event Logs.

The max event limit per site is 100. Learn more about the [max limit of events](http://support.mobileapptracking.com/entries/22803093-Max-Event-Limit-per-Site).

While our platform always blocks the tracking of duplicate installs, by default it does not block duplicate event requests. 
However, there may be other types of events that you only want tracked once per device/user. Please see [block duplicate requests setting for events](http://support.mobileapptracking.com/entries/22927312-Block-Duplicate-Request-Setting-for-Events) for further information.


### Testing Plugin Integration with SDK

These pages contain instructions on how to test whether the SDKs were successfully implemented for the various platforms:

[Testing Android SDK Integration](http://support.mobileapptracking.com/entries/22541781-Testing-Android-SDK-integration)

[Testing iOS SDK Integration](http://support.mobileapptracking.com/entries/22561876-testing-ios-sdk-integration)


### Debug Mode and Duplicates

__Debugging__

When the Debug mode is enabled in the SDK, the server responds with debug information about the success or failure of the
tracking requests.

__Note__: For Android, debug mode log output can be found in LogCat under the tag "MobileAppTracker".

To debug log messages that show the event status and server response, call the "setDebugMode" method with Boolean true:

    mobileapptracker.setDebugMode(true);

__Allow Duplicates__

The platform rejects installs from devices it has seen before.  For testing purposes, you may want to bypass this behavior
and fire multiple installs from the same testing device.
 
There are two methods you can employ to do so: (1) calling the "setAllowDuplicates" method, and (2) set up a test profile.

(1) Call the “setAllowDuplicates” after initializing MobileAppTracker, with Boolean true:

    mobileapptracker.setAllowDuplicates(true);

(2) Set up a [test profile](http://support.mobileapptracking.com/entries/22541401-Test-Profiles). A Test Profile should be 
used when you want to allow duplicate installs and/or events from a device you are using from testing and don't want to 
implement setAllowDuplicateRequests in the code and instead allow duplicate requests from the platform.


**_The setDebugMode and setAllowDuplicates calls are meant for use only during debugging and testing. Please be sure to disable these for release builds._**

### Additional Resources

#### Custom Settings

The SDK supports several custom identifiers that you can use as alternate means to identify your installs or events.
Call these setters before calling the corresponding trackInstall or trackAction code.

__OpenUDID__ (iOS only)

This sets the OpenUDID of the device. Can be generated with the official implementation at [http://OpenUDID.org](http://OpenUDID.org).
Calling this will do nothing on Android apps.

    mobileapptracker.setOpenUDID("your_open_udid");

__TRUSTe ID__

If you are integrating with the TRUSTe SDK, you can pass in your TRUSTe ID with setTRUSTeId, which populates the “TPID” field.

    mobileapptracker.setTrusteTPID("your_truste_id");

__User ID__

If you have a user ID of your own that you wish to track, pass it in as a string with setUserId. This populates the “User ID”
field in our reporting, and also the postback variable {user_id}.

    mobileapptracker.setUserId("custom_user_id");

The SDK supports several custom identifiers that you can use as alternate means to identify your installs or events.
Please navigate to the [Custom SDK Settings](http://support.mobileapptracking.com/entries/23738686-Customize-SDK-Settings) page for more information.


#### Event Items

While an event is like your receipt for a purchase, the event items are the individual items you purchased.
Event items allow you to define multiple items for a single event. The “trackAction” method can include this event item data.

The function for tracking event items looks like this:

    trackActionWithItems(eventName, isId, items, referenceId, revenue, currency)

items is an array of "event items" that have the following format:

    {"item":"item_name",    // name of the item
     "quantity":1,          // # of items
     "unit_price":0.99,     // individual unit price
     "revenue":0.99,        // total revenue of event item, defaults to quantity x unit price
     "attribute_sub1":"1",  // attribute1 for your use (optional)
     "attribute_sub2":"2",  // attribute2 for your use (optional)
     "attribute_sub3":"3",  // attribute3 for your use (optional)
     "attribute_sub4":"4",  // attribute4 for your use (optional)
     "attribute_sub5":"5"   // attribute5 for your use (optional)
    }

Sample tracking code:

    var eventItems = new Array();

    var eventItem1 = {"item":"apple",
                      "quantity":1,
                      "unit_price":0.99,
                      "revenue":0.99,
                      "attribute_sub1":"1",
                      "attribute_sub2":"2",
                      "attribute_sub3":"3",
                      "attribute_sub4":"4",
                      "attribute_sub5":"5"
    };
    eventItems[0] = eventItem1;
    
    var eventItem2 = {"item":"banana",
                      "quantity":2,
                      "unit_price":0.50,
                      "revenue":1
    };
    eventItems[1] = eventItem2;

    mat.trackActionWithItems("purchase",
                             false,
                             eventItems,
                             "ref1",
                             0.99,
                             "USD");

## Author

John Gu, Harshal Ogale

## License

Copyright (c) 2013 HasOffers. Please see the LICENSE file included in the distribution for further details.