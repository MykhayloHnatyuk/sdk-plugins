#import "MATNativeBridge.h"
#import "NSData+MATBase64.h"

@interface MATSDKDelegate : NSObject<MobileAppTrackerDelegate>

// empty

@end

@implementation MATSDKDelegate

- (void)mobileAppTracker:(MobileAppTracker *)tracker didSucceedWithData:(NSData *)data
{
    //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"Native: MATSDKDelegate: success = %@", str);
    
    NSLog(@"Native: MATSDKDelegate: success");
    
    UnitySendMessage("MobileAppTracker", "trackerDidSucceed", [[data base64EncodedString] UTF8String]);
}

- (void)mobileAppTracker:(MobileAppTracker *)tracker didFailWithError:(NSError *)error
{
    //NSLog(@"Native: MATSDKDelegate: error = %@", error);
    NSLog(@"Native: MATSDKDelegate: error");
    
    NSInteger errorCode = [error code];
    NSString *errorDescr = [error localizedDescription];
    
    NSString *errorURLString = nil;
    NSDictionary *dictError = [error userInfo];
    
    if(dictError)
    {
        errorURLString = [dictError objectForKey:NSURLErrorFailingURLStringErrorKey];
    }
    
    errorURLString = nil == error ? @"" : errorURLString;
    
    NSString *strError = [NSString stringWithFormat:@"{\"code\":\"%d\",\"localizedDescription\":\"%@\",\"failedURL\":\"%@\"}", errorCode, errorDescr, errorURLString];
    
    UnitySendMessage("MobileAppTracker", "trackerDidFail", [strError UTF8String]);
}

@end

// Converts C style string to NSString
NSString* CreateNSString (const char* string)
{
	return [NSString stringWithUTF8String:string ? string : ""];
}

MATSDKDelegate *matDelegate;

// When native code plugin is implemented in .mm / .cpp file, then functions
// should be surrounded with extern "C" block to conform C function naming rules
extern "C" {
    
    void initNativeCode (const char* advertiserId, const char* advertiserKey)
    {
        printf("Native: initNativeCode = %s, %s", advertiserId, advertiserKey);
        
        [[MobileAppTracker sharedManager] startTrackerWithAdvertiserId:CreateNSString(advertiserId)
                                                         advertiserKey:CreateNSString(advertiserKey)
                                                             withError:nil];
    }
    
    void setDelegate(bool enable)
    {
        // When enabled, create/set MATSDKDelegate object as the delegate for MobileAppTracker.
        matDelegate = enable ? (matDelegate ? nil : [[MATSDKDelegate alloc] init]) : nil;
        
        [[MobileAppTracker sharedManager] setDelegate:matDelegate];
    }
    
    void setAllowDuplicates(bool allowDuplicates)
    {
        NSLog(@"Native: setAllowDuplicates");
        
        [[MobileAppTracker sharedManager] setShouldAllowDuplicateRequests:allowDuplicates];
    }
    
    void setShouldAutoGenerateMacAddress(bool shouldAutoGenerate)
    {
        NSLog(@"Native: setShouldAutoGenerateMacAddress");
        
        [[MobileAppTracker sharedManager] setShouldAutoGenerateMacAddress:shouldAutoGenerate];
    }
    
    void setShouldAutoGenerateODIN1Key(bool shouldAutoGenerate)
    {
        NSLog(@"Native: setShouldAutoGenerateODIN1Key");
        
        [[MobileAppTracker sharedManager] setShouldAutoGenerateODIN1Key:shouldAutoGenerate];
    }
    
    void setShouldAutoGenerateOpenUDIDKey(bool shouldAutoGenerate)
    {
        NSLog(@"Native: setShouldAutoGenerateOpenUDIDKey");
        
        [[MobileAppTracker sharedManager] setShouldAutoGenerateOpenUDIDKey:shouldAutoGenerate];
    }
    
    void setShouldAutoGenerateVendorIdentifier(bool shouldAutoGenerate)
    {
        NSLog(@"Native: setShouldAutoGenerateVendorIdentifier");
        
        [[MobileAppTracker sharedManager] setShouldAutoGenerateVendorIdentifier:shouldAutoGenerate];
    }
    
    void setShouldAutoGenerateAdvertiserIdentifier(bool shouldAutoGenerate)
    {
        NSLog(@"Native: setShouldAutoGenerateAdvertiserIdentifier");
        
        [[MobileAppTracker sharedManager] setShouldAutoGenerateAdvertiserIdentifier:shouldAutoGenerate];
    }
    
    void setUseCookieTracking(bool useCookieTracking)
    {
        NSLog(@"Native: setUseCookieTracking");
        
        [[MobileAppTracker sharedManager] setUseCookieTracking:useCookieTracking];
    }
    
	void setUseHTTPS(bool useHTTPS)
    {
        NSLog(@"Native: setUseHTTPS");
        
        [[MobileAppTracker sharedManager] setUseHTTPS:useHTTPS];
    }
    
    void setCurrencyCode(const char* currency_code)
    {
        NSLog(@"Native: setCurrencyCode = %@", CreateNSString(currency_code));
        
        [[MobileAppTracker sharedManager] setCurrencyCode:CreateNSString(currency_code)];
    }
    
    void setRedirectUrl(const char* redirectUrl)
    {
        NSLog(@"Native: setRedirectUrl = %@", CreateNSString(redirectUrl));
        
        [[MobileAppTracker sharedManager] setRedirectUrl:CreateNSString(redirectUrl)];
    }
    
    void setDebugMode(bool enable)
    {
        NSLog(@"Native: setDebugMode");
        
        [[MobileAppTracker sharedManager] setShouldDebugResponseFromServer:enable];
    }
    
    void setDeviceId(bool enable)
    {
        NSLog(@"Native: setDeviceId = %d", enable);
        
#warning !!! This code calls the UIDevice uniqueIdentifier API method deprecated by Apple. Please remove the call, if you do not wish to access the device uniqueIdentifier. !!!
        // !!! This code calls the UIDevice uniqueIdentifier API method deprecated by Apple. Please remove the call, if you do not wish to access the device uniqueIdentifier. !!!
        NSString *udid = enable ? [[UIDevice currentDevice] uniqueIdentifier] : nil;
        [[MobileAppTracker sharedManager] setDeviceId:udid];
    }

    void setOpenUDID(const char* open_udid)
    {
        NSLog(@"Native: setOpenUDID = %@", CreateNSString(open_udid));
        
        [[MobileAppTracker sharedManager] setOpenUDID:CreateNSString(open_udid)];
    }

    void setPackageName(const char* package_name)
    {
        NSLog(@"Native: setPackageName = %@", CreateNSString(package_name));
        
        [[MobileAppTracker sharedManager] setPackageName:CreateNSString(package_name)];
    }

    void setSiteId(const char* site_id)
    {
        NSLog(@"Native: setSiteId: %@", CreateNSString(site_id));
        
        [[MobileAppTracker sharedManager] setSiteId:CreateNSString(site_id)];
    }

    void setTRUSTeId(const char* truste_tpid)
    {
        NSLog(@"Native: setTRUSTeId: %@", CreateNSString(truste_tpid));
        
        [[MobileAppTracker sharedManager] setTrusteTPID:CreateNSString(truste_tpid)];
    }

    void setUserId(const char* user_id)
    {
        NSLog(@"Native: setUserId: %@", CreateNSString(user_id));
        
        [[MobileAppTracker sharedManager] setUserId:CreateNSString(user_id)];
    }

    void setAdvertiserIdentifier(const char* advertiserId)
    {
        NSLog(@"Native: setAdvertiserIdentifier: %@", CreateNSString(advertiserId));
        
        [[MobileAppTracker sharedManager] setAdvertiserIdentifier:[[NSUUID alloc] initWithUUIDString:CreateNSString(advertiserId)] ];
    }
    
    void setVendorIdentifier(const char* vendorId)
    {
        NSLog(@"Native: setVendorIdentifier: %@", CreateNSString(vendorId));
        
        [[MobileAppTracker sharedManager] setVendorIdentifier:[[NSUUID alloc] initWithUUIDString:CreateNSString(vendorId)] ];
    }
    
    void startAppToAppTracking(const char *targetAppId, const char *advertiserId, const char *offerId, const char *publisherId, bool shouldRedirect)
    {
        NSLog(@"Native: startAppToAppTracking: %@, %@, %@, %@, %d", CreateNSString(targetAppId), CreateNSString(advertiserId), CreateNSString(offerId), CreateNSString(publisherId), shouldRedirect);
        [[MobileAppTracker sharedManager] setTracking:CreateNSString(targetAppId) advertiserId:CreateNSString(advertiserId) offerId:CreateNSString(offerId) publisherId:CreateNSString(publisherId) redirect:shouldRedirect];
    }
    
    const char * getSDKDataParameters()
    {
        // NSDictionary to NSString as it is -- non-json string
        //return [[[[MobileAppTracker sharedManager] sdkDataParameters] description] UTF8String];
        
        NSLog(@"Native: getSDKDataParameters");
        
        NSMutableString *strParams = [NSMutableString stringWithFormat:@"{\"sdkDataParams\":{"];
        
        NSDictionary *dictParams = [[MobileAppTracker sharedManager] sdkDataParameters];
        NSArray *arrKeys = [dictParams allKeys];
        
        int count = [dictParams count];
        
        for(int i = 0; i < count; ++i)
        {
            NSString *key = [arrKeys objectAtIndex:i];
            [strParams appendFormat:@"\"%@\":\"%@\"%@", key, [dictParams objectForKey:key], i < (count - 1) ? @"," : @""];
        }
        
        [strParams appendFormat:@"}}"];
        
        return [strParams UTF8String];
    } 
    
    void trackInstall()
    {
        NSLog(@"Native: trackInstall");
        
        [[MobileAppTracker sharedManager] trackInstall];
    }
    
    void trackUpdate()
    {
        NSLog(@"Native: trackUpdate");
        
        [[MobileAppTracker sharedManager] trackUpdate];
    }
    
	void trackInstallWithReferenceId(const char *refId)
    {
        NSLog(@"Native: trackInstallWithReferenceId: refId = %s", refId);
        
        [[MobileAppTracker sharedManager] trackInstallWithReferenceId:refId ? [NSString stringWithUTF8String:refId] : nil];
    }
	
	void trackUpdateWithReferenceId(const char *refId)
    {
        NSLog(@"Native: trackUpdateWithReferenceId: refId = %s", refId);
        
        [[MobileAppTracker sharedManager] trackUpdateWithReferenceId:refId ? [NSString stringWithUTF8String:refId] : nil];
    }
    
    void trackAction(const char* action, bool isId, double revenue, const char*  currency)
    {
        NSLog(@"Native: trackAction");
        
        [[MobileAppTracker sharedManager] trackActionForEventIdOrName:CreateNSString(action)
                                                            eventIsId:isId
                                                        revenueAmount:revenue
                                                         currencyCode:CreateNSString(currency)];
    }
    
    void trackActionWithEventItem(const char* action, bool isId, MATEventItem eventItems[], int eventItemCount, const char* refId, double revenue, const char* currency, int transactionState)
    {
        NSLog(@"Native: trackActionWithEventItem");
        
        // reformat the items array as an nsarray of dictionary
        NSMutableArray *arrEventItems = [NSMutableArray array];
        for (uint i = 0; i < eventItemCount; i++)
        {
            MATEventItem eventItem = eventItems[i];
            
            NSString *item = CreateNSString(eventItem.item);
            NSNumber *unitPrice = [NSNumber numberWithDouble:eventItem.unitPrice];
            NSNumber *quantity = [NSNumber numberWithInt:eventItem.quantity];
            NSNumber *revenue = [NSNumber numberWithDouble:eventItem.revenue];
            
            NSDictionary *dict = [[[NSDictionary alloc]initWithObjectsAndKeys:item, @"item",
                                   unitPrice, @"unit_price",
                                   quantity, @"quantity",
                                   revenue, @"revenue", nil] autorelease];
            [arrEventItems addObject:dict];
        }
        
        [[MobileAppTracker sharedManager] trackActionForEventIdOrName:CreateNSString(action)
                                                            eventIsId:isId
                                                           eventItems:arrEventItems
                                                          referenceId:CreateNSString(refId)
                                                        revenueAmount:revenue
                                                         currencyCode:CreateNSString(currency)
                                                     transactionState:(NSInteger)transactionState];
    }
}
