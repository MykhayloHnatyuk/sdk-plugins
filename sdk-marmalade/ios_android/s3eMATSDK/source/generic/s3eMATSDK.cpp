/*
Generic implementation of the s3eMATSDK extension.
This file should perform any platform-indepedentent functionality
(e.g. error checking) before calling platform-dependent implementations.
*/

/*
 * NOTE: This file was originally written by the extension builder, but will not
 * be overwritten (unless --force is specified) and is intended to be modified.
 */


#include "s3eMATSDK_internal.h"

s3eResult s3eMATSDKInit()
{
    //Add any generic initialisation code here
    return MATSDKInit_platform();
}


void s3eMATSDKTerminate()
{
    //Add any generic termination code here
    MATSDKTerminate_platform();
}

void MATStartMobileAppTracker(const char* adId, const char* convKey)
{
	MATStartMobileAppTracker_platform(adId, convKey);
}

void MATSDKParameters()
{
	MATSDKParameters_platform();
}

void MATTrackInstall()
{
	MATTrackInstall_platform();
}

void MATTrackUpdate()
{
	MATTrackUpdate_platform();
}

void MATTrackInstallWithReferenceId(const char* refId)
{
	MATTrackInstallWithReferenceId_platform(refId);
}

void MATTrackActionForEventIdOrName(const char* eventIdOrName, bool isId, const char* refId)
{
	MATTrackActionForEventIdOrName_platform(eventIdOrName, isId, refId);
}

void MATTrackActionForEventIdOrNameItems(const char* eventIdOrName, bool isId, const MATArray* items, const char* refId, double revenueAmount, const char* currencyCode, uint8 transactionState)
{
	MATTrackActionForEventIdOrNameItems_platform(eventIdOrName, isId, items, refId, revenueAmount, currencyCode, transactionState);
}

void MATTrackAction(const char* eventIdOrName, bool isId, double revenue, const char*  currency)
{
    MATTrackAction_platform(eventIdOrName, isId, revenue, currency);
}

void MATStartAppToAppTracking(const char* targetAppId, const char* advertiserId, const char* offerId, const char* publisherId, bool shouldRedirect)
{
    MATStartAppToAppTracking_platform(targetAppId, advertiserId, offerId, publisherId, shouldRedirect);
}

void MATSetPackageName(const char* packageName)
{
    MATSetPackageName_platform(packageName);
}

void MATSetCurrencyCode(const char* currencyCode)
{
    MATSetCurrencyCode_platform(currencyCode);
}

void MATSetJailbroken(bool isJailbroken)
{
    MATSetJailbroken_platform(isJailbroken);
}

void MATSetOpenUDID(const char* openUDID)
{
    MATSetOpenUDID_platform(openUDID);
}

void MATSetUserId(const char* userId)
{
    MATSetUserId_platform(userId);
}

void MATSetRevenue(double revenue)
{
    MATSetRevenue_platform(revenue);
}

void MATSetSiteId(const char* siteId)
{
    MATSetSiteId_platform(siteId);
}

void MATSetTRUSTeId(const char* tpid)
{
    MATSetTRUSTeId_platform(tpid);
}

void MATSetDelegate(bool enable)
{
    MATSetDelegate_platform(enable);
}

void MATSetDebugMode(bool shouldDebug)
{
    MATSetDebugMode_platform(shouldDebug);
}

void MATSetAllowDuplicates(bool allowDuplicates)
{
    MATSetAllowDuplicates_platform(allowDuplicates);
}

void MATSetShouldAutoDetectJailbroken(bool shouldAutoDetect)
{
    MATSetShouldAutoDetectJailbroken_platform(shouldAutoDetect);
}

void MATSetShouldAutoGenerateMacAddress(bool shouldAutoGenerate)
{
    MATSetShouldAutoGenerateMacAddress_platform(shouldAutoGenerate);
}

void MATSetShouldAutoGenerateODIN1Key(bool shouldAutoGenerate)
{
    MATSetShouldAutoGenerateODIN1Key_platform(shouldAutoGenerate);
}

void MATSetShouldAutoGenerateOpenUDIDKey(bool shouldAutoGenerate)
{
    MATSetShouldAutoGenerateOpenUDIDKey_platform(shouldAutoGenerate);
}

void MATSetShouldAutoGenerateAppleVendorIdentifier(bool shouldAutoGenerate)
{
    MATSetShouldAutoGenerateAppleVendorIdentifier_platform(shouldAutoGenerate);
}

void MATSetShouldAutoGenerateAppleAdvertisingIdentifier(bool shouldAutoGenerate)
{
    MATSetShouldAutoGenerateAppleAdvertisingIdentifier_platform(shouldAutoGenerate);
}

void MATSetUseCookieTracking(bool useCookieTracking)
{
    MATSetUseCookieTracking_platform(useCookieTracking);
}

void MATSetRedirectUrl(const char* redirectUrl)
{
   MATSetRedirectUrl_platform(redirectUrl);
}

void MATSetAppleAdvertisingIdentifier(const char* appleAdvertisingId)
{
    MATSetAppleAdvertisingIdentifier_platform(appleAdvertisingId);
}

void MATSetAppleVendorIdentifier(const char* vendorId)
{
    MATSetAppleVendorIdentifier_platform(vendorId);
}

void MATSetUseHTTPS(bool useHTTPS)
{
    MATSetUseHTTPS_platform(useHTTPS);
}

void MATSetAge(int age)
{
    MATSetAge_platform(age);
}

void MATSetGender(int gender)
{
    MATSetGender_platform(gender);
}

void MATSetLocation(double latitude, double longitude, double altitude)
{
    MATSetLocation_platform(latitude, longitude, altitude);
}