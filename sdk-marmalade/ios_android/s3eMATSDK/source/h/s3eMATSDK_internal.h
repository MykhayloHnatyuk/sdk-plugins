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
s3eResult MATSDKInit_platform();

/**
 * Terminate the extension.  This is called once on shutdown, but only if the
 * extension was loader and Init() was successful.
 */
void s3eMATSDKTerminate();

/**
 * Platform-specific termination, implemented on each platform
 */
void MATSDKTerminate_platform();
void MATStartMobileAppTracker_platform(const char* adId, const char* adKey);

void MATSDKParameters_platform();

void MATTrackInstall_platform();

void MATTrackUpdate_platform();

void MATTrackInstallWithReferenceId_platform(const char* refId);

void MATTrackActionForEventIdOrName_platform(const char* eventIdOrName, bool isId, const char* refId);

void MATTrackActionForEventIdOrNameItems_platform(const char* eventIdOrName, bool isId, const MATArray* items, const char* refId, double revenueAmount, const char* currencyCode, uint8 transactionState);

void MATTrackAction_platform(const char* action, bool isId, double revenue, const char*  currency);

void MATStartAppToAppTracking_platform(const char *targetAppId, const char *advertiserId, const char *offerId, const char *publisherId, bool shouldRedirect);

void MATSetPackageName_platform(const char* packageName);
void MATSetCurrencyCode_platform(const char* currencyCode);
void MATSetDeviceId_platform(const char* deviceId);
void MATSetOpenUDID_platform(const char* openUDID);
void MATSetUserId_platform(const char* userId);
void MATSetRevenue_platform(double revenue);
void MATSetSiteId_platform(const char* siteId);
void MATSetTRUSTeId_platform(const char* tpid);
void MATSetDelegate_platform(bool enable);
void MATSetDebugResponse_platform(bool shouldDebug);

void MATSetAllowDuplicates_platform(bool allowDuplicates);
void MATSetShouldAutoGenerateMacAddress_platform(bool shouldAutoGenerate);
void MATSetShouldAutoGenerateODIN1Key_platform(bool shouldAutoGenerate);
void MATSetShouldAutoGenerateOpenUDIDKey_platform(bool shouldAutoGenerate);
void MATSetShouldAutoGenerateVendorIdentifier_platform(bool shouldAutoGenerate);
void MATSetShouldAutoGenerateAdvertiserIdentifier_platform(bool shouldAutoGenerate);
void MATSetUseCookieTracking_platform(bool useCookieTracking);
void MATSetRedirectUrl_platform(const char* redirectUrl);
void MATSetAdvertiserIdentifier_platform(const char* advertiserId);
void MATSetVendorIdentifier_platform(const char* vendorId);
void MATSetUseHTTPS_platform(bool useHTTPS);

#endif /* !S3EMATSDK_INTERNAL_H */
