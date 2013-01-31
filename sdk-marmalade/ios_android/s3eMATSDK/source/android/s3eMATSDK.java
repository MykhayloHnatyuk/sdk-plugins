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

import com.mobileapptracker.MobileAppTracker;
import android.util.Log;

//import android.content.Context;
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
    
    public void s3eStartMobileAppTracker(String adId, String adKey)
    {
        // Todo: need a setpackagename s3e method
        mat = new MobileAppTracker(LoaderAPI.getActivity(), adId, adKey);
    }
    public void s3eSDKParameters()
    {
        // no android equivalant in the mat sdk
    }
    public void s3eTrackInstall()
    {
        mat.setDebugMode(true);
        mat.trackInstall();
    }
    public void s3eTrackUpdate()
    {
        mat.setDebugMode(true);
        mat.trackUpdate();
    }
    public void s3eTrackInstallWithReferenceId(String refId)
    {
        mat.setRefId(refId);
        mat.trackInstall();
    }
    public void s3eTrackActionForEventIdOrName(String eventIdOrName, boolean isId, String refId)
    {
        mat.setRefId(refId);
        mat.trackAction(eventIdOrName);
    }
    
    // items is one or more event item hash maps
    public void s3eTrackActionForEventIdOrNameItems(String eventIdOrName, boolean isId, List items, String refId, double revenueAmount, String currencyCode, int transactionState)
    {
        Log.d("s3eMATSDK", "in java method " + eventIdOrName);
        
        Log.d("s3eMATSDK", "List = " + items);
    
        mat.setCurrencyCode(currencyCode);
        mat.setRefId(refId);
        mat.setRevenue(revenueAmount);
        mat.trackAction(eventIdOrName, items);
    }
    
    public void s3eTrackAction(String eventIdOrName, boolean isId, double revenueAmount, String currencyCode)
    {
        Log.d("s3eMATSDK", "in java method " + eventIdOrName);
        mat.setCurrencyCode(currencyCode);
        mat.setRevenue(revenueAmount);
        mat.trackAction(eventIdOrName);
    }
    
    public void s3eStartAppToAppTracking(String targetAppId, String advertiserId, String offerId, String publisherId, boolean shouldRedirect)
    {
        mat.setTracking(advertiserId, targetAppId, publisherId, offerId, shouldRedirect);
    }
    
    public void s3eSetPackageName(String packageName)
    {
        mat.setPackageName(packageName);
    }
    
    public void s3eSetCurrencyCode(String currencyCode)
    {
        mat.setCurrencyCode(currencyCode);
    }
    
    public void s3eSetDeviceId(String deviceId)
    {
        // not available in android
    }
    
    public void s3eSetOpenUDID(String openUDID)
    {
        // not implemented in android
    }
    
    public void s3eSetUserId(String userId)
    {
        mat.setUserId(userId);
    }
    
    public void s3eSetRevenue(double revenue)
    {
        mat.setRevenue(revenue);
    }
    
    public void s3eSetSiteId(String siteId)
    {
        mat.setSiteId(siteId);
    }
    
    public void s3eSetTRUSTeId(String tpid)
    {
        mat.setTRUSTeId(tpid);
    }
    
    public void s3eSetDebugResponse(boolean shouldDebug)
    {
        mat.setDebugMode(shouldDebug);
    }
    
    public void s3eSetAllowDuplicates(boolean allowDuplidates)
    {
        // not available in android
    }
    
    public void s3eSetShouldAutoGenerateMacAddress(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void s3eSetShouldAutoGenerateODIN1Key(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void s3eSetShouldAutoGenerateOpenUDIDKey(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void s3eSetShouldAutoGenerateVendorIdentifier(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void s3eSetShouldAutoGenerateAdvertiserIdentifier(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void s3eSetUseCookieTracking(boolean useCookieTracking)
    {
        // not available in android
    }
    
    public void s3eSetRedirectUrl(String redirectUrl)
    {
        // not available in android
    }
    
    public void s3eSetAdvertiserIdentifier(String advertiserId)
    {
        // not available in android
    }
    
    public void s3eSetUseHTTPS(boolean useHTTPS)
    {
        // not available in android
    }
    
    public void s3eSetVendorIdentifier(String vendorId)
    {
        // not available in android
    }
}
