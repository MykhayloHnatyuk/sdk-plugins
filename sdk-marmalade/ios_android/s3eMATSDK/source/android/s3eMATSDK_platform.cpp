/*
 * android-specific implementation of the s3eMATSDK extension.
 * Add any platform-specific functionality here.
 */
/*
 * NOTE: This file was originally written by the extension builder, but will not
 * be overwritten (unless --force is specified) and is intended to be modified.
 */
#include "s3eMATSDK_internal.h"

#include "s3eEdk.h"
#include "s3eEdk_android.h"
#include <jni.h>
#include "IwDebug.h"
#include <android/log.h>

static jobject g_Obj;
static jmethodID g_s3eStartMobileAppTracker;
static jmethodID g_s3eSDKParameters;
static jmethodID g_s3etrackInstall;
static jmethodID g_s3etrackUpdate;
static jmethodID g_s3etrackInstallWithReferenceId;
static jmethodID g_s3etrackActionForEventIdOrName;
static jmethodID g_s3etrackActionForEventIdOrNameItems;
static jmethodID g_s3etrackAction;
static jmethodID g_s3eSetPackageName;
static jmethodID g_s3eStartAppToAppTracking;

static jmethodID g_s3eSetCurrencyCode;
static jmethodID g_s3eSetDeviceId;
static jmethodID g_s3eSetOpenUDID;
static jmethodID g_s3eSetUserId;
static jmethodID g_s3eSetRevenue;
static jmethodID g_s3eSetSiteId;
static jmethodID g_s3eSetTRUSTeId;
static jmethodID g_s3eSetDebugResponse;

static jmethodID g_s3eSetAllowDuplicates;
static jmethodID g_s3eSetShouldAutoGenerateMacAddress;
static jmethodID g_s3eSetShouldAutoGenerateOpenUDIDKey;
static jmethodID g_s3eSetShouldAutoGenerateVendorIdentifier;
static jmethodID g_s3eSetShouldAutoGenerateAdvertiserIdentifier;
static jmethodID g_s3eSetUseCookieTracking;
static jmethodID g_s3eSetRedirectUrl;
static jmethodID g_s3eSetAdvertiserIdentifier;
static jmethodID g_s3eSetVendorIdentifier;

s3eResult s3eMATSDKInit_platform()
{
    // Get the environment from the pointer
    JNIEnv* env = s3eEdkJNIGetEnv();
    jobject obj = NULL;
    jmethodID cons = NULL;

    // Get the extension class
    jclass cls = s3eEdkAndroidFindClass("s3eMATSDK");
    if (!cls)
        goto fail;

    // Get its constructor
    cons = env->GetMethodID(cls, "<init>", "()V");
    if (!cons)
        goto fail;

    // Construct the java class
    obj = env->NewObject(cls, cons);
    if (!obj)
        goto fail;

    // Get all the extension methods
    g_s3eStartMobileAppTracker = env->GetMethodID(cls, "s3eStartMobileAppTracker", "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!g_s3eStartMobileAppTracker)
        goto fail;

    g_s3eSDKParameters = env->GetMethodID(cls, "s3eSDKParameters", "()V");
    if (!g_s3eSDKParameters)
        goto fail;

    g_s3etrackInstall = env->GetMethodID(cls, "s3eTrackInstall", "()V");
    if (!g_s3etrackInstall)
        goto fail;

    g_s3etrackUpdate = env->GetMethodID(cls, "s3eTrackUpdate", "()V");
    if (!g_s3etrackUpdate)
        goto fail;

    g_s3etrackInstallWithReferenceId = env->GetMethodID(cls, "s3eTrackInstallWithReferenceId", "(Ljava/lang/String;)V");
    if (!g_s3etrackInstallWithReferenceId)
        goto fail;

    g_s3etrackActionForEventIdOrName = env->GetMethodID(cls, "s3eTrackActionForEventIdOrName", "(Ljava/lang/String;ZLjava/lang/String;)V");
    if (!g_s3etrackActionForEventIdOrName)
        goto fail;

    g_s3etrackActionForEventIdOrNameItems = env->GetMethodID(cls, "s3eTrackActionForEventIdOrNameItems", "(Ljava/lang/String;ZLjava/util/List;Ljava/lang/String;DLjava/lang/String;I)V");
    if (!g_s3etrackActionForEventIdOrNameItems)
        goto fail;
    
    g_s3etrackAction = env->GetMethodID(cls, "s3eTrackAction", "(Ljava/lang/String;ZDLjava/lang/String;)V");
    if (!g_s3etrackAction)
        goto fail;

    g_s3eSetPackageName = env->GetMethodID(cls, "s3eSetPackageName", "(Ljava/lang/String;)V");
    if (!g_s3eSetPackageName)
        goto fail;
    
    g_s3eStartAppToAppTracking = env->GetMethodID(cls, "s3eStartAppToAppTracking", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V");
    if (!g_s3eStartAppToAppTracking)
        goto fail;
    ///////
    g_s3eSetCurrencyCode = env->GetMethodID(cls, "s3eSetCurrencyCode", "(Ljava/lang/String;)V");
    if (!g_s3eSetCurrencyCode)
        goto fail;
    g_s3eSetDeviceId = env->GetMethodID(cls, "s3eSetDeviceId", "(Ljava/lang/String;)V");
    if (!g_s3eSetDeviceId)
        goto fail;
    g_s3eSetOpenUDID = env->GetMethodID(cls, "s3eSetOpenUDID", "(Ljava/lang/String;)V");
    if (!g_s3eSetOpenUDID)
        goto fail;
    g_s3eSetUserId = env->GetMethodID(cls, "s3eSetUserId", "(Ljava/lang/String;)V");
    if (!g_s3eSetUserId)
        goto fail;
    g_s3eSetRevenue = env->GetMethodID(cls, "s3eSetRevenue", "(D)V");
    if (!g_s3eSetRevenue)
        goto fail;
    g_s3eSetSiteId = env->GetMethodID(cls, "s3eSetSiteId", "(Ljava/lang/String;)V");
    if (!g_s3eSetSiteId)
        goto fail;
    g_s3eSetTRUSTeId = env->GetMethodID(cls, "s3eSetTRUSTeId", "(Ljava/lang/String;)V");
    if (!g_s3eSetTRUSTeId)
        goto fail;
    g_s3eSetDebugResponse = env->GetMethodID(cls, "s3eSetDebugResponse", "(Z)V");
    if (!g_s3eSetDebugResponse)
        goto fail;
    //////
    IwTrace(MATSDK, ("MATSDK init success"));
    g_Obj = env->NewGlobalRef(obj);
    env->DeleteLocalRef(obj);
    env->DeleteGlobalRef(cls);

    // Add any platform-specific initialisation code here
    return S3E_RESULT_SUCCESS;

fail:
    jthrowable exc = env->ExceptionOccurred();
    if (exc)
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        IwTrace(s3eMATSDK, ("One or more java methods could not be found"));
    }
    return S3E_RESULT_ERROR;

}

void s3eMATSDKTerminate_platform()
{
    // Add any platform-specific termination code here
}

void s3eStartMobileAppTracker_platform(const char* adId, const char* adKey)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring adId_jstr = env->NewStringUTF(adId);
    jstring adKey_jstr = env->NewStringUTF(adKey);
    env->CallVoidMethod(g_Obj, g_s3eStartMobileAppTracker, adId_jstr, adKey_jstr);
    env->DeleteLocalRef(adId_jstr);
    env->DeleteLocalRef(adKey_jstr);
}

void s3eSDKParameters_platform()
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    env->CallVoidMethod(g_Obj, g_s3eSDKParameters);
}

void s3eTrackInstall_platform()
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    env->CallVoidMethod(g_Obj, g_s3etrackInstall);
}

void s3eTrackUpdate_platform()
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    env->CallVoidMethod(g_Obj, g_s3etrackUpdate);
}

void s3eTrackInstallWithReferenceId_platform(const char* refId)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring refId_jstr = env->NewStringUTF(refId);
    env->CallVoidMethod(g_Obj, g_s3etrackInstallWithReferenceId, refId_jstr);
    env->DeleteLocalRef(refId_jstr);
}

void s3eTrackActionForEventIdOrName_platform(const char* eventIdOrName, bool isId, const char* refId)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring eventIdOrName_jstr = env->NewStringUTF(eventIdOrName);
    jstring refId_jstr = env->NewStringUTF(refId);
    env->CallVoidMethod(g_Obj, g_s3etrackActionForEventIdOrName, eventIdOrName_jstr, isId, refId_jstr);
    env->DeleteLocalRef(eventIdOrName_jstr);
    env->DeleteLocalRef(refId_jstr);
}

void s3eTrackAction_platform(const char* eventIdOrName, bool isId, double revenue, const char*  currency)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring eventIdOrName_jstr = env->NewStringUTF(eventIdOrName);
    jstring currency_jstr = env->NewStringUTF(currency);
    env->CallVoidMethod(g_Obj, g_s3etrackAction, eventIdOrName_jstr, isId, revenue, currency_jstr);
    env->DeleteLocalRef(eventIdOrName_jstr);
    env->DeleteLocalRef(currency_jstr);
}

void s3eTrackActionForEventIdOrNameItems_platform(const char* eventIdOrName, bool isId, const s3eMATArray* items, const char* refId, double revenueAmount, const char* currencyCode, uint8 transactionState)
{
    IwTrace(s3eMATSDK, ("In event items method"));
    JNIEnv* jni_env = s3eEdkJNIGetEnv();
    
    // local variables for the track action
    jstring eventIdOrName_jstr = jni_env->NewStringUTF(eventIdOrName);
    jstring refId_jstr = jni_env->NewStringUTF(refId);
    jstring currencyCode_jstr = jni_env->NewStringUTF(currencyCode);
    
    // create a List class
    const char* list_class_name = "java/util/ArrayList";
    jclass clsList = jni_env->FindClass(list_class_name);
    jmethodID constructorIDList = jni_env->GetMethodID(clsList, "<init>", "()V");
    jobject jlistobj = jni_env->NewObject(clsList, constructorIDList);
    jmethodID list_add_mid = 0;
    list_add_mid = jni_env->GetMethodID(clsList, "add", "(Ljava/lang/Object;)Z");
    
    // hashmap definition
    const char* hashmap_class_name = "java/util/HashMap";
    jclass clsHashMap = jni_env->FindClass(hashmap_class_name);
    jmethodID constructorID = jni_env->GetMethodID(clsHashMap, "<init>", "()V");
    
    // add a hashmap for each item to a List
    for (uint i=0; i < items->m_count; i++) {
        IwTrace(s3eMATSDK, ("Item %s, unitPrice %f, quantity %i, revenue %f",
              ((MATSDKEventItem*)items->m_items)[i].item,
              ((MATSDKEventItem*)items->m_items)[i].unitPrice,
              ((MATSDKEventItem*)items->m_items)[i].quantity,
              ((MATSDKEventItem*)items->m_items)[i].revenue));
    
        // create a HashMap class
        jobject jmapobj = jni_env->NewObject(clsHashMap, constructorID);
        jmethodID map_put_mid = 0;
        map_put_mid = jni_env->GetMethodID(clsHashMap, "put", "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;");
        
        // item
        jstring itemArg = jni_env->NewStringUTF("item");
        jstring itemVal = jni_env->NewStringUTF(((MATSDKEventItem*)items->m_items)[i].item);
        jni_env->CallObjectMethod(jmapobj, map_put_mid, itemArg, itemVal);
        const char *str;
        str = jni_env->GetStringUTFChars(itemVal, 0);
        IwTrace(s3eMATSDK, ("item = %s", str));
        jni_env->DeleteLocalRef(itemArg);
        jni_env->DeleteLocalRef(itemVal);

        // quantity
        jstring quantityArg = jni_env->NewStringUTF("quantity");
        char qtyArray[10];
        snprintf(qtyArray, sizeof(qtyArray), "%i", ((MATSDKEventItem*)items->m_items)[i].quantity);
        jstring quantityVal = jni_env->NewStringUTF(qtyArray);
        jni_env->CallObjectMethod(jmapobj, map_put_mid, quantityArg, quantityVal);
        IwTrace(s3eMATSDK, ("quantity = %s", qtyArray));
        jni_env->DeleteLocalRef(quantityArg);
        jni_env->DeleteLocalRef(quantityVal);
        
        // revenue
        char revArr[10];
        jstring revenueArg = jni_env->NewStringUTF("revenue");
        snprintf(revArr, sizeof(revArr), "%f", ((MATSDKEventItem*)items->m_items)[i].revenue);
        jstring revenueVal = jni_env->NewStringUTF(revArr);
        jni_env->CallObjectMethod(jmapobj, map_put_mid, revenueArg, revenueVal);
        IwTrace(s3eMATSDK, ("revenue = %s", revArr));
        jni_env->DeleteLocalRef(revenueArg);
        jni_env->DeleteLocalRef(revenueVal);
        
        // unit_price
        char unitPriceArr[10];
        jstring unitPriceArg = jni_env->NewStringUTF("unit_price");
        snprintf(unitPriceArr, sizeof(unitPriceArr), "%f", ((MATSDKEventItem*)items->m_items)[i].unitPrice);
        jstring unitPriceVal = jni_env->NewStringUTF(unitPriceArr);
        jni_env->CallObjectMethod(jmapobj, map_put_mid, unitPriceArg, unitPriceVal);
        IwTrace(s3eMATSDK, ("unit_price = %s", unitPriceArr));
        jni_env->DeleteLocalRef(unitPriceArg);
        jni_env->DeleteLocalRef(unitPriceVal);

        // add the hashmap to the list
        jboolean jbool = jni_env->CallBooleanMethod(jlistobj, list_add_mid, jmapobj);
    }
    
    IwTrace(s3eMATSDK, ("calling track method with list"));
    jni_env->CallVoidMethod(g_Obj, g_s3etrackActionForEventIdOrNameItems, eventIdOrName_jstr, isId, jlistobj, refId_jstr, revenueAmount, currencyCode_jstr, transactionState);
    
    jni_env->DeleteLocalRef(eventIdOrName_jstr);
    jni_env->DeleteLocalRef(refId_jstr);
    jni_env->DeleteLocalRef(currencyCode_jstr);
}

void s3eStartAppToAppTracking_platform(const char* targetAppId, const char* advertiserId, const char* offerId, const char* publisherId, bool shouldRedirect)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    
    jstring targetAppIdUTF = env->NewStringUTF(targetAppId);
    jstring advertiserIdUTF = env->NewStringUTF(advertiserId);
    jstring offerIdUTF = env->NewStringUTF(offerId);
    jstring publisherIdUTF = env->NewStringUTF(publisherId);
    
    // Call setTracking from Android SDK
    env->CallVoidMethod(g_Obj, g_s3eStartAppToAppTracking, advertiserIdUTF, targetAppIdUTF, publisherIdUTF, offerIdUTF, shouldRedirect);
    
    env->DeleteLocalRef(targetAppIdUTF);
    env->DeleteLocalRef(advertiserIdUTF);
    env->DeleteLocalRef(offerIdUTF);
    env->DeleteLocalRef(publisherIdUTF);
    
    return;
}

// Set Methods
void s3eSetPackageName_platform(const char* packageName)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring packageName_jstr = env->NewStringUTF(packageName);
    env->CallVoidMethod(g_Obj, g_s3eSetPackageName, packageName_jstr);
    env->DeleteLocalRef(packageName_jstr);
}

void s3eSetCurrencyCode_platform(const char* currencyCode)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(currencyCode);
    env->CallVoidMethod(g_Obj, g_s3eSetCurrencyCode, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void s3eSetDeviceId_platform(const char* deviceId)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(deviceId);
    env->CallVoidMethod(g_Obj, g_s3eSetDeviceId, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void s3eSetOpenUDID_platform(const char* openUDID)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(openUDID);
    env->CallVoidMethod(g_Obj, g_s3eSetOpenUDID, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void s3eSetUserId_platform(const char* userId)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(userId);
    env->CallVoidMethod(g_Obj, g_s3eSetUserId, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void s3eSetRevenue_platform(double revenue)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    env->CallVoidMethod(g_Obj, g_s3eSetRevenue, revenue);
}
void s3eSetSiteId_platform(const char* siteId)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(siteId);
    env->CallVoidMethod(g_Obj, g_s3eSetSiteId, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void s3eSetTRUSTeId_platform(const char* tpid)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(tpid);
    env->CallVoidMethod(g_Obj, g_s3eSetTRUSTeId, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void s3eSetDebugResponse_platform(bool shouldDebug)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    env->CallVoidMethod(g_Obj, g_s3eSetDebugResponse, shouldDebug);
}

// iOS only functions that do nothing on Android

void s3eSetAdvertiserIdentifier_platform(const char* advertiserIdentifier)
{
    
}

void s3eSetAllowDuplicates_platform(bool allowDuplicates)
{
    
}

void s3eSetDelegate_platform(bool enable)
{
    
}

void s3eSetDeviceId_platform(char* deviceId)
{
    
}

void s3eSetOpenUDID_platform(char* openUdid)
{
    
}

void s3eSetRedirectUrl_platform(const char* redirectUrl)
{
    
}

void s3eSetShouldAutoGenerateAdvertiserIdentifier_platform(bool shouldAutoGenerate)
{
    
}

void s3eSetShouldAutoGenerateMacAddress_platform(bool shouldAutoGenerate)
{
    
}

void s3eSetShouldAutoGenerateODIN1Key_platform(bool shouldAutoGenerate)
{
    
}

void s3eSetShouldAutoGenerateOpenUDIDKey_platform(bool shouldAutoGenerate)
{
    
}

void s3eSetShouldAutoGenerateVendorIdentifier_platform(bool shouldAutoGenerate)
{
    
}

void s3eSetVendorIdentifier_platform(const char* vendorIdentifier)
{
    
}

void s3eSetUseCookieTracking_platform(bool useCookieTracking)
{
    
}

void s3eSetUseHTTPS_platform(bool useHTTPS)
{
    
}

