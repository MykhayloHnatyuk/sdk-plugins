/*
java implementation of the s3eMATSDK extension.

Add android-specific functionality here.

These functions are called via JNI from native code.
*/
/*
 * NOTE: This file was originally written by the extension builder, but will not
 * be overwritten (unless --force is specified) and is intended to be modified.
 */
import com.ideaworks3d.marmalade.LoaderAPI;

import java.util.*;

import android.view.View;
import android.view.ViewGroup;

import com.mobileapptracker.MATEventItem;
import com.mobileapptracker.MobileAppTracker;
import android.util.Log;

import android.R;
import android.widget.Button;
import android.widget.TextView;
import android.graphics.Typeface;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.FrameLayout;

class s3eMATSDK
{
    MobileAppTracker mat;
    
    public void MATStartMobileAppTracker(String adId, String convKey)
    {
        mat = new MobileAppTracker(LoaderAPI.getActivity(), adId, convKey);
        mat.setPluginName("marmalade");
    }
    public void MATSDKParameters()
    {
        // no android equivalent in the mat sdk
    }
    public void MATTrackInstall()
    {
        mat.trackInstall();
    }
    public void MATTrackUpdate()
    {
        mat.trackUpdate();
    }
    public void MATTrackInstallWithReferenceId(String refId)
    {
        mat.setRefId(refId);
        mat.trackInstall();
    }
    public void MATTrackActionForEventIdOrName(String eventIdOrName, boolean isId, String refId)
    {
        mat.setRefId(refId);
        mat.trackAction(eventIdOrName);
    }
    
    // items is one or more event item hash maps
    public void MATTrackActionForEventIdOrNameItems(String eventIdOrName, boolean isId, List<MATEventItem> items, String refId, String revenueAmount, String currencyCode, int transactionState, String receipt, String receiptSignature)
    {
        mat.setCurrencyCode(currencyCode);
        mat.setRefId(refId);
        mat.setRevenue(Double.parseDouble(revenueAmount));
        if (receiptSignature != null && receiptSignature.length() > 0) {
            mat.trackAction(eventIdOrName, items, receipt, receiptSignature);
        } else {
            mat.trackAction(eventIdOrName, items);
        }
    }
    
    public void MATTrackAction(String eventIdOrName, boolean isId, String revenueAmount, String currencyCode)
    {
        mat.trackAction(eventIdOrName, Double.parseDouble(revenueAmount), currencyCode);
    }
    
    public void MATStartAppToAppTracking(String targetAppId, String advertiserId, String offerId, String publisherId, boolean shouldRedirect)
    {
        mat.setTracking(advertiserId, targetAppId, publisherId, offerId, shouldRedirect);
    }
    
    public void MATSetPackageName(String packageName)
    {
        mat.setPackageName(packageName);
    }
    
    public void MATSetCurrencyCode(String currencyCode)
    {
        mat.setCurrencyCode(currencyCode);
    }
    
    public void MATSetUserId(String userId)
    {
        mat.setUserId(userId);
    }

    public void MATSetFacebookUserId(String facebookUserId)
    {
        mat.setFacebookUserId(facebookUserId);
    }

    public void MATSetTwitterUserId(String twitterUserId)
    {
        mat.setTwitterUserId(twitterUserId);
    }

    public void MATSetGoogleUserId(String googleUserId)
    {
        mat.setGoogleUserId(googleUserId);
    }

    public void MATSetRevenue(String revenue)
    {
        mat.setRevenue(Double.parseDouble(revenue));
    }
    
    public void MATSetSiteId(String siteId)
    {
        mat.setSiteId(siteId);
    }
    
    public void MATSetTRUSTeId(String tpid)
    {
        mat.setTRUSTeId(tpid);
    }
    
    public void MATSetDebugMode(boolean shouldDebug)
    {
        mat.setDebugMode(shouldDebug);
    }
    
    public void MATSetAllowDuplicates(boolean allowDuplicates)
    {
		mat.setAllowDuplicates(allowDuplicates);
    }
    
    public void MATSetAge(int age)
    {
		mat.setAge(age);
    }
    
    public void MATSetGender(int gender)
    {
		mat.setGender(1 == gender ? MobileAppTracker.GENDER_FEMALE : MobileAppTracker.GENDER_MALE);
    }
    
    public void MATSetLocation(double latitude, double longitude, double altitude)
    {
		mat.setLatitude(latitude);
        mat.setLongitude(longitude);
        mat.setAltitude(altitude);
    }
    
    public void MATSetAppAdTracking(boolean enable)
    {
        // not available in android
    }
    
    public void MATSetShouldAutoDetectJailbroken(boolean shouldAutoDetect)
    {
        // not available in android
    }
    
    public void MATSetMACAddress(String mac)
    {
        // not available in android
    }
    
    public void MATSetODIN1(String odin1)
    {
        // not available in android
    }
    
    public void MATSetUIID(String uiid)
    {
        // not available in android
    }
    
    public void MATSetShouldAutoGenerateAppleVendorIdentifier(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void MATSetShouldAutoGenerateAppleAdvertisingIdentifier(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void MATSetAppleAdvertisingIdentifier(String appleAdvertisingId)
    {
        // not available in android
    }
    
    public void MATSetAppleVendorIdentifier(String appleVendorId)
    {
        // not available in android
    }
    
    public void MATSetJailbroken(boolean isJailbroken)
    {
        // not available in android
    }
    
    public void MATSetOpenUDID(String openUDID)
    {
        // not implemented in android
    }
    
    public void MATSetRedirectUrl(String redirectUrl)
    {
        // not available in android
    }
    
    public void MATSetUseCookieTracking(boolean useCookieTracking)
    {
        // not available in android
    }
}
