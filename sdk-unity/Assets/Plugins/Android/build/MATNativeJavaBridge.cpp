#include <stdlib.h>
#include <jni.h>
#include <android/log.h>

extern "C"
{
	typedef struct
	{
		char * item;
		double unit_price;
		int    quantity;
		double revenue;
	} MATEventItem;

	JavaVM*		java_vm;
	JNIEnv*		jni_env;

	jobject		MobileAppTracker;
	jmethodID	trackActionMethod;
	jmethodID	trackActionWithEventItemMethod;
	jmethodID	trackInstallMethod;
	jmethodID	trackUpdateMethod;
	jmethodID	setAllowDuplicatesMethod;
	jmethodID	setCurrencyCodeMethod;
	jmethodID	setDebugModeMethod;
	jmethodID	setPackageNameMethod;
	jmethodID	setRefIdMethod;
	jmethodID	setSiteIdMethod;
	jmethodID	setTRUSTeIdMethod;
	jmethodID	setUserIdMethod;
	jmethodID	startAppToAppTrackingMethod;

	jint JNI_OnLoad(JavaVM* vm, void* reserved)
	{
		// Use __android_log_print for logcat debugging
		__android_log_print(ANDROID_LOG_INFO, "MATJavaBridge", "[%s] Creating java link vm = %08x\n", __FUNCTION__, vm);
		java_vm = vm;
		jni_env = 0;
		// Attach our thread to the Java VM to get the JNI env
		java_vm->AttachCurrentThread(&jni_env, 0);
		__android_log_print(ANDROID_LOG_INFO, "MATJavaBridge", "[%s] JNI Environment is = %08x\n", __FUNCTION__, jni_env);
	
		return JNI_VERSION_1_6;		// minimum JNI version
	}

	const void initNativeCode (char* advertiserId, char* conversionKey)
	{
		// Convert char arrays to Java Strings for passing in to MobileAppTracker constructor
		jstring advertiserIdUTF		= jni_env->NewStringUTF(advertiserId);
		jstring conversionKeyUTF	= jni_env->NewStringUTF(conversionKey); 

		// Find our main activity..
		jclass cls_Activity		= jni_env->FindClass("com/unity3d/player/UnityPlayer");
		jfieldID fid_Activity	= jni_env->GetStaticFieldID(cls_Activity, "currentActivity", "Landroid/app/Activity;");
		jobject obj_Activity	= jni_env->GetStaticObjectField(cls_Activity, fid_Activity);
		__android_log_print(ANDROID_LOG_INFO, "MATJavaBridge", "[%s] Current activity = %08x\n", __FUNCTION__, obj_Activity);

		// Create a MobileAppTracker object
		jclass cls_MobileAppTracker		= jni_env->FindClass("com/mobileapptracker/MobileAppTracker");
		jmethodID mid_MobileAppTracker	= jni_env->GetMethodID(cls_MobileAppTracker, "<init>", "(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V");
		jobject obj_MobileAppTracker	= jni_env->NewObject(cls_MobileAppTracker, mid_MobileAppTracker, obj_Activity, advertiserIdUTF, conversionKeyUTF);
		__android_log_print(ANDROID_LOG_INFO, "MATJavaBridge", "[%s] MobileAppTracker object = %08x\n", __FUNCTION__, obj_MobileAppTracker);

		// Create a global reference to the MobileAppTracker object and fetch method ids
		MobileAppTracker		= jni_env->NewGlobalRef(obj_MobileAppTracker);
		trackInstallMethod		= jni_env->GetMethodID(cls_MobileAppTracker, "trackInstall", "()I");
		trackActionMethod		= jni_env->GetMethodID(cls_MobileAppTracker, "trackAction", "(Ljava/lang/String;DLjava/lang/String;)I");
		trackActionWithEventItemMethod = jni_env->GetMethodID(cls_MobileAppTracker, "trackAction", "(Ljava/lang/String;Ljava/util/List;)I");
		trackUpdateMethod		= jni_env->GetMethodID(cls_MobileAppTracker, "trackUpdate", "()I");

		setAllowDuplicatesMethod 	= jni_env->GetMethodID(cls_MobileAppTracker, "setAllowDuplicates", "(Z)V");
		setCurrencyCodeMethod	= jni_env->GetMethodID(cls_MobileAppTracker, "setCurrencyCode", "(Ljava/lang/String;)V");
		setDebugModeMethod		= jni_env->GetMethodID(cls_MobileAppTracker, "setDebugMode", "(Z)V");
		setPackageNameMethod	= jni_env->GetMethodID(cls_MobileAppTracker, "setPackageName", "(Ljava/lang/String;)V");
		setRefIdMethod			= jni_env->GetMethodID(cls_MobileAppTracker, "setRefId", "(Ljava/lang/String;)V");
		setSiteIdMethod			= jni_env->GetMethodID(cls_MobileAppTracker, "setSiteId", "(Ljava/lang/String;)V");
		setTRUSTeIdMethod		= jni_env->GetMethodID(cls_MobileAppTracker, "setTRUSTeId", "(Ljava/lang/String;)V");
		setUserIdMethod			= jni_env->GetMethodID(cls_MobileAppTracker, "setUserId", "(Ljava/lang/String;)V");

		startAppToAppTrackingMethod = jni_env->GetMethodID(cls_MobileAppTracker, "setTracking", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Ljava/lang/String;");

		// Explicitly remove the local variables to prevent leaks
		jni_env->DeleteLocalRef(advertiserIdUTF);
		jni_env->DeleteLocalRef(conversionKeyUTF);

		return;
	}

	const void startAppToAppTracking(char* targetAppId, char* advertiserId, char* offerId, char* publisherId, bool shouldRedirect)
	{
		jstring targetAppIdUTF = jni_env->NewStringUTF(targetAppId);
		jstring advertiserIdUTF = jni_env->NewStringUTF(advertiserId);
		jstring offerIdUTF = jni_env->NewStringUTF(offerId);
		jstring publisherIdUTF = jni_env->NewStringUTF(publisherId);

		// Call setTracking from Android SDK
		jni_env->CallObjectMethod(MobileAppTracker, startAppToAppTrackingMethod, advertiserIdUTF, targetAppIdUTF, publisherIdUTF, offerIdUTF, shouldRedirect);

		jni_env->DeleteLocalRef(targetAppIdUTF);
		jni_env->DeleteLocalRef(advertiserIdUTF);
		jni_env->DeleteLocalRef(offerIdUTF);
		jni_env->DeleteLocalRef(publisherIdUTF);

		return;
	}

	const void trackAction(char* eventName, bool isId, double revenue, char* currencyCode)
	{
		jstring eventNameUTF = jni_env->NewStringUTF(eventName);
		jstring currencyCodeUTF = jni_env->NewStringUTF(currencyCode);
		jint trackStatus = jni_env->CallIntMethod(MobileAppTracker, trackActionMethod, eventNameUTF, revenue, currencyCodeUTF);
		__android_log_print(ANDROID_LOG_INFO, "MATJavaBridge", "[%s] trackAction status = %d\n", __FUNCTION__, trackStatus);

		jni_env->DeleteLocalRef(eventNameUTF);
		jni_env->DeleteLocalRef(currencyCodeUTF);

		return;
	}

	const void trackActionWithEventItem(char* eventName, bool isId, MATEventItem items[], int eventItemCount, char* refId, double revenue, char* currency, int transactionState)
	{
		// Set the ref ID
		jstring refIdUTF = jni_env->NewStringUTF(refId);
		jni_env->CallVoidMethod(MobileAppTracker, setRefIdMethod, refIdUTF);
		jni_env->DeleteLocalRef(refIdUTF);

		// Set the currency code
		jstring currencyCodeUTF = jni_env->NewStringUTF(currency);
		jni_env->CallVoidMethod(MobileAppTracker, setCurrencyCodeMethod, currencyCodeUTF);
		jni_env->DeleteLocalRef(currencyCodeUTF);

		// Get Java HashMap class and put method
		jclass clsHashMap = jni_env->FindClass("java/util/HashMap");
		jmethodID mapConstructorID = jni_env->GetMethodID(clsHashMap, "<init>", "()V");
		jmethodID map_put_mid = 0;
		map_put_mid = jni_env->GetMethodID(clsHashMap, "put", "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;");

		// Get Java ArrayList class and add method
		jclass clsArrayList = jni_env->FindClass("java/util/ArrayList");
		jmethodID listConstructorID = jni_env->GetMethodID(clsArrayList, "<init>", "()V");
		jmethodID list_add_mid = 0;
		list_add_mid = jni_env->GetMethodID(clsArrayList, "add", "(Ljava/lang/Object;)Z");

		// Get Java Integer class constructor
		jclass clsInteger = jni_env->FindClass("java/lang/Integer");
		jmethodID intConstructorID = jni_env->GetMethodID(clsInteger, "<init>", "(I)V");

		// Get Java Double class constructor
		jclass clsDouble = jni_env->FindClass("java/lang/Double");
		jmethodID doubleConstructorID = jni_env->GetMethodID(clsDouble, "<init>", "(D)V");

		// Create a jobject of ArrayList for storing HashMaps
		jobject jlistobj = jni_env->NewObject(clsArrayList, listConstructorID);

		// Convert event name to UTF
		jstring eventNameUTF = jni_env->NewStringUTF(eventName);

		// Convert keys for event item values to UTF
		jstring itemArg = jni_env->NewStringUTF("item");
		jstring unitpriceArg = jni_env->NewStringUTF("unit_price");
		jstring quantityArg = jni_env->NewStringUTF("quantity");
		jstring revenueArg = jni_env->NewStringUTF("revenue");

		// For storing event item values
		jobject jmapobj;
		jstring itemVal;
		jobject unitpriceVal;
		jobject quantityVal;
		jobject revenueVal;

		for (int i = 0; i < eventItemCount; i++)
		{
			// Create a new HashMap for storing event item values
			jmapobj = jni_env->NewObject(clsHashMap, mapConstructorID);
			
			// Current event item in item array
			MATEventItem eventItem = items[i];

			// Convert event item values to Java-readable objects
			itemVal = jni_env->NewStringUTF(eventItem.item);
			unitpriceVal = jni_env->NewObject(clsDouble, doubleConstructorID, eventItem.unit_price);
			quantityVal = jni_env->NewObject(clsInteger, intConstructorID, eventItem.quantity);
			revenueVal = jni_env->NewObject(clsDouble, doubleConstructorID, eventItem.revenue);

			// Populate event item map with values from MATEventItem
			jni_env->CallObjectMethod(jmapobj, map_put_mid, itemArg, itemVal);
			jni_env->CallObjectMethod(jmapobj, map_put_mid, unitpriceArg, unitpriceVal);
			jni_env->CallObjectMethod(jmapobj, map_put_mid, quantityArg, quantityVal);
			jni_env->CallObjectMethod(jmapobj, map_put_mid, revenueArg, revenueVal);

			// Add HashMap to ArrayList of event items
			jni_env->CallBooleanMethod(jlistobj, list_add_mid, jmapobj);
		}
		
		// Call trackActionWithEventItem
		jint trackStatus = jni_env->CallIntMethod(MobileAppTracker, trackActionWithEventItemMethod, eventNameUTF, jlistobj, (jint)eventItemCount);
		__android_log_print(ANDROID_LOG_INFO, "MATJavaBridge", "[%s] trackActionWithEventItem status = %d\n", __FUNCTION__, trackStatus);

		// Delete local variables used
		jni_env->DeleteLocalRef(jmapobj);
		jni_env->DeleteLocalRef(jlistobj);

		jni_env->DeleteLocalRef(itemArg);
		jni_env->DeleteLocalRef(unitpriceArg);
		jni_env->DeleteLocalRef(quantityArg);
		jni_env->DeleteLocalRef(revenueArg);

		jni_env->DeleteLocalRef(itemVal);
		jni_env->DeleteLocalRef(unitpriceVal);
		jni_env->DeleteLocalRef(quantityVal);
		jni_env->DeleteLocalRef(revenueVal);

		return;
	}

	const void trackInstall() 
	{
		jint trackStatus = jni_env->CallIntMethod(MobileAppTracker, trackInstallMethod);
		__android_log_print(ANDROID_LOG_INFO, "MATJavaBridge", "[%s] trackInstall status = %d\n", __FUNCTION__, trackStatus);
		return;
	}

	const void trackInstallWithReferenceId(char* refId)
	{
		jstring refIdUTF = jni_env->NewStringUTF(refId);
		jni_env->CallVoidMethod(MobileAppTracker, setRefIdMethod, refIdUTF);
		jni_env->DeleteLocalRef(refIdUTF);
		
		jint trackStatus = jni_env->CallIntMethod(MobileAppTracker, trackInstallMethod);
		__android_log_print(ANDROID_LOG_INFO, "MATJavaBridge", "[%s] trackInstallWithReferenceId status = %d\n", __FUNCTION__, trackStatus);
		
		return;
	}

	const void trackUpdate()
	{
		jint trackStatus = jni_env->CallIntMethod(MobileAppTracker, trackUpdateMethod);
		__android_log_print(ANDROID_LOG_INFO, "MATJavaBridge", "[%s] trackUpdate status = %d\n", __FUNCTION__, trackStatus);
		return;
	}

	const void trackUpdateWithReferenceId(char* refId)
	{
		jstring refIdUTF = jni_env->NewStringUTF(refId);
		jni_env->CallVoidMethod(MobileAppTracker, setRefIdMethod, refIdUTF);
		jni_env->DeleteLocalRef(refIdUTF);
		
		jint trackStatus = jni_env->CallIntMethod(MobileAppTracker, trackUpdateMethod);
		__android_log_print(ANDROID_LOG_INFO, "MATJavaBridge", "[%s] trackUpdateWithReferenceId status = %d\n", __FUNCTION__, trackStatus);
		
		return;	
	}

	const void setAllowDuplicateRequests(bool allowDuplicateRequests)
	{
		jni_env->CallVoidMethod(MobileAppTracker, setAllowDuplicatesMethod, allowDuplicateRequests);
		return;
	}
	
	const void setCurrencyCode(char* currencyCode) 
	{
		jstring currencyCodeUTF = jni_env->NewStringUTF(currencyCode);
		jni_env->CallVoidMethod(MobileAppTracker, setCurrencyCodeMethod, currencyCodeUTF);
		jni_env->DeleteLocalRef(currencyCodeUTF);
		return;
	}
	
	const void setDebugMode(bool debugMode)
	{
		jni_env->CallVoidMethod(MobileAppTracker, setDebugModeMethod, debugMode);
		return;
	}

	const void setPackageName(char* packageName)
	{
		jstring packageNameUTF = jni_env->NewStringUTF(packageName);
		jni_env->CallVoidMethod(MobileAppTracker, setPackageNameMethod, packageNameUTF);
		jni_env->DeleteLocalRef(packageNameUTF);
		return;
	}

	const void setSiteId(char* siteId)
	{
		jstring siteIdUTF = jni_env->NewStringUTF(siteId);
		jni_env->CallVoidMethod(MobileAppTracker, setSiteIdMethod, siteIdUTF);
		jni_env->DeleteLocalRef(siteIdUTF);
		return;
	}

	const void setTRUSTeId(char* trusteId)
	{
		jstring trusteIdUTF = jni_env->NewStringUTF(trusteId);
		jni_env->CallVoidMethod(MobileAppTracker, setTRUSTeIdMethod, trusteIdUTF);
		jni_env->DeleteLocalRef(trusteIdUTF);
		return;
	}

	const void setUserId(char* userId)
	{
		jstring userIdUTF = jni_env->NewStringUTF(userId);
		jni_env->CallVoidMethod(MobileAppTracker, setUserIdMethod, userIdUTF);
		jni_env->DeleteLocalRef(userIdUTF);
		return;
	}

	// iOS only functions that do nothing on Android
	
	const void setAppleAdvertisingIdentifier(char* appleAdvertisingIdentifier)
	{
		return;
	}

	const void setDelegate(bool enable)
	{
		return;
	}

	const void setOpenUDID(char* openUdid)
	{
		return;
	}

	const void setRedirectUrl(char* redirectUrl)
	{
		return;
	}

	const void setShouldAutoGenerateAppleAdvertisingIdentifier(bool shouldAutoGenerate)
	{
		return;
	}
	
	const void setShouldAutoGenerateMacAddress(bool shouldAutoGenerate)
	{
		return;
	}

	const void setShouldAutoGenerateODIN1Key(bool shouldAutoGenerate)
	{
		return;
	}

	const void setShouldAutoGenerateOpenUDIDKey(bool shouldAutoGenerate)
	{
		return;
	}

	const void setShouldAutoGenerateAppleVendorIdentifier(bool shouldAutoGenerate)
	{
		return;
	}

	const void setUseCookieTracking(bool useCookieTracking)
	{
		return;
	}

	const void setUseHTTPS(bool useHTTPS)
	{
		return;
	}

	const void setAppleVendorIdentifier(char* appleVendorIdentifier)
	{
		return;
	}

	const char * getSDKDataParameters()
	{
		return '\0';
	}

} // extern "C"
