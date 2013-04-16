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

void MATStartMobileAppTracker_platform(const char* adId, const char* adKey)
{
    NSLog(@"Starting MAT");
	NSString* aid = [NSString stringWithUTF8String:adId];
	NSString* akey = [NSString stringWithUTF8String:adKey];
	[[MobileAppTracker sharedManager] startTrackerWithAdvertiserId:aid advertiserKey:akey withError:NULL];
}

void MATSDKParameters_platform()
{
    NSLog(@"get parameters");
    NSDictionary *dict = [[MobileAppTracker sharedManager] sdkDataParameters];
    NSLog(@"parameters=%@", dict);
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

void MATTrackActionForEventIdOrNameItems_platform(const char* eventIdOrName, bool isId, const MATArray* items, const char* refId, double revenueAmount, const char* currencyCode, uint8 transactionState)
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
        NSLog(@"Item %s, unitPrice %f, quanity %i, revenue %f",
                            ((MATSDKEventItem*)items->m_items)[i].item,
                            ((MATSDKEventItem*)items->m_items)[i].unitPrice,
                            ((MATSDKEventItem*)items->m_items)[i].quantity,
                            ((MATSDKEventItem*)items->m_items)[i].revenue);
    }
    // reformat the items array as an nsarray of dictionary
    NSMutableArray *array = [NSMutableArray array];
    for (uint i=0; i < items->m_count; i++)
    {
        NSString *item = [NSString stringWithUTF8String:((MATSDKEventItem*)items->m_items)[i].item];
        NSNumber *unitPrice = [NSNumber numberWithDouble:((MATSDKEventItem*)items->m_items)[i].unitPrice];
        NSNumber *quantity = [NSNumber numberWithInt:((MATSDKEventItem*)items->m_items)[i].quantity];
        NSNumber *revenue = [NSNumber numberWithDouble:((MATSDKEventItem*)items->m_items)[i].revenue];
        
        NSDictionary *dict = [[[NSDictionary alloc]initWithObjectsAndKeys:item, @"item",
                              unitPrice, @"unit_price",
                              quantity, @"quantity",
                              revenue, @"revenue", nil] autorelease];
        [array addObject:dict];
    }
    MATSDKDelegate *delegate = [[MATSDKDelegate alloc]init];
    [[MobileAppTracker sharedManager] setDelegate:delegate];
    [[MobileAppTracker sharedManager] trackActionForEventIdOrName:[NSString stringWithUTF8String:eventIdOrName]
                                                        eventIsId:isId
                                                       eventItems:array
                                                      referenceId:[NSString stringWithUTF8String:refId]
                                                    revenueAmount:revenueAmount
                                                     currencyCode:[NSString stringWithUTF8String:currencyCode]
                                                 transactionState:(int)transactionState];
}

void MATSetPackageName_platform(const char* packageName)
{
    [[MobileAppTracker sharedManager] setPackageName:[NSString stringWithUTF8String:packageName]];
}

void MATSetCurrencyCode_platform(const char* currencyCode)
{
    [[MobileAppTracker sharedManager] setCurrencyCode:[NSString stringWithUTF8String:currencyCode]];
}

void MATSetDeviceId_platform(const char* deviceId)
{
    [[MobileAppTracker sharedManager] setDeviceId:[NSString stringWithUTF8String:deviceId]];
}

void MATSetOpenUDID_platform(const char* openUDID)
{
    [[MobileAppTracker sharedManager] setOpenUDID:[NSString stringWithUTF8String:openUDID]];
}

void MATSetUserId_platform(const char* userId)
{
    [[MobileAppTracker sharedManager] setUserId:[NSString stringWithUTF8String:userId]];
}

void MATSetRevenue_platform(double revenue)
{
    // NOT IMPLEMENTED FOR iOS
}

void MATSetSiteId_platform(const char* siteId)
{
    [[MobileAppTracker sharedManager] setSiteId:[NSString stringWithUTF8String:siteId]];
}

void MATSetTRUSTeId_platform(const char* tpid)
{
    [[MobileAppTracker sharedManager] setTrusteTPID:[NSString stringWithUTF8String:tpid]];
}

void MATSetDelegate_platform(bool enable)
{
    matDelegate = enable ? (matDelegate ? nil : [[MATSDKDelegate alloc] init]) : nil;
    
    [[MobileAppTracker sharedManager] setDelegate:matDelegate];
}

void MATSetDebugResponse_platform(bool shouldDebug)
{
    [[MobileAppTracker sharedManager] setShouldDebugResponseFromServer:shouldDebug];
}

void MATSetAllowDuplicates_platform(bool allowDuplicates)
{
    NSLog(@"Native: setAllowDuplicates");
    
    [[MobileAppTracker sharedManager] setShouldAllowDuplicateRequests:allowDuplicates];
}

void MATSetShouldAutoGenerateMacAddress_platform(bool shouldAutoGenerate)
{
    NSLog(@"Native: setShouldAutoGenerateMacAddress");
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateMacAddress:shouldAutoGenerate];
}

void MATSetShouldAutoGenerateODIN1Key_platform(bool shouldAutoGenerate)
{
    NSLog(@"Native: setShouldAutoGenerateODIN1Key");
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateODIN1Key:shouldAutoGenerate];
}

void MATSetShouldAutoGenerateOpenUDIDKey_platform(bool shouldAutoGenerate)
{
    NSLog(@"Native: setShouldAutoGenerateOpenUDIDKey");
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateOpenUDIDKey:shouldAutoGenerate];
}

void MATSetShouldAutoGenerateVendorIdentifier_platform(bool shouldAutoGenerate)
{
    NSLog(@"Native: setShouldAutoGenerateVendorIdentifier");
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateVendorIdentifier:shouldAutoGenerate];
}

void MATSetShouldAutoGenerateAdvertiserIdentifier_platform(bool shouldAutoGenerate)
{
    NSLog(@"Native: setShouldAutoGenerateAdvertiserIdentifier");
    
    [[MobileAppTracker sharedManager] setShouldAutoGenerateAdvertiserIdentifier:shouldAutoGenerate];
}
void MATSetUseCookieTracking_platform(bool useCookieTracking)
{
    NSLog(@"Native: setUseCookieTracking");
    
    [[MobileAppTracker sharedManager] setUseCookieTracking:useCookieTracking];
}

void MATSetUseHTTPS_platform(bool useHTTPS)
{
    NSLog(@"Native: setUseHTTPS");
    
    [[MobileAppTracker sharedManager] setUseHTTPS:useHTTPS];
}

void MATSetRedirectUrl_platform(const char* redirectUrl)
{
    NSLog(@"Native: setRedirectUrl = %@", [NSString stringWithUTF8String:redirectUrl]);
    
    [[MobileAppTracker sharedManager] setRedirectUrl:[NSString stringWithUTF8String:redirectUrl]];
}

void MATSetAdvertiserIdentifier_platform(const char* advertiserId)
{
    NSLog(@"Native: setAdvertiserIdentifier: %@", [NSString stringWithUTF8String:advertiserId]);
    
    [[MobileAppTracker sharedManager] setAdvertiserIdentifier:[[NSUUID alloc] initWithUUIDString:[NSString stringWithUTF8String:advertiserId]] ];
}

void MATSetVendorIdentifier_platform(const char* vendorId)
{
    NSLog(@"Native: setVendorIdentifier: %@", [NSString stringWithUTF8String:vendorId]);
    
    [[MobileAppTracker sharedManager] setVendorIdentifier:[[NSUUID alloc] initWithUUIDString:[NSString stringWithUTF8String:vendorId]] ];
}

void MATStartAppToAppTracking_platform(const char *targetAppId, const char *advertiserId, const char *offerId, const char *publisherId, bool shouldRedirect)
{
    NSLog(@"Native: startAppToAppTracking: %@, %@, %@, %@, %d",
          [NSString stringWithUTF8String:targetAppId],
          [NSString stringWithUTF8String:advertiserId],
          [NSString stringWithUTF8String:offerId],
          [NSString stringWithUTF8String:publisherId],
          shouldRedirect);
    
    /*
     - (void)setTracking:(NSString *)targetAppId
     advertiserId:(NSString *)advertiserId
     offerId:(NSString *)offerId
     publisherId:(NSString *)publisherId
     redirect:(BOOL)shouldRedirect;
     */
    
    [[MobileAppTracker sharedManager] setTracking:[NSString stringWithUTF8String:targetAppId]
                                     advertiserId:[NSString stringWithUTF8String:advertiserId]
                                          offerId:[NSString stringWithUTF8String:offerId]
                                      publisherId:[NSString stringWithUTF8String:publisherId]
                                         redirect:(BOOL)shouldRedirect];
}
