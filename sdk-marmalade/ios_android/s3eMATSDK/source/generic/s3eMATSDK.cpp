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
    return s3eMATSDKInit_platform();
}


void s3eMATSDKTerminate()
{
    //Add any generic termination code here
    s3eMATSDKTerminate_platform();
}

void s3eStartMobileAppTracker(const char* adId, const char* adKey)
{
	s3eStartMobileAppTracker_platform(adId, adKey);
}

void s3eSDKParameters()
{
	s3eSDKParameters_platform();
}

void s3eTrackInstall()
{
	s3eTrackInstall_platform();
}

void s3eTrackUpdate()
{
	s3eTrackUpdate_platform();
}

void s3eTrackInstallWithReferenceId(const char* refId)
{
	s3eTrackInstallWithReferenceId_platform(refId);
}

void s3eTrackActionForEventIdOrName(const char* eventIdOrName, bool isId, const char* refId)
{
	s3eTrackActionForEventIdOrName_platform(eventIdOrName, isId, refId);
}

void s3eTrackActionForEventIdOrNameItems(const char* eventIdOrName, bool isId, const s3eMATArray* items, const char* refId, double revenueAmount, const char* currencyCode, uint8 transactionState)
{
	s3eTrackActionForEventIdOrNameItems_platform(eventIdOrName, isId, items, refId, revenueAmount, currencyCode, transactionState);
}

void s3eTrackAction(const char* eventIdOrName, bool isId, double revenue, const char*  currency)
{
    s3eTrackAction_platform(eventIdOrName, isId, revenue, currency);
}

void s3eStartAppToAppTracking(const char* targetAppId, const char* advertiserId, const char* offerId, const char* publisherId, bool shouldRedirect)
{
    s3eStartAppToAppTracking_platform(targetAppId, advertiserId, offerId, publisherId, shouldRedirect);
}

void s3eSetPackageName(const char* packageName)
{
    s3eSetPackageName_platform(packageName);
}

void s3eSetCurrencyCode(const char* currencyCode)
{
    s3eSetCurrencyCode_platform(currencyCode);
}

void s3eSetDeviceId(const char* deviceId)
{
    s3eSetDeviceId_platform(deviceId);
}

void s3eSetOpenUDID(const char* openUDID)
{
    s3eSetOpenUDID_platform(openUDID);
}

void s3eSetUserId(const char* userId)
{
    s3eSetUserId_platform(userId);
}

void s3eSetRevenue(double revenue)
{
    s3eSetRevenue_platform(revenue);
}

void s3eSetSiteId(const char* siteId)
{
    s3eSetSiteId_platform(siteId);
}

void s3eSetTRUSTeId(const char* tpid)
{
    s3eSetTRUSTeId_platform(tpid);
}

void s3eSetDelegate(bool enable)
{
    s3eSetDelegate_platform(enable);
}

void s3eSetDebugResponse(bool shouldDebug)
{
    s3eSetDebugResponse_platform(shouldDebug);
}

void s3eSetAllowDuplicates(bool allowDuplicates)
{
    s3eSetAllowDuplicates_platform(allowDuplicates);
}

void s3eSetShouldAutoGenerateMacAddress(bool shouldAutoGenerate)
{
    s3eSetShouldAutoGenerateMacAddress_platform(shouldAutoGenerate);
}

void s3eSetShouldAutoGenerateODIN1Key(bool shouldAutoGenerate)
{
    s3eSetShouldAutoGenerateODIN1Key_platform(shouldAutoGenerate);
}

void s3eSetShouldAutoGenerateOpenUDIDKey(bool shouldAutoGenerate)
{
    s3eSetShouldAutoGenerateOpenUDIDKey_platform(shouldAutoGenerate);
}

void s3eSetShouldAutoGenerateVendorIdentifier(bool shouldAutoGenerate)
{
    s3eSetShouldAutoGenerateVendorIdentifier_platform(shouldAutoGenerate);
}

void s3eSetShouldAutoGenerateAdvertiserIdentifier(bool shouldAutoGenerate)
{
    s3eSetShouldAutoGenerateAdvertiserIdentifier_platform(shouldAutoGenerate);
}

void s3eSetUseCookieTracking(bool useCookieTracking)
{
    s3eSetUseCookieTracking_platform(useCookieTracking);
}

void s3eSetRedirectUrl(const char* redirectUrl)
{
   s3eSetRedirectUrl_platform(redirectUrl);
}

void s3eSetAdvertiserIdentifier(const char* advertiserId)
{
    s3eSetAdvertiserIdentifier_platform(advertiserId);
}

void s3eSetVendorIdentifier(const char* vendorId)
{
    s3eSetVendorIdentifier_platform(vendorId);
}

void s3eSetUseHTTPS(bool useHTTPS)
{
    s3eSetUseHTTPS_platform(useHTTPS);
}
