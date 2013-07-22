/*
 * iphone-specific implementation of the s3eMATSDK extension.
 * Add any platform-specific functionality here.
 */
/*
 * NOTE: This file was originally written by the extension builder, but will not
 * be overwritten (unless --force is specified) and is intended to be modified.
 */
#include "s3eMATSDK_internal.h"
#import <UIKit/UIKit.h>
#include "s3eTypes.h"
#include "s3eEdk.h"
#include "s3eEdk_iphone.h"
#include "IwDebug.h"

#include "MobileAppTracker.h"

#define S3E_CURRENT_EXT MATSDK
#include "s3eEdkError.h"
#define S3E_DEVICE_MATSDK S3E_EXT_MATSDK_HASH
#define PARAMETERS

@interface MATSDKDelegate : NSObject <MobileAppTrackerDelegate>

@end

@implementation MATSDKDelegate

- (void)mobileAppTracker:(MobileAppTracker *)tracker didSucceedWithData:(NSData *)data
{
    NSString * dataString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    NSLog(@"MobileAppTracker:trackerDidSucceed: %@", dataString);
}

- (void)mobileAppTracker:(MobileAppTracker *)tracker didFailWithError:(NSError *)error
{
    //NSLog(@"Native: MATSDKDelegate: error = %@", error);
    
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
    
    NSLog(@"MobileAppTracker:trackerDidFail: %@", strError);
}

@end

MATSDKDelegate *matDelegate;

s3eResult MATSDKInit_platform()
{
    // Add any platform-specific initialisation code here
    return S3E_RESULT_SUCCESS;
}

void MATSDKTerminate_platform()
{
    // Add any platform-specific termination code here
}

void MATStartMobileAppTracker_platform(const char* adId, const char* convKey)
{
    NSLog(@"Starting MAT");
	NSString *aid = [NSString stringWithUTF8String:adId];
	NSString *ckey = [NSString stringWithUTF8String:convKey];
	[[MobileAppTracker sharedManager] startTrackerWithMATAdvertiserId:aid MATConversionKey:ckey];
}

void MATSDKParameters_platform()
{
    NSDictionary *dict = [[MobileAppTracker sharedManager] sdkDataParameters];
    NSLog(@"get SDK data parameters = %@", dict);
}

void MATTrackInstall_platform()
{
    NSLog(@"track install");
    [[MobileAppTracker sharedManager] trackInstall];
}

void MATTrackUpdate_platform()
{
    NSLog(@"track udpate");
    [[MobileAppTracker sharedManager] trackUpdate];
}

void MATTrackInstallWithReferenceId_platform(const char* refId)
{
    NSLog(@"track install %@", [NSString stringWithUTF8String:refId]);
    [[MobileAppTracker sharedManager] trackInstallWithReferenceId:[NSString stringWithUTF8String:refId]];
}

void MATTrackActionForEventIdOrName_platform(const char* eventIdOrName, bool isId, const char* refId)
{
    NSLog(@"track action");
    NSString* eventName = [NSString stringWithUTF8String:eventIdOrName];
    NSString* referenceId = [NSString stringWithUTF8String:refId];
    [[MobileAppTracker sharedManager] trackActionForEventIdOrName:eventName eventIsId:isId referenceId:referenceId];
}

void MATTrackAction_platform(const char* eventIdOrName, bool isId, double revenue, const char*  currency)
{
    NSLog(@"MATTrackAction");
    NSString* eventName = [NSString stringWithUTF8String:eventIdOrName];
    NSString* currencyCode = [NSString stringWithUTF8String:currency];
    [[MobileAppTracker sharedManager] trackActionForEventIdOrName:eventName
                                                        eventIsId:isId
                                                    revenueAmount:revenue
                                                     currencyCode:currencyCode];
}

void MATTrackActionForEventIdOrNameItems_platform(const char* eventIdOrName, bool isId, const MATArray* items, const char* refId, double revenueAmount, const char* currencyCode, uint8 transactionState, const char* receipt)
{
    NSLog(@"track action");
    NSLog(@"eventName:%@",
          [NSString stringWithUTF8String:eventIdOrName]);
    NSLog(@"refId:%@",
          [NSString stringWithUTF8String:refId]);
    NSLog(@"revenueAmount:%f", revenueAmount);
    NSLog(@"transactionState:%i", (unsigned int)transactionState);
    NSLog(@"currCode:%@",
          [NSString stringWithUTF8String:currencyCode]);
    
    // print the items array
    NSLog(@"MATSDK events array: %i", items->m_count);
    for (uint i=0; i < items->m_count; i++) {
        NSLog(@"Item name %s, unitPrice %f, quanity %i, revenue %f, attribute1 %s, attribute2 %s, attribute3 %s, attribute4 %s, attribute5 %s",
                            ((MATSDKEventItem*)items->m_items)[i].name,
                            ((MATSDKEventItem*)items->m_items)[i].unitPrice,
                            ((MATSDKEventItem*)items->m_items)[i].quantity,
                            ((MATSDKEventItem*)items->m_items)[i].revenue,
                            ((MATSDKEventItem*)items->m_items)[i].attribute1,
                            ((MATSDKEventItem*)items->m_items)[i].attribute2,
                            ((MATSDKEventItem*)items->m_items)[i].attribute3,
                            ((MATSDKEventItem*)items->m_items)[i].attribute4,
                            ((MATSDKEventItem*)items->m_items)[i].attribute5);
    }
    // reformat the items array as an nsarray of dictionary
    NSMutableArray *array = [NSMutableArray array];
    for (uint i=0; i < items->m_count; i++)
    {
        NSString *name = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].name];
        float unitPrice = ((MATSDKEventItem*)items->m_items)[i].unitPrice;
        int quantity = ((MATSDKEventItem*)items->m_items)[i].quantity;
        float revenue = ((MATSDKEventItem*)items->m_items)[i].revenue;
        
        NSString *attribute1 = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].attribute1];
        NSString *attribute2 = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].attribute2];
        NSString *attribute3 = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].attribute3];
        NSString *attribute4 = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].attribute4];
        NSString *attribute5 = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].attribute5];
        
        MATEventItem *item = [MATEventItem eventItemWithName:name unitPrice:unitPrice quantity:quantity revenue:revenue attribute1:attribute1 attribute2:attribute2 attribute3:attribute3 attribute4:attribute4 attribute5:attribute5];
        
        [array addObject:item];
    }
    
    MATSDKDelegate *delegate = [[MATSDKDelegate alloc]init];
    [[MobileAppTracker sharedManager] setDelegate:delegate];
    [[MobileAppTracker sharedManager] trackActionForEventIdOrName:[NSString stringWithUTF8String:eventIdOrName]
                                                        eventIsId:isId
                                                       eventItems:array
                                                      referenceId:[NSString stringWithUTF8String:refId]
                                                    revenueAmount:revenueAmount
                                                     currencyCode:[NSString stringWithUTF8String:currencyCode]
                                                 transactionState:(int)transactionState
                                                          receipt:[[NSString stringWithUTF8String:receipt] dataUsingEncoding:NSUTF8StringEncoding]];
}

void MATSetPackageName_platform(const char* packageName)
{
    NSLog(@"MATSetPackageName_platform packageName = %s", packageName);
    
    [[MobileAppTracker sharedManager] setPackageName:[NSString stringWithUTF8String:packageName]];
}

void MATSetCurrencyCode_platform(const char* currencyCode)
{
    NSLog(@"MATSetCurrencyCode_platform currencyCode = %s", currencyCode);
    
    [[MobileAppTracker sharedManager] setCurrencyCode:[NSString stringWithUTF8String:currencyCode]];
}

void MATSetUserId_platform(const char* userId)
{
    NSLog(@"MATSetUserId_platform id = %s", userId);
    
    [[MobileAppTracker sharedManager] setUserId:[NSString stringWithUTF8String:userId]];
}

void MATSetRevenue_platform(double revenue)
{
    // NOT IMPLEMENTED FOR iOS
}

void MATSetSiteId_platform(const char* siteId)
{
    NSLog(@"MATSetSiteId_platform id = %s", siteId);
    
    [[MobileAppTracker sharedManager] setSiteId:[NSString stringWithUTF8String:siteId]];
}

void MATSetTRUSTeId_platform(const char* tpid)
{
    NSLog(@"MATSetTRUSTeId_platform id = %s", tpid);
    
    [[MobileAppTracker sharedManager] setTrusteTPID:[NSString stringWithUTF8String:tpid]];
}

void MATSetDelegate_platform(bool enable)
{
    matDelegate = enable ? (matDelegate ? matDelegate : [[MATSDKDelegate alloc] init]) : nil;
    
    NSLog(@"MATSetDelegate_platform delegate = %d", enable);
    
    [[MobileAppTracker sharedManager] setDelegate:matDelegate];
}

void MATSetDebugMode_platform(bool shouldDebug)
{
    NSLog(@"MATSetDebugMode_platform debug mode = %d", shouldDebug);
    [[MobileAppTracker sharedManager] setDebugMode:shouldDebug];
}

void MATSetAge_platform(int age)
{
    NSLog(@"MATSetAge_platform age = %d", age);
    [[MobileAppTracker sharedManager] setAge:age];
}

void MATSetGender_platform(int gender)
{
    NSLog(@"MATSetGender_platform gender = %d", gender);
    
    [[MobileAppTracker sharedManager] setGender:gender];
}

void MATSetLocation_platform(double latitude, double longitude, double altitude)
{
    [[MobileAppTracker sharedManager] setLatitude:latitude longitude:longitude altitude:altitude];
}

void MATSetAllowDuplicates_platform(bool allowDuplicates)
{
    NSLog(@"Native: setAllowDuplicates");
    
    [[MobileAppTracker sharedManager] setAllowDuplicateRequests:allowDuplicates];
}

void MATSetShouldAutoDetectJailbroken_platform(bool shouldAutoDetect)
{
    NSLog(@"Native: setShouldAutoDetectJailbroken");
    
    [[MobileAppTracker sharedManager] setShouldAutoDetectJailbroken:shouldAutoDetect];
}

void MATSetMACAddress_platform(const char* mac)
{
    NSLog(@"Native: setMacAddress");
    
    [[MobileAppTracker sharedManager] setMACAddress:[NSString stringWithUTF8String:mac]];
}

void MATSetODIN1_platform(const char* odin1)
{
    NSLog(@"Native: setODIN1");
    
    [[MobileAppTracker sharedManager] setODIN1:[NSString stringWithUTF8String:odin1]];
}

void MATSetUIID_platform(const char* uiid)
{
    NSLog(@"Native: setUIID");
    
    [[MobileAppTracker sharedManager] setUIID:[NSString stringWithUTF8String:uiid]];
}

void MATSetOpenUDID_platform(const char* openUDID)
{
    NSLog(@"Native: setOpenUDID");
    
    [[MobileAppTracker sharedManager] setOpenUDID:[NSString stringWithUTF8String:openUDID]];
}

void MATSetShouldAutoGenerateAppleVendorIdentifier_platform(bool shouldAutoGenerate)
{
    NSLog(@"Native: setShouldAutoGenerateAppleVendorIdentifier");
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateAppleVendorIdentifier:shouldAutoGenerate];
}

void MATSetShouldAutoGenerateAppleAdvertisingIdentifier_platform(bool shouldAutoGenerate)
{
    NSLog(@"Native: setShouldAutoGenerateAppleAdvertisingIdentifier");
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateAppleAdvertisingIdentifier:shouldAutoGenerate];
}

void MATSetUseCookieTracking_platform(bool useCookieTracking)
{
    NSLog(@"Native: setUseCookieTracking");
    
    [[MobileAppTracker sharedManager] setUseCookieTracking:useCookieTracking];
}

void MATSetAppAdTracking_platform(bool enable)
{
    NSLog(@"Native: setAppAdTracking");
    
    [[MobileAppTracker sharedManager] setAppAdTracking:enable];
}

void MATSetUseHTTPS_platform(bool useHTTPS)
{
    NSLog(@"Native: setUseHTTPS");
    
    [[MobileAppTracker sharedManager] setUseHTTPS:useHTTPS];
}

void MATSetJailbroken_platform(bool isJailbroken)
{
    NSLog(@"Native: setJailbroken");
    
    [[MobileAppTracker sharedManager] setJailbroken:isJailbroken];
}

void MATSetRedirectUrl_platform(const char* redirectUrl)
{
    NSLog(@"Native: setRedirectUrl = %@", [NSString stringWithUTF8String:redirectUrl]);
    
    [[MobileAppTracker sharedManager] setRedirectUrl:[NSString stringWithUTF8String:redirectUrl]];
}

void MATSetAppleAdvertisingIdentifier_platform(const char* advertiserId)
{
    NSLog(@"Native: setAppleAdvertisingIdentifier: %@", [NSString stringWithUTF8String:advertiserId]);
    
    [[MobileAppTracker sharedManager] setAppleAdvertisingIdentifier:[[NSUUID alloc] initWithUUIDString:[NSString stringWithUTF8String:advertiserId]] ];
}

void MATSetAppleVendorIdentifier_platform(const char* vendorId)
{
    NSLog(@"Native: setAppleVendorIdentifier: %@", [NSString stringWithUTF8String:vendorId]);
    
    [[MobileAppTracker sharedManager] setAppleVendorIdentifier:[[NSUUID alloc] initWithUUIDString:[NSString stringWithUTF8String:vendorId]] ];
}

void MATStartAppToAppTracking_platform(const char *targetAppId, const char *advertiserId, const char *offerId, const char *publisherId, bool shouldRedirect)
{
    NSLog(@"Native: startAppToAppTracking: %@, %@, %@, %@, %d",
          [NSString stringWithUTF8String:targetAppId],
          [NSString stringWithUTF8String:advertiserId],
          [NSString stringWithUTF8String:offerId],
          [NSString stringWithUTF8String:publisherId],
          shouldRedirect);

    [[MobileAppTracker sharedManager] setTracking:[NSString stringWithUTF8String:targetAppId]
                                     advertiserId:[NSString stringWithUTF8String:advertiserId]
                                          offerId:[NSString stringWithUTF8String:offerId]
                                      publisherId:[NSString stringWithUTF8String:publisherId]
                                         redirect:(BOOL)shouldRedirect];
}
