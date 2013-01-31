/*
 * Internal header for the s3eMATSDK extension.
 *
 * This file should be used for any common function definitions etc that need to
 * be shared between the platform-dependent and platform-indepdendent parts of
 * this extension.
 */

/*
 * NOTE: This file was originally written by the extension builder, but will not
 * be overwritten (unless --force is specified) and is intended to be modified.
 */


#ifndef S3EMATSDK_INTERNAL_H
#define S3EMATSDK_INTERNAL_H

#include "s3eTypes.h"
#include "s3eMATSDK.h"
#include "s3eMATSDK_autodefs.h"


/**
 * Initialise the extension.  This is called once then the extension is first
 * accessed by s3eregister.  If this function returns S3E_RESULT_ERROR the
 * extension will be reported as not-existing on the device.
 */
s3eResult s3eMATSDKInit();

/**
 * Platform-specific initialisation, implemented on each platform
 */
s3eResult s3eMATSDKInit_platform();

/**
 * Terminate the extension.  This is called once on shutdown, but only if the
 * extension was loader and Init() was successful.
 */
void s3eMATSDKTerminate();

/**
 * Platform-specific termination, implemented on each platform
 */
void s3eMATSDKTerminate_platform();
void s3eStartMobileAppTracker_platform(const char* adId, const char* adKey);

void s3eSDKParameters_platform();

void s3eTrackInstall_platform();

void s3eTrackUpdate_platform();

void s3eTrackInstallWithReferenceId_platform(const char* refId);

void s3eTrackActionForEventIdOrName_platform(const char* eventIdOrName, bool isId, const char* refId);

void s3eTrackActionForEventIdOrNameItems_platform(const char* eventIdOrName, bool isId, const s3eMATArray* items, const char* refId, double revenueAmount, const char* currencyCode, uint8 transactionState);

void s3eTrackAction_platform(const char* action, bool isId, double revenue, const char*  currency);

void s3eStartAppToAppTracking_platform(const char *targetAppId, const char *advertiserId, const char *offerId, const char *publisherId, bool shouldRedirect);

void s3eSetPackageName_platform(const char* packageName);
void s3eSetCurrencyCode_platform(const char* currencyCode);
void s3eSetDeviceId_platform(const char* deviceId);
void s3eSetOpenUDID_platform(const char* openUDID);
void s3eSetUserId_platform(const char* userId);
void s3eSetRevenue_platform(double revenue);
void s3eSetSiteId_platform(const char* siteId);
void s3eSetTRUSTeId_platform(const char* tpid);
void s3eSetDelegate_platform(bool enable);
void s3eSetDebugResponse_platform(bool shouldDebug);

void s3eSetAllowDuplicates_platform(bool allowDuplicates);
void s3eSetShouldAutoGenerateMacAddress_platform(bool shouldAutoGenerate);
void s3eSetShouldAutoGenerateODIN1Key_platform(bool shouldAutoGenerate);
void s3eSetShouldAutoGenerateOpenUDIDKey_platform(bool shouldAutoGenerate);
void s3eSetShouldAutoGenerateVendorIdentifier_platform(bool shouldAutoGenerate);
void s3eSetShouldAutoGenerateAdvertiserIdentifier_platform(bool shouldAutoGenerate);
void s3eSetUseCookieTracking_platform(bool useCookieTracking);
void s3eSetRedirectUrl_platform(const char* redirectUrl);
void s3eSetAdvertiserIdentifier_platform(const char* advertiserId);
void s3eSetVendorIdentifier_platform(const char* vendorId);
void s3eSetUseHTTPS_platform(bool useHTTPS);

#endif /* !S3EMATSDK_INTERNAL_H */