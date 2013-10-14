//
//  MATPlugin.m
//
//  Copyright 2013 HasOffers Inc. All rights reserved.
//

#import "MATPlugin.h"

@implementation MATPlugin

- (void)initTracker:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: initTracker start");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 2)
    {
        [self.commandDelegate runInBackground:^{
            NSString* advid = [arguments objectAtIndex:0];
            NSString* convkey = [arguments objectAtIndex:1];

            NSLog(@"MATPlugin: initTracker: adv id = %@, conv key = %@", advid, convkey);
            
            [[MobileAppTracker sharedManager] startTrackerWithMATAdvertiserId:advid
                                                          MATConversionKey:convkey];
        }];
    }
        
//    CDVPluginResult* pluginResult = nil;
//    if (advid == nil)
//    {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//    } else {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
//    }
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

- (void)setDebugMode:(CDVInvokedUrlCommand*)command
{
	NSLog(@"MATPlugin: setDebugMode");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strEnable = [arguments objectAtIndex:0];
            BOOL enable = [strEnable boolValue];
            
            [[MobileAppTracker sharedManager] setDebugMode:enable];
        }];
    }
}

- (void)setDelegate:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setDelegate");
    
	NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strEnable = [arguments objectAtIndex:0];
            BOOL enable = [strEnable boolValue];
            
            [[MobileAppTracker sharedManager] setDelegate:enable ? self : nil];
        }];
    }
}

- (void)sdkDataParameters:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: sdkDataParameters");
    
    [self.commandDelegate runInBackground:^{
        
        NSDictionary *dictParams = [[MobileAppTracker sharedManager] sdkDataParameters];
        
        NSLog(@"MAT SDK Data Params: %@", dictParams);
        
        CDVPluginResult* pluginResult = nil;
        
        if (dictParams != nil) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictParams];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)trackInstall:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: trackInstall");
    
    NSArray* arguments = command.arguments;
    
    NSString *refId = nil;
    
    if ([NSNull null] != (id)arguments && [arguments count] == 1)
    {
        refId = [arguments objectAtIndex:0];
    }
    
    [self.commandDelegate runInBackground:^{
        [[MobileAppTracker sharedManager] trackInstallWithReferenceId:refId];
    }];
}

- (void)trackUpdate:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: trackUpdate");
    
    NSArray* arguments = command.arguments;
    
    NSString *refId = nil;
    
    if ([NSNull null] != (id)arguments && [arguments count] == 1)
    {
        refId = [arguments objectAtIndex:0];
    }
    
    [self.commandDelegate runInBackground:^{
        [[MobileAppTracker sharedManager] trackUpdateWithReferenceId:refId];
    }];
}

- (void)trackAction:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: trackAction");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 5)
    {
        [self.commandDelegate runInBackground:^{
            NSString *strEvent = [arguments objectAtIndex:0];
            
            NSNumber* strIsId = [arguments objectAtIndex:1];
            BOOL isId = [strIsId boolValue];
            
            NSString *strRefId = [arguments objectAtIndex:2];
            
            NSNumber* numRev = [arguments objectAtIndex:3];
            double revenue = [numRev doubleValue];
            
            NSString *strCurrency = [arguments objectAtIndex:4];
            
            [[MobileAppTracker sharedManager] trackActionForEventIdOrName:strEvent
                                                                eventIsId:isId
                                                              referenceId:strRefId
                                                            revenueAmount:revenue
                                                             currencyCode:strCurrency];
        }];
    }
}

- (void)trackActionWithItems:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: trackActionWithItems");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 6)
    {
        [self.commandDelegate runInBackground:^{
            NSString *strEvent = [arguments objectAtIndex:0];
            
            NSNumber* strIsId = [arguments objectAtIndex:1];
            BOOL isId = [strIsId boolValue];
            
            NSArray *arrItems = [arguments objectAtIndex:2];
            arrItems = [NSNull null] == (id)arrItems ? nil : arrItems;
            NSLog(@"MATPlugin: arrItems before = %@", arrItems);
            
            arrItems = [self convertToMATEventItems:arrItems];
            
            NSLog(@"MATPlugin: arrItems after = %@", arrItems);
            
            NSString *strRefId = [arguments objectAtIndex:3];
            
            NSNumber* numRev = [arguments objectAtIndex:4];
            double revenue = [numRev doubleValue];
            
            NSString *strCurrency = [arguments objectAtIndex:5];
            
            [[MobileAppTracker sharedManager] trackActionForEventIdOrName:strEvent
                                                                eventIsId:isId
                                                               eventItems:arrItems
                                                              referenceId:strRefId
                                                            revenueAmount:revenue
                                                             currencyCode:strCurrency];
        }];
    }
}

- (void)trackActionWithReceipt:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: trackActionWithReceipt");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 9)
    {
        [self.commandDelegate runInBackground:^{
            
            NSString *strEvent = [arguments objectAtIndex:0];
            
            NSNumber* strIsId = [arguments objectAtIndex:1];
            BOOL isId = [strIsId boolValue];
            
            NSArray *arrItems = [arguments objectAtIndex:2];
            arrItems = [NSNull null] == (id)arrItems ? nil : arrItems;
            NSLog(@"MATPlugin: arrItems before = %@", arrItems);
            
            arrItems = [self convertToMATEventItems:arrItems];
            NSLog(@"MATPlugin: arrItems after = %@", arrItems);
            
            NSString *strRefId = [arguments objectAtIndex:3];
            
            NSNumber* numRev = [arguments objectAtIndex:4];
            double revenue = [numRev doubleValue];
            
            NSString *strCurrency = [arguments objectAtIndex:5];
            
            NSNumber* numTransactionState = [arguments objectAtIndex:6];
            int transactionState = [numTransactionState intValue];
            
            NSString *strReceipt = [arguments objectAtIndex:7];
            NSData *receiptData = [strReceipt dataUsingEncoding:NSUTF8StringEncoding];
            
            [[MobileAppTracker sharedManager] trackActionForEventIdOrName:strEvent
                                                                eventIsId:isId
                                                               eventItems:arrItems
                                                              referenceId:strRefId
                                                            revenueAmount:revenue
                                                             currencyCode:strCurrency
                                                         transactionState:transactionState
                                                                  receipt:receiptData];
        }];
    }
}

- (void)setAllowDuplicates:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setAllowDuplicates");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *strEnable = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setAllowDuplicateRequests:[strEnable boolValue]];
        }];
    }
}

- (void)setPackageName:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setPackageName");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *packageName = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setPackageName:packageName];
        }];
    }
}

- (void)setSiteId:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setSiteId");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *siteId = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setSiteId:siteId];
        }];
    }
}

- (void)setCurrencyCode:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setCurrencyCode");
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *currencyCode = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setCurrencyCode:currencyCode];
        }];
    }
}

- (void)setUIID:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setUIID");
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *uiid = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setUIID:uiid];
        }];
    }
}

- (void)setMACAddress:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setMACAddress");
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *mac = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setMACAddress:mac];
        }];
    }
}

- (void)setAppleAdvertisingIdentifier:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setAppleAdvertisingIdentifier");
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *strAppleAdvId = [arguments objectAtIndex:0];
            
            id classNSUUID = NSClassFromString(@"NSUUID");
            
            if(classNSUUID)
            {
                [[MobileAppTracker sharedManager] setAppleAdvertisingIdentifier:[[classNSUUID alloc] initWithUUIDString:strAppleAdvId]];
            }
        }];
    }
}

- (void)setAppleVendorIdentifier:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setAppleVendorIdentifier");
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *strAppleVendorId = [arguments objectAtIndex:0];
            
            id classNSUUID = NSClassFromString(@"NSUUID");
            
            if(classNSUUID)
            {
                [[MobileAppTracker sharedManager] setAppleVendorIdentifier:[[classNSUUID alloc] initWithUUIDString:strAppleVendorId]];
            }
        }];
    }
}

- (void)setMATAdvertiserId:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setMATAdvertiserId");
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *advId = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setMATAdvertiserId:advId];
        }];
    }
}

- (void)setMATConversionKey:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setMATConversionKey");
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *convKey = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setMATConversionKey:convKey];
        }];
    }
}

- (void)setOpenUDID:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setOpenUDID");
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *openUDID = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setOpenUDID:openUDID];
        }];
    }
}

- (void)setODIN1:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setODIN1");
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *odin1 = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setODIN1:odin1];
        }];
    }
}

- (void)setTrusteTPID:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setTrusteTPID");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *tpid = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setTrusteTPID:tpid];
        }];
    }
}

- (void)setUserId:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setUserId");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString *userId = [arguments objectAtIndex:0];
            [[MobileAppTracker sharedManager] setUserId:userId];
        }];
    }
}

- (void)setJailbroken:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setJailbroken");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strJailbroken = [arguments objectAtIndex:0];
            BOOL jailbroken = [strJailbroken boolValue];
            
            [[MobileAppTracker sharedManager] setJailbroken:jailbroken];
        }];
    }
}

- (void)setAge:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setAge");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strAge = [arguments objectAtIndex:0];
            int age = [strAge intValue];
            
            [[MobileAppTracker sharedManager] setGender:age];
        }];
    }
}

- (void)setLocation:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setLocation");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 2)
    {
        [self.commandDelegate runInBackground:^{
            NSNumber* numLat = [arguments objectAtIndex:0];
            NSNumber* numLon = [arguments objectAtIndex:1];
            
            CGFloat lat = [numLat doubleValue];
            CGFloat lon = [numLon doubleValue];
            
            [[MobileAppTracker sharedManager] setLatitude:lat longitude:lon];
        }];
    }
}

- (void)setLocationWithAltitude:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setLocationWithAltitude");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 3)
    {
        [self.commandDelegate runInBackground:^{
            NSNumber* numLat = [arguments objectAtIndex:0];
            NSNumber* numLon = [arguments objectAtIndex:1];
            NSNumber* numAlt = [arguments objectAtIndex:2];
            
            CGFloat lat = [numLat doubleValue];
            CGFloat lon = [numLon doubleValue];
            CGFloat alt = [numAlt doubleValue];
            
            [[MobileAppTracker sharedManager] setLatitude:lat longitude:lon altitude:alt];
        }];
    }
}

- (void)setUseCookieTracking:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setUseCookieTracking");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strUseCookie = [arguments objectAtIndex:0];
            BOOL useCookie = [strUseCookie boolValue];
            
            [[MobileAppTracker sharedManager] setUseCookieTracking:useCookie];
        }];
    }
}

- (void)setShouldAutoDetectJailbroken:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setShouldAutoDetectJailbroken");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strAutoDetect = [arguments objectAtIndex:0];
            BOOL autoDetect = [strAutoDetect boolValue];
            
            [[MobileAppTracker sharedManager] setShouldAutoDetectJailbroken:autoDetect];
        }];
    }
}

- (void)setShouldAutoGenerateAppleAdvertisingIdentifier:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setShouldAutoGenerateAppleAdvertisingIdentifier");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strAutoGen = [arguments objectAtIndex:0];
            BOOL autoGen = [strAutoGen boolValue];
            
            [[MobileAppTracker sharedManager] setShouldAutoGenerateAppleAdvertisingIdentifier:autoGen];
        }];
    }
}

- (void)setShouldAutoGenerateAppleVendorIdentifier:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setShouldAutoGenerateAppleVendorIdentifier");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strAutoGen = [arguments objectAtIndex:0];
            BOOL autoGen = [strAutoGen boolValue];
            
            [[MobileAppTracker sharedManager] setShouldAutoGenerateAppleVendorIdentifier:autoGen];
        }];
    }
}

- (void)setAppAdTracking:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setAppAdTracking");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strEnable = [arguments objectAtIndex:0];
            BOOL enable = [strEnable boolValue];
            
            [[MobileAppTracker sharedManager] setAppAdTracking:enable];
        }];
    }
}

- (void)setGender:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setGender");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strGender = [arguments objectAtIndex:0];
            int gender = [strGender intValue];
            
            [[MobileAppTracker sharedManager] setGender:gender];
        }];
    }
}

- (void)applicationDidOpenURL:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: applicationDidOpenURL");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 2)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strURL = [arguments objectAtIndex:0];
            NSString* strSource = [arguments objectAtIndex:1];
            
            [[MobileAppTracker sharedManager] applicationDidOpenURL:strURL sourceApplication:strSource];
        }];
    }
}

- (void)setTracking:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setTracking");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 5)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strTargetAppPackageName = [arguments objectAtIndex:0];
            NSString* strTargetAdvId = [arguments objectAtIndex:1];
            NSString* strTargetOfferId = [arguments objectAtIndex:2];
            NSString* strTargetPublisherId = [arguments objectAtIndex:3];
            NSString* strShouldRedirect = [arguments objectAtIndex:4];
            BOOL shouldRedirect = [strShouldRedirect boolValue];
            
            [[MobileAppTracker sharedManager] setTracking:strTargetAppPackageName
                                             advertiserId:strTargetAdvId
                                                  offerId:strTargetOfferId
                                              publisherId:strTargetPublisherId
                                                 redirect:shouldRedirect];
        }];
    }
}

- (void)setRedirectUrl:(CDVInvokedUrlCommand*)command
{
    NSLog(@"MATPlugin: setRedirectUrl");
    
    NSArray* arguments = command.arguments;
    
    if ([arguments count] == 1)
    {
        [self.commandDelegate runInBackground:^{
            NSString* strURL = [arguments objectAtIndex:0];
            
            [[MobileAppTracker sharedManager] setRedirectUrl:strURL];
        }];
    }
}



- (NSArray *)convertToMATEventItems:(NSArray *)arrDictionaries
{
    NSMutableArray *arrItems = [NSMutableArray array];
    
    for (NSDictionary *dict in arrDictionaries) {
        
        NSString *name = [dict valueForKey:@"item"];
        NSString *strUnitPrice = [dict valueForKey:@"unit_price"];
        float unitPrice = [NSNull null] == (id)strUnitPrice ? 0 : [strUnitPrice floatValue];
        
        NSString *strQuantity = [dict valueForKey:@"quantity"];
        int quantity = [NSNull null] == (id)strQuantity ? 0 : [strQuantity intValue];
        
        NSString *strRevenue = [dict valueForKey:@"revenue"];
        float revenue = [NSNull null] == (id)strRevenue ? 0 : [strRevenue floatValue];
        
        NSString *attribute1 = [dict valueForKey:@"attribute1"];
        NSString *attribute2 = [dict valueForKey:@"attribute2"];
        NSString *attribute3 = [dict valueForKey:@"attribute3"];
        NSString *attribute4 = [dict valueForKey:@"attribute4"];
        NSString *attribute5 = [dict valueForKey:@"attribute5"];
        
        MATEventItem *item = [MATEventItem eventItemWithName:name
                                                   unitPrice:unitPrice
                                                    quantity:quantity
                                                     revenue:revenue
                                                  attribute1:attribute1
                                                  attribute2:attribute2
                                                  attribute3:attribute3
                                                  attribute4:attribute4
                                                  attribute5:attribute5];
        
        [arrItems addObject:item];
    }
    
    return arrItems;
}

#pragma mark - MobileAppTrackerDelegate Methods

- (void)mobileAppTracker:(MobileAppTracker *)tracker didSucceedWithData:(id)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"MATPlugin.matDelegate.success: %@", str);
}

- (void)mobileAppTracker:(MobileAppTracker *)tracker didFailWithError:(NSError *)error
{
    NSLog(@"MATPlugin.matDelegate.failure: %@", error);
}

@end