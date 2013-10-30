/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiMobileapptrackerModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiMobileapptrackerModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"f3c233bb-5f94-40d2-93a7-2ae3b77f8d9b";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.mobileapptracker";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

//- (void)testMethodWithParam1:(NSString *)param1 andParam2:(NSString *)param2
//{
//    NSLog(@"[INFO] testMethodWithParam1:andParam2: %@, %@", param1, param2);
//}

- (void)initTracker:(id)args
{
    //NSArray *arr = [args objectAtIndex:0];
    NSArray *arr = args;
    NSLog(@"[INFO] initTracker: arr  = %@", arr);
    
    NSString *aid = [arr objectAtIndex:0];
    NSString *key = [arr objectAtIndex:1];
    
    [[MobileAppTracker sharedManager] startTrackerWithMATAdvertiserId:aid MATConversionKey:key];
}

- (void)setPackageName:(id)packageName
{
    [[MobileAppTracker sharedManager] setPackageName:packageName];
}

- (void)setDebugMode:(id)enable
{
    [[MobileAppTracker sharedManager] setDebugMode:[TiUtils boolValue:enable]];
}

- (void)setAllowDuplicates:(id)enable
{
    [[MobileAppTracker sharedManager] setAllowDuplicateRequests:[TiUtils boolValue:enable]];
}

- (void)setDelegate:(id)enable
{
    id<MobileAppTrackerDelegate> dele = [TiUtils boolValue:enable] ? self : nil;
    
    [[MobileAppTracker sharedManager] setDelegate:dele];
}

- (void)printSDKDataParameters:(id)args
{
    NSLog(@"[INFO] sdkDataParameters:\n%@", [[MobileAppTracker sharedManager] sdkDataParameters]);
}

- (void)trackInstall:(id)dummy
{
    [[MobileAppTracker sharedManager] trackInstall];
}

- (void)trackUpdate:(id)dummy
{
    [[MobileAppTracker sharedManager] trackUpdate];
}

- (void)trackInstallWithReferenceId:(id)referenceId
{
    [[MobileAppTracker sharedManager] trackInstallWithReferenceId:referenceId];
}

- (void)trackUpdateWithReferenceId:(id)referenceId
{
    [[MobileAppTracker sharedManager] trackUpdateWithReferenceId:referenceId];
}

- (void)trackAction:(id)args
{
    NSLog(@"[INFO] trackAction:")
    
    //NSArray *arr = [args objectAtIndex:0];
    NSArray *arr = args;
    
    if (arr && [arr count] == 5)
    {
        NSString *strEvent = [arr objectAtIndex:0];
        
        NSNumber* strIsId = [arr objectAtIndex:1];
        BOOL isId = [strIsId boolValue];
        
        NSString *strRefId = [arr objectAtIndex:2];
        
        NSNumber* numRev = [arr objectAtIndex:3];
        double revenue = [numRev doubleValue];
        
        NSString *strCurrency = [arr objectAtIndex:4];
        
        [[MobileAppTracker sharedManager] trackActionForEventIdOrName:strEvent
                                                            eventIsId:isId
                                                          referenceId:strRefId
                                                        revenueAmount:revenue
                                                         currencyCode:strCurrency];
    }
}

- (void)trackActionWithItems:(id)args
{
    //NSArray *arr = [args objectAtIndex:0];
    NSArray *arr = args;
    
    if (arr && [arr count] == 6)
    {
        NSString *strEvent = [arr objectAtIndex:0];
        
        NSNumber* strIsId = [arr objectAtIndex:1];
        BOOL isId = [strIsId boolValue];
        
        NSArray *arrItems = [arr objectAtIndex:2];
        arrItems = [NSNull null] == (id)arrItems ? nil : arrItems;
        NSLog(@"[INFO] TIMATModule: arrItems before = %@", arrItems);
        
        arrItems = [self convertToMATEventItems:arrItems];
        
        NSLog(@"[INFO] TIMATModule: arrItems after = %@", arrItems);
        
        NSString *strRefId = [arr objectAtIndex:3];
        
        NSNumber* numRev = [arr objectAtIndex:4];
        double revenue = [numRev doubleValue];
        
        NSString *strCurrency = [arr objectAtIndex:5];
        
        [[MobileAppTracker sharedManager] trackActionForEventIdOrName:strEvent
                                                            eventIsId:isId
                                                           eventItems:arrItems
                                                          referenceId:strRefId
                                                        revenueAmount:revenue
                                                         currencyCode:strCurrency];
    }
}

- (void)trackActionWithReceipt:(id)args
{
    //NSArray *arr = [args objectAtIndex:0];
    NSArray *arr = args;
    
    if (arr && [arr count] == 9)
    {
        NSString *strEvent = [arr objectAtIndex:0];
        
        NSNumber* strIsId = [arr objectAtIndex:1];
        BOOL isId = [strIsId boolValue];
        
        NSArray *arrItems = [arr objectAtIndex:2];
        arrItems = [NSNull null] == (id)arrItems ? nil : arrItems;
        NSLog(@"[INFO] TIMATModule: arrItems before = %@", arrItems);
        
        arrItems = [self convertToMATEventItems:arrItems];
        NSLog(@"[INFO] TIMATModule: arrItems after = %@", arrItems);
        
        NSLog(@"[INFO] TIMATModule: arrItems after = ");
        
        NSString *strRefId = [arr objectAtIndex:3];
        
        NSNumber* numRev = [arr objectAtIndex:4];
        double revenue = [numRev doubleValue];
        
        NSString *strCurrency = [arr objectAtIndex:5];
        
        NSNumber* numTransactionState = [arr objectAtIndex:6];
        int transactionState = [numTransactionState intValue];
        
        NSString *strReceipt = [arr objectAtIndex:7];
        NSData *receiptData = [strReceipt dataUsingEncoding:NSUTF8StringEncoding];
        
        // receiptSignature -- only for Android, ignore on iPhone
        
        [[MobileAppTracker sharedManager] trackActionForEventIdOrName:strEvent
                                                            eventIsId:isId
                                                           eventItems:arrItems
                                                          referenceId:strRefId
                                                        revenueAmount:revenue
                                                         currencyCode:strCurrency
                                                     transactionState:transactionState
                                                              receipt:receiptData];
    }
}

#pragma mark - Other Setter Methods

- (void)setSiteId:(id)siteId
{
    NSLog(@"[INFO] TIMATModule: setSiteId");
    [[MobileAppTracker sharedManager] setSiteId:siteId];
}

- (void)setCurrencyCode:(id)currencyCode
{
    NSLog(@"[INFO] TIMATModule: setCurrencyCode");
    [[MobileAppTracker sharedManager] setCurrencyCode:currencyCode];
}

- (void)setUIID:(id)uiid
{
    NSLog(@"[INFO] TIMATModule: setUIID");
    [[MobileAppTracker sharedManager] setUIID:uiid];
}

- (void)setMACAddress:(id)mac
{
    NSLog(@"[INFO] TIMATModule: setMACAddress");
    [[MobileAppTracker sharedManager] setMACAddress:mac];
}

- (void)setAppleAdvertisingIdentifier:(id)advId
{
    NSLog(@"[INFO] TIMATModule: setAppleAdvertisingIdentifier");
    NSString *strAppleAdvId = advId;
    
    id classNSUUID = NSClassFromString(@"NSUUID");
    
    if(classNSUUID)
    {
        [[MobileAppTracker sharedManager] setAppleAdvertisingIdentifier:[[classNSUUID alloc] initWithUUIDString:strAppleAdvId]];
    }
}

- (void)setAppleVendorIdentifier:(id)vendorId
{
    NSLog(@"[INFO] TIMATModule: setAppleVendorIdentifier");
    NSString *strAppleVendorId = vendorId;
            
    id classNSUUID = NSClassFromString(@"NSUUID");
    
    if(classNSUUID)
    {
        [[MobileAppTracker sharedManager] setAppleVendorIdentifier:[[classNSUUID alloc] initWithUUIDString:strAppleVendorId]];
    }
}

- (void)setMATAdvertiserId:(id)advId
{
    NSLog(@"[INFO] TIMATModule: setMATAdvertiserId");
    [[MobileAppTracker sharedManager] setMATAdvertiserId:advId];
}

- (void)setMATConversionKey:(id)convKey
{
    NSLog(@"[INFO] TIMATModule: setMATConversionKey");
    [[MobileAppTracker sharedManager] setMATConversionKey:convKey];
}

- (void)setOpenUDID:(id)openUDID
{
    NSLog(@"[INFO] TIMATModule: setOpenUDID");
    [[MobileAppTracker sharedManager] setOpenUDID:openUDID];
}

- (void)setODIN1:(id)odin1
{
    NSLog(@"[INFO] TIMATModule: setODIN1");
    [[MobileAppTracker sharedManager] setODIN1:odin1];
}

- (void)setTrusteTPID:(id)tpid
{
    NSLog(@"[INFO] TIMATModule: setTrusteTPID");
    [[MobileAppTracker sharedManager] setTrusteTPID:tpid];
}

- (void)setUserId:(id)userId
{
    NSLog(@"[INFO] TIMATModule: setUserId");
    [[MobileAppTracker sharedManager] setUserId:userId];
}

- (void)setJailbroken:(id)jailBroken
{
    NSLog(@"[INFO] TIMATModule: setJailbroken");
    [[MobileAppTracker sharedManager] setJailbroken:[TiUtils boolValue:jailBroken]];
}

- (void)setAge:(id)age
{
    NSLog(@"[INFO] TIMATModule: setAge");
    [[MobileAppTracker sharedManager] setAge:[age intValue]];
}

- (void)setLocation:(id)args
{
    NSLog(@"[INFO] TIMATModule: setLocation");
    
    NSArray* arguments= args;
    
    if ([arguments count] == 2)
    {
        NSNumber* numLat = [arguments objectAtIndex:0];
        NSNumber* numLon = [arguments objectAtIndex:1];
        
        CGFloat lat = [numLat doubleValue];
        CGFloat lon = [numLon doubleValue];
        
        [[MobileAppTracker sharedManager] setLatitude:lat longitude:lon];
    }
}

- (void)setLocationWithAltitude:(id)args
{
    NSLog(@"[INFO] TIMATModule: setLocationWithAltitude");
    
    NSArray* arguments= args;
    
    if ([arguments count] == 3)
    {
        NSNumber* numLat = [arguments objectAtIndex:0];
        NSNumber* numLon = [arguments objectAtIndex:1];
        NSNumber* numAlt = [arguments objectAtIndex:2];
        
        CGFloat lat = [numLat doubleValue];
        CGFloat lon = [numLon doubleValue];
        CGFloat alt = [numAlt doubleValue];
        
        [[MobileAppTracker sharedManager] setLatitude:lat longitude:lon altitude:alt];
    }
}

- (void)setUseCookieTracking:(id)enable
{
    NSLog(@"[INFO] TIMATModule: setUseCookieTracking");
    [[MobileAppTracker sharedManager] setUseCookieTracking:[TiUtils boolValue:enable]];
}

- (void)setShouldAutoDetectJailbroken:(id)autoDetect
{
    NSLog(@"[INFO] TIMATModule: setShouldAutoDetectJailbroken");
    
    [[MobileAppTracker sharedManager] setShouldAutoDetectJailbroken:[TiUtils boolValue:autoDetect]];
}

- (void)setShouldAutoGenerateAppleAdvertisingIdentifier:(id)autoGen
{
    NSLog(@"[INFO] TIMATModule: setShouldAutoGenerateAppleAdvertisingIdentifier");
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateAppleAdvertisingIdentifier:[TiUtils boolValue:autoGen]];
}

- (void)setShouldAutoGenerateAppleVendorIdentifier:(id)autoGen
{
    NSLog(@"[INFO] TIMATModule: setShouldAutoGenerateAppleVendorIdentifier");
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateAppleVendorIdentifier:[TiUtils boolValue:autoGen]];
}

- (void)setAppAdTracking:(id)enable
{
    NSLog(@"[INFO] TIMATModule: setAppAdTracking");
    
    [[MobileAppTracker sharedManager] setAppAdTracking:[TiUtils boolValue:enable]];
}

- (void)setGender:(id)gender
{
    NSLog(@"[INFO] TIMATModule: setGender");
    
    [[MobileAppTracker sharedManager] setGender:[TiUtils intValue:gender]];
}

- (void)applicationDidOpenURL:(id)args
{
    NSLog(@"[INFO] TIMATModule: applicationDidOpenURL");
    
    NSArray* arguments = args;
    
    if ([arguments count] == 2)
    {
        NSString* strURL = [arguments objectAtIndex:0];
        NSString* strSource = [arguments objectAtIndex:1];
        
        [[MobileAppTracker sharedManager] applicationDidOpenURL:strURL sourceApplication:strSource];
    }
}

- (void)setTracking:(id)args
{
    NSLog(@"[INFO] TIMATModule: setTracking");
    
    NSArray* arguments = args;
    
    if ([arguments count] == 5)
    {
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
    }
}

- (void)setRedirectUrl:(id)strURL
{
    NSLog(@"[INFO] TIMATModule: setRedirectUrl");
    
    [[MobileAppTracker sharedManager] setRedirectUrl:strURL];
}

#pragma mark - Helper Methods

- (NSArray *)convertToMATEventItems:(NSArray *)arrDictionaries
{
    NSMutableArray *arrItems = [NSMutableArray array];
    
    for (NSDictionary *dict in arrDictionaries) {
        
        NSString *name = (NSString *)[dict objectForKey:@"item"];
        NSString *strUnitPrice = (NSString *)[dict objectForKey:@"unit_price"];
        float unitPrice = [NSNull null] == (id)strUnitPrice ? 0 : [strUnitPrice floatValue];
        
        NSString *strQuantity = (NSString *)[dict objectForKey:@"quantity"];
        int quantity = [NSNull null] == (id)strQuantity ? 0 : [strQuantity intValue];
        
        NSString *strRevenue = (NSString *)[dict objectForKey:@"revenue"];
        float revenue = [NSNull null] == (id)strRevenue ? 0 : [strRevenue floatValue];
        
        NSString *attribute1 = (NSString *)[dict objectForKey:@"attribute1"];
        NSString *attribute2 = (NSString *)[dict objectForKey:@"attribute2"];
        NSString *attribute3 = (NSString *)[dict objectForKey:@"attribute3"];
        NSString *attribute4 = (NSString *)[dict objectForKey:@"attribute4"];
        NSString *attribute5 = (NSString *)[dict objectForKey:@"attribute5"];
        
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
    NSLog(@"[INFO] TIMATModule MAT didSucceed: %@", str);
}

- (void)mobileAppTracker:(MobileAppTracker *)tracker didFailWithError:(NSError *)error
{
    NSLog(@"[INFO] TIMATModule MAT didFail: %@", error);
}

@end
