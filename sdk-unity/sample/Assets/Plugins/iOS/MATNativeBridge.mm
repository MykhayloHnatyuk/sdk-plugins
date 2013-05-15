#import "MATNativeBridge.h"
#import "NSData+MATBase64.h"

// corresponds to GameObject named MobileAppTracker in the Unity Project
const char * UNITY_SENDMESSAGE_CALLBACK_RECEIVER = "MobileAppTracker";
// corresponds to the method defined in the script attached to the above GameObject
const char * UNITY_SENDMESSAGE_CALLBACK_SUCCESS = "trackerDidSucceed";
// corresponds to the method defined in the script attached to the above GameObject
const char * UNITY_SENDMESSAGE_CALLBACK_FAILURE = "trackerDidFail";

@interface MATSDKDelegate : NSObject<MobileAppTrackerDelegate>

// empty

@end

@implementation MATSDKDelegate

- (void)mobileAppTracker:(MobileAppTracker *)tracker didSucceedWithData:(NSData *)data
{
    //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"Native: MATSDKDelegate: success = %@", str);
    
    NSLog(@"Native: MATSDKDelegate: success");
    
    UnitySendMessage(UNITY_SENDMESSAGE_CALLBACK_RECEIVER, UNITY_SENDMESSAGE_CALLBACK_SUCCESS, [[data base64EncodedString] UTF8String]);
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
    
    UnitySendMessage(UNITY_SENDMESSAGE_CALLBACK_RECEIVER, UNITY_SENDMESSAGE_CALLBACK_FAILURE, [strError UTF8String]);
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
    
    void initNativeCode (const char* advertiserId, const char* conversionKey)
    {
        printf("Native: initNativeCode = %s, %s", advertiserId, conversionKey);
        
        [[MobileAppTracker sharedManager] startTrackerWithMATAdvertiserId:CreateNSString(advertiserId)
                                                         MATConversionKey:CreateNSString(conversionKey)
                                                                withError:nil];
    }
    
    void setDelegate(bool enable)
    {
        NSLog(@"Native: setDelegate = %d", enable);
        
        // When enabled, create/set MATSDKDelegate object as the delegate for MobileAppTracker.
        matDelegate = enable ? (matDelegate ? nil : [[MATSDKDelegate alloc] init]) : nil;
        
        [[MobileAppTracker sharedManager] setDelegate:matDelegate];
    }
    
    void setAllowDuplicateRequests(bool allowDuplicateRequests)
    {
        NSLog(@"Native: setAllowDuplicates = %d", allowDuplicateRequests);
        
        [[MobileAppTracker sharedManager] setAllowDuplicateRequests:allowDuplicateRequests];
    }
    
    void setShouldAutoGenerateMacAddress(bool shouldAutoGenerate)
    {
        NSLog(@"Native: setShouldAutoGenerateMacAddress = %d", shouldAutoGenerate);
        
        [[MobileAppTracker sharedManager] setShouldAutoGenerateMacAddress:shouldAutoGenerate];
    }
    
    void setShouldAutoGenerateODIN1Key(bool shouldAutoGenerate)
    {
        NSLog(@"Native: setShouldAutoGenerateODIN1Key = %d", shouldAutoGenerate);
        
        [[MobileAppTracker sharedManager] setShouldAutoGenerateODIN1Key:shouldAutoGenerate];
    }
    
    void setShouldAutoGenerateOpenUDIDKey(bool shouldAutoGenerate)
    {
        NSLog(@"Native: setShouldAutoGenerateOpenUDIDKey = %d", shouldAutoGenerate);
        
        [[MobileAppTracker sharedManager] setShouldAutoGenerateOpenUDIDKey:shouldAutoGenerate];
    }
    
    void setShouldAutoGenerateAppleVendorIdentifier(bool shouldAutoGenerate)
    {
        NSLog(@"Native: setShouldAutoGenerateAppleVendorIdentifier = %d", shouldAutoGenerate);
        
        [[MobileAppTracker sharedManager] setShouldAutoGenerateAppleVendorIdentifier:shouldAutoGenerate];
    }
    
    void setShouldAutoGenerateAppleAdvertisingIdentifier(bool shouldAutoGenerate)
    {
        NSLog(@"Native: setShouldAutoGenerateAppleAdvertisingIdentifier = %d", shouldAutoGenerate);
        
        [[MobileAppTracker sharedManager] setShouldAutoGenerateAppleAdvertisingIdentifier:shouldAutoGenerate];
    }
    
    void setUseCookieTracking(bool useCookieTracking)
    {
        NSLog(@"Native: setUseCookieTracking = %d", useCookieTracking);
        
        [[MobileAppTracker sharedManager] setUseCookieTracking:useCookieTracking];
    }
    
	void setUseHTTPS(bool useHTTPS)
    {
        NSLog(@"Native: setUseHTTPS = %d", useHTTPS);
        
        [[MobileAppTracker sharedManager] setUseHTTPS:useHTTPS];
    }
    
    void setCurrencyCode(const char* currency_code)
    {
        NSLog(@"Native: setCurrencyCode = %s", currency_code);
        
        [[MobileAppTracker sharedManager] setCurrencyCode:CreateNSString(currency_code)];
    }
    
    void setRedirectUrl(const char* redirectUrl)
    {
        NSLog(@"Native: setRedirectUrl = %s", redirectUrl);
        
        [[MobileAppTracker sharedManager] setRedirectUrl:CreateNSString(redirectUrl)];
    }
    
    void setDebugMode(bool enable)
    {
        NSLog(@"Native: setDebugMode = %d", enable);
        
        [[MobileAppTracker sharedManager] setDebugMode:enable];
    }
    
    void setOpenUDID(const char* open_udid)
    {
        NSLog(@"Native: setOpenUDID = %s", open_udid);
        
        [[MobileAppTracker sharedManager] setOpenUDID:CreateNSString(open_udid)];
    }
    
    void setPackageName(const char* package_name)
    {
        NSLog(@"Native: setPackageName = %s", package_name);
        
        [[MobileAppTracker sharedManager] setPackageName:CreateNSString(package_name)];
    }
    
    void setSiteId(const char* site_id)
    {
        NSLog(@"Native: setSiteId: %s", site_id);
        
        [[MobileAppTracker sharedManager] setSiteId:CreateNSString(site_id)];
    }
    
    void setTRUSTeId(const char* truste_tpid)
    {
        NSLog(@"Native: setTRUSTeId: %s", truste_tpid);
        
        [[MobileAppTracker sharedManager] setTrusteTPID:CreateNSString(truste_tpid)];
    }
    
    void setUserId(const char* user_id)
    {
        NSLog(@"Native: setUserId: %s", user_id);
        
        [[MobileAppTracker sharedManager] setUserId:CreateNSString(user_id)];
    }
    
    void setAppleAdvertisingIdentifier(const char* appleAdvertisingId)
    {
        NSLog(@"Native: setAppleAdvertisingIdentifier: %s", appleAdvertisingId);
        
        [[MobileAppTracker sharedManager] setAppleAdvertisingIdentifier:[[NSUUID alloc] initWithUUIDString:CreateNSString(appleAdvertisingId)] ];
    }
    
    void setAppleVendorIdentifier(const char* appleVendorId)
    {
        NSLog(@"Native: setAppleVendorIdentifier: %s", appleVendorId);
        
        [[MobileAppTracker sharedManager] setAppleVendorIdentifier:[[NSUUID alloc] initWithUUIDString:CreateNSString(appleVendorId)] ];
    }
    
    void startAppToAppTracking(const char *targetAppId, const char *advertiserId, const char *offerId, const char *publisherId, bool shouldRedirect)
    {
        NSLog(@"Native: startAppToAppTracking: %s, %s, %s, %s, %d", targetAppId, advertiserId, offerId, publisherId, shouldRedirect);
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
        
        [[MobileAppTracker sharedManager] trackInstallWithReferenceId:refId ? CreateNSString(refId) : nil];
    }
	
	void trackUpdateWithReferenceId(const char *refId)
    {
        NSLog(@"Native: trackUpdateWithReferenceId: refId = %s", refId);
        
        [[MobileAppTracker sharedManager] trackUpdateWithReferenceId:refId ? CreateNSString(refId) : nil];
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
