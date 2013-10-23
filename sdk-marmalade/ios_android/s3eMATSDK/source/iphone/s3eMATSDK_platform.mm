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
    NSLog(@"Native: Starting MAT");
    
    if(NULL != adId && NULL != convKey)
    {
        NSString *aid = [NSString stringWithUTF8String:adId];
        NSString *ckey = [NSString stringWithUTF8String:convKey];
        [[MobileAppTracker sharedManager] startTrackerWithMATAdvertiserId:aid MATConversionKey:ckey];
    }
    else
    {
        NSLog(@"MAT Error! MAT Advertiser ID and MAT Conversion Key cannot be NULL.");
    }
}

void MATSDKParameters_platform()
{
    NSDictionary *dict = [[MobileAppTracker sharedManager] sdkDataParameters];
    NSLog(@"Native: get SDK data parameters = %@", dict);
}

void MATTrackInstall_platform()
{
    NSLog(@"Native: trackInstall");
    [[MobileAppTracker sharedManager] trackInstall];
}

void MATTrackUpdate_platform()
{
    NSLog(@"Native: trackUdpate");
    [[MobileAppTracker sharedManager] trackUpdate];
}

void MATTrackInstallWithReferenceId_platform(const char* refId)
{
    NSString *strRefId = NULL == refId ? nil : [NSString stringWithUTF8String:refId];
    
    NSLog(@"Native: trackInstallWithRef: %@", strRefId);
    [[MobileAppTracker sharedManager] trackInstallWithReferenceId:strRefId];
}

void MATTrackActionForEventIdOrName_platform(const char* eventIdOrName, bool isId, const char* refId)
{
    NSLog(@"Native: MATTrackActionForEventIdOrName");
    
    NSString *strEventIdOrName = NULL == eventIdOrName ? nil : [NSString stringWithUTF8String:eventIdOrName];
    NSString *strRefId = NULL == refId ? nil : [NSString stringWithUTF8String:refId];
    
    [[MobileAppTracker sharedManager] trackActionForEventIdOrName:strEventIdOrName eventIsId:isId referenceId:strRefId];
}

void MATTrackAction_platform(const char* eventIdOrName, bool isId, const char* revenue, const char*  currencyCode)
{
    NSLog(@"Native: MATTrackAction");
    
    NSString *strEventIdOrName = NULL == eventIdOrName ? nil : [NSString stringWithUTF8String:eventIdOrName];
    
    NSString *strRevenue = NULL == revenue ? nil : [NSString stringWithUTF8String:revenue];
    
    NSString *strCurrencyCode = NULL == currencyCode ? nil : [NSString stringWithUTF8String:currencyCode];

    [[MobileAppTracker sharedManager] trackActionForEventIdOrName:strEventIdOrName
                                                        eventIsId:isId
                                                    revenueAmount:[strRevenue floatValue]
                                                     currencyCode:strCurrencyCode];
}

void MATTrackActionForEventIdOrNameItems_platform(const char* eventIdOrName, bool isId, const MATArray* items, const char* refId, const char* revenueAmount, const char* currencyCode, uint8 transactionState, const char* receipt, const char* receiptSignature)
{
    NSString *strEventIdOrName = NULL == eventIdOrName ? nil : [NSString stringWithUTF8String:eventIdOrName];
    NSString *strRefId = NULL == refId ? nil : [NSString stringWithUTF8String:refId];
    NSString *strRevenueAmount = NULL == revenueAmount ? nil : [NSString stringWithUTF8String:revenueAmount];
    NSString *strCurrencyCode = NULL == currencyCode ? nil : [NSString stringWithUTF8String:currencyCode];
    NSString *strReceipt = NULL == receipt ? nil : [NSString stringWithUTF8String:receipt];
    // iOS does not use the receiptSignature param, it's only for Android.
    
    NSLog(@"Native: trackActionForEventIdOrNameItems");
    NSLog(@"eventName        = %@", strEventIdOrName);
    NSLog(@"refId            = %@", strRefId);
    NSLog(@"revenueAmount    = %@", strRevenueAmount);
    NSLog(@"transactionState = %i", (unsigned int)transactionState);
    NSLog(@"currCode         = %@", strCurrencyCode);
    NSLog(@"receipt          = %@", strReceipt);
    
    // print the items array
    NSLog(@"MATSDK events array: %i", items->m_count);
    for (uint i=0; i < items->m_count; i++)
    {
        NSLog(@"Item name = %s, unitPrice = %s, quantity = %i, revenue = %s, attribute1 = %s, attribute2 = %s, attribute3 = %s, attribute4 = %s, attribute5 = %s",
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
    
    // create an NSArray of MATEventItem objects
    NSMutableArray *array = [NSMutableArray array];
    for (uint i=0; i < items->m_count; i++)
    {
        NSString *name = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].name];
        
        NSString *strUnitPrice = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].unitPrice];
        int quantity = ((MATSDKEventItem*)items->m_items)[i].quantity;
        NSString *strRevenue = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].revenue];
        
        NSString *attribute1 = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].attribute1];
        NSString *attribute2 = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].attribute2];
        NSString *attribute3 = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].attribute3];
        NSString *attribute4 = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].attribute4];
        NSString *attribute5 = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].attribute5];
        
        MATEventItem *item = [MATEventItem eventItemWithName:name unitPrice:[strUnitPrice floatValue] quantity:quantity revenue:[strRevenue floatValue] attribute1:attribute1 attribute2:attribute2 attribute3:attribute3 attribute4:attribute4 attribute5:attribute5];
        
        [array addObject:item];
    }
    
    MATSDKDelegate *delegate = [[MATSDKDelegate alloc]init];
    [[MobileAppTracker sharedManager] setDelegate:delegate];
    [[MobileAppTracker sharedManager] trackActionForEventIdOrName:strEventIdOrName
                                                        eventIsId:isId
                                                       eventItems:array
                                                      referenceId:strRefId
                                                    revenueAmount:[strRevenueAmount floatValue]
                                                     currencyCode:strCurrencyCode
                                                 transactionState:(int)transactionState
                                                          receipt:[strReceipt dataUsingEncoding:NSUTF8StringEncoding]];
}

void MATSetPackageName_platform(const char* packageName)
{
    NSLog(@"Native: setPackageName = %s", packageName);
    
    NSString *strPackageName = NULL == packageName ? nil : [NSString stringWithUTF8String:packageName];
    
    [[MobileAppTracker sharedManager] setPackageName:strPackageName];
}

void MATSetCurrencyCode_platform(const char* currencyCode)
{
    NSLog(@"Native: setCurrencyCode = %s", currencyCode);
    
    NSString *strCurrencyCode = NULL == currencyCode ? nil : [NSString stringWithUTF8String:currencyCode];
    
    [[MobileAppTracker sharedManager] setCurrencyCode:strCurrencyCode];
}

void MATSetUserId_platform(const char* userId)
{
    NSLog(@"Native: setUserId = %s", userId);
    
    NSString *strUserId = NULL == userId ? nil : [NSString stringWithUTF8String:userId];
    
    [[MobileAppTracker sharedManager] setUserId:strUserId];
}

void MATSetRevenue_platform(const char* revenue)
{
    // NOT IMPLEMENTED FOR iOS
}

void MATSetSiteId_platform(const char* siteId)
{
    NSLog(@"Native: setSiteId = %s", siteId);
    
    NSString *strSiteId = NULL == siteId ? nil : [NSString stringWithUTF8String:siteId];
    
    [[MobileAppTracker sharedManager] setSiteId:strSiteId];
}

void MATSetTRUSTeId_platform(const char* tpid)
{
    NSLog(@"Native: setTRUSTeId = %s", tpid);
    
    NSString *strTpid = NULL == tpid ? nil : [NSString stringWithUTF8String:tpid];
    
    [[MobileAppTracker sharedManager] setTrusteTPID:strTpid];
}

void MATSetDelegate_platform(bool enable)
{
    matDelegate = enable ? (matDelegate ? matDelegate : [[MATSDKDelegate alloc] init]) : nil;
    
    NSLog(@"Native: setDelegate = %d", enable);
    
    [[MobileAppTracker sharedManager] setDelegate:matDelegate];
}

void MATSetDebugMode_platform(bool shouldDebug)
{
    NSLog(@"Native: setDebug mode = %d", shouldDebug);
    [[MobileAppTracker sharedManager] setDebugMode:shouldDebug];
}

void MATSetAge_platform(int age)
{
    NSLog(@"Native: setAge = %d", age);
    [[MobileAppTracker sharedManager] setAge:age];
}

void MATSetGender_platform(int gender)
{
    NSLog(@"Native: setGender = %d", gender);
    
    [[MobileAppTracker sharedManager] setGender:gender];
}

void MATSetLocation_platform(const char* latitude, const char* longitude, const char* altitude)
{
	NSString *strLat = NULL == latitude ? nil : [NSString stringWithUTF8String:latitude];
	NSString *strLong = NULL == longitude ? nil : [NSString stringWithUTF8String:longitude];
	NSString *strAlt = NULL == altitude ? nil : [NSString stringWithUTF8String:altitude];
	
	NSLog(@"Native: setLocation = %@, %@, %@", strLat, strLong, strAlt);
	
    [[MobileAppTracker sharedManager] setLatitude:[strLat floatValue] longitude:[strLong floatValue] altitude:[strAlt floatValue]];
}

void MATSetAllowDuplicates_platform(bool allowDuplicates)
{
    NSLog(@"Native: setAllowDuplicates: %d", allowDuplicates);
    
    [[MobileAppTracker sharedManager] setAllowDuplicateRequests:allowDuplicates];
}

void MATSetShouldAutoDetectJailbroken_platform(bool shouldAutoDetect)
{
    NSLog(@"Native: setShouldAutoDetectJailbroken: %d", shouldAutoDetect);
    
    [[MobileAppTracker sharedManager] setShouldAutoDetectJailbroken:shouldAutoDetect];
}

void MATSetMACAddress_platform(const char* mac)
{
    NSString *strMac = NULL == mac ? nil : [NSString stringWithUTF8String:mac];
    
    NSLog(@"Native: setMacAddress = %@", strMac);
    
    [[MobileAppTracker sharedManager] setMACAddress:strMac];
}

void MATSetODIN1_platform(const char* odin1)
{
    NSString *strOdin1 = NULL == odin1 ? nil : [NSString stringWithUTF8String:odin1];
    
    NSLog(@"Native: setODIN1: %@", strOdin1);
    
    [[MobileAppTracker sharedManager] setODIN1:strOdin1];
}

void MATSetUIID_platform(const char* uiid)
{
    NSString *strUiid = NULL == uiid ? nil : [NSString stringWithUTF8String:uiid];
    
    NSLog(@"Native: setUIID = %@", strUiid);
    
    [[MobileAppTracker sharedManager] setUIID:strUiid];
}

void MATSetOpenUDID_platform(const char* openUDID)
{
    NSString *strOpenUDID = NULL == openUDID ? nil : [NSString stringWithUTF8String:openUDID];
    
    NSLog(@"Native: setOpenUDID = %@", strOpenUDID);
    
    [[MobileAppTracker sharedManager] setOpenUDID:strOpenUDID];
}

void MATSetShouldAutoGenerateAppleVendorIdentifier_platform(bool shouldAutoGenerate)
{
    NSLog(@"Native: setShouldAutoGenerateAppleVendorIdentifier: %d", shouldAutoGenerate);
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateAppleVendorIdentifier:shouldAutoGenerate];
}

void MATSetShouldAutoGenerateAppleAdvertisingIdentifier_platform(bool shouldAutoGenerate)
{
    NSLog(@"Native: setShouldAutoGenerateAppleAdvertisingIdentifier: %d", shouldAutoGenerate);
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateAppleAdvertisingIdentifier:shouldAutoGenerate];
}

void MATSetUseCookieTracking_platform(bool useCookieTracking)
{
    NSLog(@"Native: setUseCookieTracking: %d", useCookieTracking);
    
    [[MobileAppTracker sharedManager] setUseCookieTracking:useCookieTracking];
}

void MATSetAppAdTracking_platform(bool enable)
{
    NSLog(@"Native: setAppAdTracking: %d", enable);
    
    [[MobileAppTracker sharedManager] setAppAdTracking:enable];
}

void MATSetJailbroken_platform(bool isJailbroken)
{
    NSLog(@"Native: setJailbroken: %d", isJailbroken);
    
    [[MobileAppTracker sharedManager] setJailbroken:isJailbroken];
}

void MATSetRedirectUrl_platform(const char* redirectUrl)
{
    NSString *strRedirectUrl = NULL == redirectUrl ? nil : [NSString stringWithUTF8String:redirectUrl];
    
    NSLog(@"Native: setRedirectUrl = %@", strRedirectUrl);
    
    [[MobileAppTracker sharedManager] setRedirectUrl:strRedirectUrl];
}

void MATSetAppleAdvertisingIdentifier_platform(const char* advertiserId)
{
    NSString *strAdvertiserId = NULL == advertiserId ? nil : [NSString stringWithUTF8String:advertiserId];
    
    NSLog(@"Native: setAppleAdvertisingIdentifier: %@", strAdvertiserId);
    
    id classNSUUID = NSClassFromString(@"NSUUID");
    
    if(classNSUUID)
    {
        [[MobileAppTracker sharedManager] setAppleAdvertisingIdentifier:[[classNSUUID alloc] initWithUUIDString:strAdvertiserId]];
    }
}

void MATSetAppleVendorIdentifier_platform(const char* vendorId)
{
    NSString *strVendorId = NULL == vendorId ? nil : [NSString stringWithUTF8String:vendorId];
    
    NSLog(@"Native: setAppleVendorIdentifier: %@", vendorId);
    
    id classNSUUID = NSClassFromString(@"NSUUID");
    
    if(classNSUUID)
    {
        [[MobileAppTracker sharedManager] setAppleVendorIdentifier:[[classNSUUID alloc] initWithUUIDString:strVendorId] ];
    }
}

void MATStartAppToAppTracking_platform(const char* targetAppId, const char* advertiserId, const char* offerId, const char* publisherId, bool shouldRedirect)
{
    NSString *strTargetAppId = NULL == targetAppId ? nil : [NSString stringWithUTF8String:targetAppId];
    NSString *strAdvertiserId = NULL == advertiserId ? nil : [NSString stringWithUTF8String:advertiserId];
    NSString *strOfferId = NULL == offerId ? nil : [NSString stringWithUTF8String:offerId];
    NSString *strPublisherId = NULL == publisherId ? nil : [NSString stringWithUTF8String:publisherId];
    
    NSLog(@"Native: startAppToAppTracking: %@, %@, %@, %@, %d",
          strTargetAppId, strAdvertiserId, strOfferId, strPublisherId, shouldRedirect);

    [[MobileAppTracker sharedManager] setTracking:[NSString stringWithUTF8String:targetAppId]
                                     advertiserId:[NSString stringWithUTF8String:advertiserId]
                                          offerId:[NSString stringWithUTF8String:offerId]
                                      publisherId:[NSString stringWithUTF8String:publisherId]
                                         redirect:(BOOL)shouldRedirect];
}
