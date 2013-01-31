#import "FlashRuntimeExtensions.h"
#import "FRETypeConversionHelper.h"
#import "MobileAppTracker.h"
#import <UIKit/UIKit.h>

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fnVisibleName, data, fnActualName) { (const uint8_t*)(#fnVisibleName), (data), &(fnActualName) }

#pragma mark - MobileAppTrackerDelegate Methods

static FREContext matFREContext;

@interface MATSDKDelegate : NSObject<MobileAppTrackerDelegate>
// empty
@end

@implementation MATSDKDelegate

- (void)mobileAppTracker:(MobileAppTracker *)tracker didSucceedWithData:(id)data
{
    NSLog(@"MATSDKDelegate: mobileAppTracker:didSucceedWithData:");
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"MATSDKDelegate: success = %@", str);

    const char *code = "success";
    const char *level = [str UTF8String];
    
    FREDispatchStatusEventAsync(matFREContext, (const uint8_t *)code, (const uint8_t *)level);
}

- (void)mobileAppTracker:(MobileAppTracker *)tracker didFailWithError:(NSError *)error
{
    NSLog(@"MATSDKDelegate: mobileAppTracker:didFailWithError:");
    //NSLog(@"MATSDKDelegate: error = %@", error);
    
    const char * code = "failure";
    
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
    
    const char *level = [strError UTF8String];
    
    FREDispatchStatusEventAsync(matFREContext, (const uint8_t *)code, (const uint8_t *)level);
}

@end

#pragma mark - AIR iPhone Native Extension Methods

DEFINE_ANE_FUNCTION(initNativeCode)
{
    NSLog(@"initNativeCode start");
    
    NSString *advId = nil;
    MAT_FREGetObjectAsString(argv[0], &advId);
    
    NSString *advKey = nil;
    MAT_FREGetObjectAsString(argv[1], &advKey);
    
    [[MobileAppTracker sharedManager] startTrackerWithAdvertiserId:advId
                                                     advertiserKey:advKey
                                                         withError:nil];
    
    NSLog(@"initNativeCode end");
    
    return NULL;
}

DEFINE_ANE_FUNCTION(TrackInstallFunction)
{
    NSLog(@"TrackInstallFunction start");
    
    NSString *refId = nil;
    FREResult result =
    MAT_FREGetObjectAsString(argv[0], &refId);
    
    NSLog(@"result = %d, refId = %@", result, refId);
    
    [[MobileAppTracker sharedManager] trackInstallWithReferenceId:refId];
    
    NSLog(@"TrackInstallFunction end");
    
    return NULL;
}

DEFINE_ANE_FUNCTION(TrackActionWithEventItemFunction)
{
    NSLog(@"TrackActionWithEventItemFunction start");
    
    NSString *event = nil;
    FREResult result;
    result = MAT_FREGetObjectAsString(argv[0], &event);
    
    double revenue = 0;
    result = FREGetObjectAsDouble(argv[2], &revenue);
    
    NSString *currencyCode = nil;
    result = MAT_FREGetObjectAsString(argv[3], &currencyCode);
    
    NSString *refId = nil;
    result = MAT_FREGetObjectAsString(argv[4], &refId);
    
    uint32_t eventIsId_value = 0;
    result = FREGetObjectAsBool(argv[5], &eventIsId_value);
    BOOL eventIsId = 1 == eventIsId_value;
    
    int32_t transactionState = 0;
    result = FREGetObjectAsInt32(argv[6], &transactionState);
    
    uint32_t arrayLength = 0;
    NSMutableArray *eventItems = [NSMutableArray array];
    
    FREObject arrEventItems = argv[1];
    if (arrEventItems)
    {
        if (FREGetArrayLength(arrEventItems, &arrayLength) != FRE_OK)
        {
            arrayLength = 0;
        }
        
        NSArray *arrKeys = [NSArray arrayWithObjects:@"item", @"unit_price", @"quantity", @"revenue", nil];
        
        for (uint32_t i = 0; i < arrayLength; i += 4)
        {
            NSString *itemName;
            NSString *itemUnitPrice;
            NSString *itemQty;
            NSString *itemRevenue;
            
            FREObject freItemName = NULL;
            FREObject freItemUnitPrice = NULL;
            FREObject freItemQty = NULL;
            FREObject freItemRevenue = NULL;
            
            if(FRE_OK == FREGetArrayElementAt(arrEventItems, i, &freItemName)
                && FRE_OK == FREGetArrayElementAt(arrEventItems, i + 1, &freItemUnitPrice)
                && FRE_OK == FREGetArrayElementAt(arrEventItems, i + 2, &freItemQty)
                && FRE_OK == FREGetArrayElementAt(arrEventItems, i + 2, &freItemRevenue))
            {
                if(FRE_OK == MAT_FREGetObjectAsString(freItemName, &itemName)
                   && FRE_OK == MAT_FREGetObjectAsString(freItemUnitPrice, &itemUnitPrice)
                   && FRE_OK == MAT_FREGetObjectAsString(freItemQty, &itemQty)
                   && FRE_OK == MAT_FREGetObjectAsString(freItemRevenue, &itemRevenue))
                {
                    NSArray *arrValues = [NSArray arrayWithObjects:itemName, itemUnitPrice, itemQty, itemRevenue, nil];
                    
                    NSDictionary *eventItem = [NSDictionary dictionaryWithObjects:arrValues forKeys:arrKeys];
                    
                    // Add the eventItem to the array
                    [eventItems addObject:eventItem];
                }
            }
        }
    }
    
    [[MobileAppTracker sharedManager] trackActionForEventIdOrName:event
                                                        eventIsId:eventIsId
                                                       eventItems:eventItems
                                                      referenceId:refId
                                                    revenueAmount:revenue
                                                     currencyCode:currencyCode
                                                 transactionState:transactionState];
    
    NSLog(@"TrackPurchaseActionFunction end");
    
    return NULL;
}

DEFINE_ANE_FUNCTION(TrackActionFunction)
{
    NSLog(@"TrackActionFunction");
    
    NSString *event = nil;
    MAT_FREGetObjectAsString(argv[0], &event);
    
    double revenue;
    FREGetObjectAsDouble(argv[1], &revenue);
    
    NSString* currencyCode = nil;
    MAT_FREGetObjectAsString(argv[2], &currencyCode);
    
    NSString *refId = nil;
    MAT_FREGetObjectAsString(argv[3], &refId);
    
    uint32_t isId;
    FREGetObjectAsBool(argv[4], &isId);
    BOOL eventIsId = 1 == isId;
    
    [[MobileAppTracker sharedManager] trackActionForEventIdOrName:event
                                                        eventIsId:eventIsId
                                                      referenceId:refId
                                                    revenueAmount:revenue
                                                     currencyCode:currencyCode];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(TrackUpdateFunction)
{
    NSLog(@"TrackUpdateFunction");
    
    NSString *refId = nil;
    FREResult result =
    MAT_FREGetObjectAsString(argv[0], &refId);
    
    NSLog(@"result = %d, refId = %@", result, refId);
    
    [[MobileAppTracker sharedManager] trackUpdateWithReferenceId:refId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(StartAppToAppTrackingFunction)
{
    NSLog(@"StartAppToAppTrackingFunction");
    
    NSString *targetAppId = nil;
    MAT_FREGetObjectAsString(argv[0], &targetAppId);
    
    NSString *advertiserId = nil;
    MAT_FREGetObjectAsString(argv[1], &advertiserId);
    
    NSString *offerId = nil;
    MAT_FREGetObjectAsString(argv[2], &offerId);
    
    NSString *publisherId = nil;
    MAT_FREGetObjectAsString(argv[3], &publisherId);
    
    uint32_t bRedirect;
    FREGetObjectAsBool(argv[4], &bRedirect);
    BOOL shouldRedirect = 1 == bRedirect;
    
    [[MobileAppTracker sharedManager] setTracking:targetAppId advertiserId:advertiserId offerId:offerId publisherId:publisherId redirect:shouldRedirect];
    
    return NULL;
}

#pragma mark - Setter Methods

DEFINE_ANE_FUNCTION(SetDebugModeFunction)
{
    NSLog(@"SetDebugModeFunction");
    
    uint32_t shouldDebug;
    FREGetObjectAsBool(argv[0], &shouldDebug);
    
    [[MobileAppTracker sharedManager] setShouldDebugResponseFromServer:1 == shouldDebug];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetAllowDuplicatesFunction)
{
    NSLog(@"SetAllowDuplicatesFunction");
    
    uint32_t isAllowDuplicates;
    FREGetObjectAsBool(argv[0], &isAllowDuplicates);
    BOOL allowDuplicates = 1 == isAllowDuplicates;
    
    [[MobileAppTracker sharedManager] setShouldAllowDuplicateRequests:allowDuplicates];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetShouldAutoGenerateMacAddressFunction)
{
    NSLog(@"Native: SetShouldAutoGenerateMacAddressFunction");
    
    uint32_t isAutoGenerate;
    FREGetObjectAsBool(argv[0], &isAutoGenerate);
    BOOL shouldAutoGenerate = 1 == isAutoGenerate;
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateMacAddress:shouldAutoGenerate];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetShouldAutoGenerateODIN1KeyFunction)
{
    NSLog(@"Native: SetShouldAutoGenerateODIN1KeyFunction");
    
    uint32_t isAutoGenerate;
    FREGetObjectAsBool(argv[0], &isAutoGenerate);
    BOOL shouldAutoGenerate = 1 == isAutoGenerate;
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateODIN1Key:shouldAutoGenerate];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetShouldAutoGenerateOpenUDIDKeyFunction)
{
    NSLog(@"Native: setShouldAutoGenerateOpenUDIDKey");
    
    uint32_t isAutoGenerate;
    FREGetObjectAsBool(argv[0], &isAutoGenerate);
    BOOL shouldAutoGenerate = 1 == isAutoGenerate;
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateOpenUDIDKey:shouldAutoGenerate];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetShouldAutoGenerateVendorIdentifierFunction)
{
    NSLog(@"Native: setShouldAutoGenerateVendorIdentifier");
    
    uint32_t isAutoGenerate;
    FREGetObjectAsBool(argv[0], &isAutoGenerate);
    BOOL shouldAutoGenerate = 1 == isAutoGenerate;
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateVendorIdentifier:shouldAutoGenerate];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetShouldAutoGenerateAdvertiserIdentifierFunction)
{
    NSLog(@"Native: setShouldAutoGenerateAdvertiserIdentifier");
    
    uint32_t isAutoGenerate;
    FREGetObjectAsBool(argv[0], &isAutoGenerate);
    BOOL shouldAutoGenerate = 1 == isAutoGenerate;
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateAdvertiserIdentifier:shouldAutoGenerate];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetSiteIdFunction)
{
    NSLog(@"SetSiteIdFunction");
    
    NSString *siteId = nil;
    //FREResult result =
    MAT_FREGetObjectAsString(argv[0], &siteId);
    
    [[MobileAppTracker sharedManager] setSiteId:siteId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUseCookieTrackingFunction)
{
    NSLog(@"SetUseCookieTrackingFunction");
    
    uint32_t isUseCookieTracking;
    FREGetObjectAsBool(argv[0], &isUseCookieTracking);
    BOOL useCookieTracking = 1 == isUseCookieTracking;
    
    [[MobileAppTracker sharedManager] setUseCookieTracking:useCookieTracking];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUseHTTPSFunction)
{
    NSLog(@"SetUseHTTPSFunction");
    
    uint32_t isUseHttps;
    FREGetObjectAsBool(argv[0], &isUseHttps);
    BOOL useHttps = 1 == isUseHttps;
    
    [[MobileAppTracker sharedManager] setUseCookieTracking:useHttps];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetRedirectUrlFunction)
{
    NSLog(@"SetRedirectUrlFunction");
    
    NSString *redirectUrl = nil;
    //FREResult result =
    MAT_FREGetObjectAsString(argv[0], &redirectUrl);
    
    [[MobileAppTracker sharedManager] setRedirectUrl:redirectUrl];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetCurrencyCodeFunction)
{
    NSLog(@"SetCurrencyCodeFunction");
    
    NSString *currencyCode = nil;
    //FREResult result =
    MAT_FREGetObjectAsString(argv[0], &currencyCode);
    
    [[MobileAppTracker sharedManager] setCurrencyCode:currencyCode];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUserIdFunction)
{
    NSLog(@"SetUserIdFunction");
    
    NSString *userId = nil;
    //FREResult result =
    MAT_FREGetObjectAsString(argv[0], &userId);
    
    [[MobileAppTracker sharedManager] setUserId:userId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetDeviceIdFunction)
{
    NSLog(@"SetDeviceIdFunction");
    
    uint32_t isSetDeviceId;
    FREGetObjectAsBool(argv[0], &isSetDeviceId);
    BOOL shouldSetDeviceId = 1 == isSetDeviceId;
    
#warning !!! This code calls the UIDevice uniqueIdentifier API method deprecated by Apple. Please remove the call, if you do not wish to access the device uniqueIdentifier. !!!
    // !!! This code calls the UIDevice uniqueIdentifier API method deprecated by Apple. Please remove the call, if you do not wish to access the device uniqueIdentifier. !!!
    NSString *udid = shouldSetDeviceId ? [[UIDevice currentDevice] uniqueIdentifier] : nil;
    [[MobileAppTracker sharedManager] setDeviceId:udid];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetOpenUDIDFunction)
{
    NSLog(@"SetOpenUDIDFunction");
    
    NSString *openUDID = nil;
    //FREResult result =
    MAT_FREGetObjectAsString(argv[0], &openUDID);
    
    [[MobileAppTracker sharedManager] setOpenUDID:openUDID];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetPackageNameFunction)
{
    NSLog(@"SetPackageNameFunction");
    
    NSString *pkgName = nil;
    //FREResult result =
    MAT_FREGetObjectAsString(argv[0], &pkgName);
    
    [[MobileAppTracker sharedManager] setPackageName:pkgName];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetTRUSTeIdFunction)
{
    NSLog(@"SetTRUSTeIdFunction");
    
    NSString *trusteId = nil;
    //FREResult result =
    MAT_FREGetObjectAsString(argv[0], &trusteId);
    
    [[MobileAppTracker sharedManager] setTrusteTPID:trusteId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetDelegateFunction)
{
    NSLog(@"SetDelegateFunction");
    
    uint32_t isUseDelegate;
    FREGetObjectAsBool(argv[0], &isUseDelegate);
    BOOL useDelegate = 1 == isUseDelegate;
    
    MATSDKDelegate *sdkDelegate = nil;
    
    if(useDelegate)
    {
        // when enabled set an object of MATSDKDelegate as the delegate for MobileAppTracker
        sdkDelegate = [[MATSDKDelegate alloc] init];
    }
    [[MobileAppTracker sharedManager] setDelegate:sdkDelegate];
    
    return NULL;
}

#pragma mark - Getter SDK Data Parameters

DEFINE_ANE_FUNCTION(GetSDKDataParametersFunction)
{
    // NSDictionary to NSString as it is -- non-json string
    //return [[[[MobileAppTracker sharedManager] sdkDataParameters] description] UTF8String];
    
    NSLog(@"GetSDKDataParametersFunction");
    
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
    
    const char *paramsUTF8 = [strParams UTF8String];
    
    FREObject params = NULL;
    FRENewObjectFromUTF8(strlen(paramsUTF8) + 1, (const uint8_t*)paramsUTF8, &params);
    
    return params;
}

#pragma mark - Extension Context Setup Methods

void MATExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{
    NSLog(@"MATExtContextInitializer");
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(initNativeCode,                            NULL, initNativeCode),
        
        MAP_FUNCTION(getSDKDataParameters,                      NULL, GetSDKDataParametersFunction),
        
        MAP_FUNCTION(startAppToAppTracking,                     NULL, StartAppToAppTrackingFunction),
        
        MAP_FUNCTION(trackInstall,                              NULL, TrackInstallFunction),
        MAP_FUNCTION(trackUpdate,                               NULL, TrackUpdateFunction),
        MAP_FUNCTION(trackAction,                               NULL, TrackActionFunction),
        MAP_FUNCTION(trackActionWithEventItem,                  NULL, TrackActionWithEventItemFunction),
        
        MAP_FUNCTION(setAllowDuplicates,                        NULL, SetAllowDuplicatesFunction),
        MAP_FUNCTION(setCurrencyCode,                           NULL, SetCurrencyCodeFunction),
        MAP_FUNCTION(setDebugMode,                              NULL, SetDebugModeFunction),
        MAP_FUNCTION(setDelegate,                               NULL, SetDelegateFunction),
        MAP_FUNCTION(setDeviceId,                               NULL, SetDeviceIdFunction),
        MAP_FUNCTION(setOpenUDID,                               NULL, SetOpenUDIDFunction),
        MAP_FUNCTION(setPackageName,                            NULL, SetPackageNameFunction),
        MAP_FUNCTION(setRedirectUrl,                            NULL, SetRedirectUrlFunction),
        MAP_FUNCTION(setShouldAutoGenerateAdvertiserIdentifier, NULL, SetShouldAutoGenerateAdvertiserIdentifierFunction),
        MAP_FUNCTION(setShouldAutoGenerateMacAddress,           NULL, SetShouldAutoGenerateMacAddressFunction),
        MAP_FUNCTION(setShouldAutoGenerateODIN1Key,             NULL, SetShouldAutoGenerateODIN1KeyFunction),
        MAP_FUNCTION(setShouldAutoGenerateOpenUDIDKey,          NULL, SetShouldAutoGenerateOpenUDIDKeyFunction),
        MAP_FUNCTION(setShouldAutoGenerateVendorIdentifier,     NULL, SetShouldAutoGenerateVendorIdentifierFunction),
        MAP_FUNCTION(setSiteId,                                 NULL, SetSiteIdFunction),
        MAP_FUNCTION(setTRUSTeId,                               NULL, SetTRUSTeIdFunction),
        MAP_FUNCTION(setUseCookieTracking,                      NULL, SetUseCookieTrackingFunction),
        MAP_FUNCTION(setUseHTTPS,                               NULL, SetUseHTTPSFunction),
        MAP_FUNCTION(setUserId,                                 NULL, SetUserIdFunction)
    };
    
    *numFunctionsToSet = sizeof( functions ) / sizeof( FRENamedFunction );
	*functionsToSet = functions;
    
    matFREContext = ctx;
}

void MATExtContextFinalizer(FREContext ctx)
{
    NSLog(@"MATExtContextFinalizer");
    return;
}

void ExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    NSLog(@"MobileAppTrackingANE.ExtInitializer");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &MATExtContextInitializer;
    *ctxFinalizerToSet = &MATExtContextFinalizer;
}

void ExtFinalizer(void * extData)
{
    NSLog(@"MobileAppTrackingANE.ExtFinalizer");
    return;
}