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
static jmethodID g_MATStartMobileAppTracker;
static jmethodID g_MATSDKParameters;
static jmethodID g_MATTrackInstall;
static jmethodID g_MATTrackUpdate;
static jmethodID g_MATTrackInstallWithReferenceId;
static jmethodID g_MATTrackActionForEventIdOrName;
static jmethodID g_MATTrackActionForEventIdOrNameItems;
static jmethodID g_MATTrackAction;
static jmethodID g_MATSetPackageName;
static jmethodID g_MATStartAppToAppTracking;

static jmethodID g_MATSetCurrencyCode;
static jmethodID g_MATSetDeviceId;
static jmethodID g_MATSetOpenUDID;
static jmethodID g_MATSetUserId;
static jmethodID g_MATSetRevenue;
static jmethodID g_MATSetSiteId;
static jmethodID g_MATSetTRUSTeId;
static jmethodID g_MATSetDebugResponse;

static jmethodID g_MATSetAllowDuplicates;
static jmethodID g_MATSetShouldAutoGenerateMacAddress;
static jmethodID g_MATSetShouldAutoGenerateOpenUDIDKey;
static jmethodID g_MATSetShouldAutoGenerateVendorIdentifier;
static jmethodID g_MATSetShouldAutoGenerateAdvertiserIdentifier;
static jmethodID g_MATSetUseCookieTracking;
static jmethodID g_MATSetRedirectUrl;
static jmethodID g_MATSetAdvertiserIdentifier;
static jmethodID g_MATSetVendorIdentifier;

s3eResult MATSDKInit_platform()
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
    g_MATStartMobileAppTracker = env->GetMethodID(cls, "MATStartMobileAppTracker", "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!g_MATStartMobileAppTracker)
        goto fail;

    g_MATSDKParameters = env->GetMethodID(cls, "MATSDKParameters", "()V");
    if (!g_MATSDKParameters)
        goto fail;

    g_MATTrackInstall = env->GetMethodID(cls, "MATTrackInstall", "()V");
    if (!g_MATTrackInstall)
        goto fail;

    g_MATTrackUpdate = env->GetMethodID(cls, "MATTrackUpdate", "()V");
    if (!g_MATTrackUpdate)
        goto fail;

    g_MATTrackInstallWithReferenceId = env->GetMethodID(cls, "MATTrackInstallWithReferenceId", "(Ljava/lang/String;)V");
    if (!g_MATTrackInstallWithReferenceId)
        goto fail;

    g_MATTrackActionForEventIdOrName = env->GetMethodID(cls, "MATTrackActionForEventIdOrName", "(Ljava/lang/String;ZLjava/lang/String;)V");
    if (!g_MATTrackActionForEventIdOrName)
        goto fail;

    g_MATTrackActionForEventIdOrNameItems = env->GetMethodID(cls, "MATTrackActionForEventIdOrNameItems", "(Ljava/lang/String;ZLjava/util/List;Ljava/lang/String;DLjava/lang/String;I)V");
    if (!g_MATTrackActionForEventIdOrNameItems)
        goto fail;
    
    g_MATTrackAction = env->GetMethodID(cls, "MATTrackAction", "(Ljava/lang/String;ZDLjava/lang/String;)V");
    if (!g_MATTrackAction)
        goto fail;

    g_MATSetPackageName = env->GetMethodID(cls, "MATSetPackageName", "(Ljava/lang/String;)V");
    if (!g_MATSetPackageName)
        goto fail;
    
    g_MATStartAppToAppTracking = env->GetMethodID(cls, "MATStartAppToAppTracking", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V");
    if (!g_MATStartAppToAppTracking)
        goto fail;
    ///////
    g_MATSetCurrencyCode = env->GetMethodID(cls, "MATSetCurrencyCode", "(Ljava/lang/String;)V");
    if (!g_MATSetCurrencyCode)
        goto fail;
    g_MATSetDeviceId = env->GetMethodID(cls, "MATSetDeviceId", "(Ljava/lang/String;)V");
    if (!g_MATSetDeviceId)
        goto fail;
    g_MATSetOpenUDID = env->GetMethodID(cls, "MATSetOpenUDID", "(Ljava/lang/String;)V");
    if (!g_MATSetOpenUDID)
        goto fail;
    g_MATSetUserId = env->GetMethodID(cls, "MATSetUserId", "(Ljava/lang/String;)V");
    if (!g_MATSetUserId)
        goto fail;
    g_MATSetRevenue = env->GetMethodID(cls, "MATSetRevenue", "(D)V");
    if (!g_MATSetRevenue)
        goto fail;
    g_MATSetSiteId = env->GetMethodID(cls, "MATSetSiteId", "(Ljava/lang/String;)V");
    if (!g_MATSetSiteId)
        goto fail;
    g_MATSetTRUSTeId = env->GetMethodID(cls, "MATSetTRUSTeId", "(Ljava/lang/String;)V");
    if (!g_MATSetTRUSTeId)
        goto fail;
    g_MATSetDebugResponse = env->GetMethodID(cls, "MATSetDebugResponse", "(Z)V");
    if (!g_MATSetDebugResponse)
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

void MATSDKTerminate_platform()
{
    // Add any platform-specific termination code here
}

void MATStartMobileAppTracker_platform(const char* adId, const char* adKey)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring adId_jstr = env->NewStringUTF(adId);
    jstring adKey_jstr = env->NewStringUTF(adKey);
    env->CallVoidMethod(g_Obj, g_MATStartMobileAppTracker, adId_jstr, adKey_jstr);
    env->DeleteLocalRef(adId_jstr);
    env->DeleteLocalRef(adKey_jstr);
}

void MATSDKParameters_platform()
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    env->CallVoidMethod(g_Obj, g_MATSDKParameters);
}

void MATTrackInstall_platform()
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    env->CallVoidMethod(g_Obj, g_MATTrackInstall);
}

void MATTrackUpdate_platform()
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    env->CallVoidMethod(g_Obj, g_MATTrackUpdate);
}

void MATTrackInstallWithReferenceId_platform(const char* refId)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring refId_jstr = env->NewStringUTF(refId);
    env->CallVoidMethod(g_Obj, g_MATTrackInstallWithReferenceId, refId_jstr);
    env->DeleteLocalRef(refId_jstr);
}

void MATTrackActionForEventIdOrName_platform(const char* eventIdOrName, bool isId, const char* refId)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring eventIdOrName_jstr = env->NewStringUTF(eventIdOrName);
    jstring refId_jstr = env->NewStringUTF(refId);
    env->CallVoidMethod(g_Obj, g_MATTrackActionForEventIdOrName, eventIdOrName_jstr, isId, refId_jstr);
    env->DeleteLocalRef(eventIdOrName_jstr);
    env->DeleteLocalRef(refId_jstr);
}

void MATTrackAction_platform(const char* eventIdOrName, bool isId, double revenue, const char*  currency)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring eventIdOrName_jstr = env->NewStringUTF(eventIdOrName);
    jstring currency_jstr = env->NewStringUTF(currency);
    env->CallVoidMethod(g_Obj, g_MATTrackAction, eventIdOrName_jstr, isId, revenue, currency_jstr);
    env->DeleteLocalRef(eventIdOrName_jstr);
    env->DeleteLocalRef(currency_jstr);
}

void MATTrackActionForEventIdOrNameItems_platform(const char* eventIdOrName, bool isId, const MATArray* items, const char* refId, double revenueAmount, const char* currencyCode, uint8 transactionState)
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
    jni_env->CallVoidMethod(g_Obj, g_MATTrackActionForEventIdOrNameItems, eventIdOrName_jstr, isId, jlistobj, refId_jstr, revenueAmount, currencyCode_jstr, transactionState);
    
    jni_env->DeleteLocalRef(eventIdOrName_jstr);
    jni_env->DeleteLocalRef(refId_jstr);
    jni_env->DeleteLocalRef(currencyCode_jstr);
}

void MATStartAppToAppTracking_platform(const char* targetAppId, const char* advertiserId, const char* offerId, const char* publisherId, bool shouldRedirect)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    
    jstring targetAppIdUTF = env->NewStringUTF(targetAppId);
    jstring advertiserIdUTF = env->NewStringUTF(advertiserId);
    jstring offerIdUTF = env->NewStringUTF(offerId);
    jstring publisherIdUTF = env->NewStringUTF(publisherId);
    
    // Call setTracking from Android SDK
    env->CallVoidMethod(g_Obj, g_MATStartAppToAppTracking, advertiserIdUTF, targetAppIdUTF, publisherIdUTF, offerIdUTF, shouldRedirect);
    
    env->DeleteLocalRef(targetAppIdUTF);
    env->DeleteLocalRef(advertiserIdUTF);
    env->DeleteLocalRef(offerIdUTF);
    env->DeleteLocalRef(publisherIdUTF);
    
    return;
}

// Set Methods
void MATSetPackageName_platform(const char* packageName)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring packageName_jstr = env->NewStringUTF(packageName);
    env->CallVoidMethod(g_Obj, g_MATSetPackageName, packageName_jstr);
    env->DeleteLocalRef(packageName_jstr);
}

void MATSetCurrencyCode_platform(const char* currencyCode)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(currencyCode);
    env->CallVoidMethod(g_Obj, g_MATSetCurrencyCode, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void MATSetDeviceId_platform(const char* deviceId)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(deviceId);
    env->CallVoidMethod(g_Obj, g_MATSetDeviceId, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void MATSetOpenUDID_platform(const char* openUDID)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(openUDID);
    env->CallVoidMethod(g_Obj, g_MATSetOpenUDID, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void MATSetUserId_platform(const char* userId)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(userId);
    env->CallVoidMethod(g_Obj, g_MATSetUserId, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void MATSetRevenue_platform(double revenue)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    env->CallVoidMethod(g_Obj, g_MATSetRevenue, revenue);
}
void MATSetSiteId_platform(const char* siteId)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(siteId);
    env->CallVoidMethod(g_Obj, g_MATSetSiteId, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void MATSetTRUSTeId_platform(const char* tpid)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    jstring data_jstr = env->NewStringUTF(tpid);
    env->CallVoidMethod(g_Obj, g_MATSetTRUSTeId, data_jstr);
    env->DeleteLocalRef(data_jstr);
}
void MATSetDebugResponse_platform(bool shouldDebug)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    env->CallVoidMethod(g_Obj, g_MATSetDebugResponse, shouldDebug);
}

// iOS only functions that do nothing on Android

void MATSetAdvertiserIdentifier_platform(const char* advertiserIdentifier)
{
    
}

void MATSetAllowDuplicates_platform(bool allowDuplicates)
{
    
}

void MATSetDelegate_platform(bool enable)
{
    
}

void MATSetDeviceId_platform(char* deviceId)
{
    
}

void MATSetOpenUDID_platform(char* openUdid)
{
    
}

void MATSetRedirectUrl_platform(const char* redirectUrl)
{
    
}

void MATSetShouldAutoGenerateAdvertiserIdentifier_platform(bool shouldAutoGenerate)
{
    
}

void MATSetShouldAutoGenerateMacAddress_platform(bool shouldAutoGenerate)
{
    
}

void MATSetShouldAutoGenerateODIN1Key_platform(bool shouldAutoGenerate)
{
    
}

void MATSetShouldAutoGenerateOpenUDIDKey_platform(bool shouldAutoGenerate)
{
    
}

void MATSetShouldAutoGenerateVendorIdentifier_platform(bool shouldAutoGenerate)
{
    
}

void MATSetVendorIdentifier_platform(const char* vendorIdentifier)
{
    
}

void MATSetUseCookieTracking_platform(bool useCookieTracking)
{
    
}

void MATSetUseHTTPS_platform(bool useHTTPS)
{
    
}

