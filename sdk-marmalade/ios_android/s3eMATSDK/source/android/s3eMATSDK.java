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
    
    public void MATStartMobileAppTracker(String adId, String adKey)
    {
        mat = new MobileAppTracker(LoaderAPI.getActivity(), adId, adKey);
    }
    public void MATSDKParameters()
    {
        // no android equivalant in the mat sdk
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
    public void MATTrackActionForEventIdOrNameItems(String eventIdOrName, boolean isId, List items, String refId, double revenueAmount, String currencyCode, int transactionState)
    {
        Log.d("MATSDK", "in java method " + eventIdOrName);
        
        Log.d("MATSDK", "List = " + items);
    
        mat.setCurrencyCode(currencyCode);
        mat.setRefId(refId);
        mat.setRevenue(revenueAmount);
        mat.trackAction(eventIdOrName, items);
    }
    
    public void MATTrackAction(String eventIdOrName, boolean isId, double revenueAmount, String currencyCode)
    {
        Log.d("MATSDK", "in java method " + eventIdOrName);
        mat.setCurrencyCode(currencyCode);
        mat.setRevenue(revenueAmount);
        mat.trackAction(eventIdOrName);
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
    
    public void MATSetDeviceId(String deviceId)
    {
        // not available in android
    }
    
    public void MATSetOpenUDID(String openUDID)
    {
        // not implemented in android
    }
    
    public void MATSetUserId(String userId)
    {
        mat.setUserId(userId);
    }
    
    public void MATSetRevenue(double revenue)
    {
        mat.setRevenue(revenue);
    }
    
    public void MATSetSiteId(String siteId)
    {
        mat.setSiteId(siteId);
    }
    
    public void MATSetTRUSTeId(String tpid)
    {
        mat.setTRUSTeId(tpid);
    }
    
    public void MATSetDebugResponse(boolean shouldDebug)
    {
        mat.setDebugMode(shouldDebug);
    }
    
    public void MATSetAllowDuplicates(boolean allowDuplicates)
    {
        // not available in android
    }
    
    public void MATSetShouldAutoGenerateMacAddress(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void MATSetShouldAutoGenerateODIN1Key(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void MATSetShouldAutoGenerateOpenUDIDKey(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void MATSetShouldAutoGenerateVendorIdentifier(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void MATSetShouldAutoGenerateAdvertiserIdentifier(boolean shouldAutoGenerate)
    {
        // not available in android
    }
    
    public void MATSetUseCookieTracking(boolean useCookieTracking)
    {
        // not available in android
    }
    
    public void MATSetRedirectUrl(String redirectUrl)
    {
        // not available in android
    }
    
    public void MATSetAdvertiserIdentifier(String advertiserId)
    {
        // not available in android
    }
    
    public void MATSetUseHTTPS(boolean useHTTPS)
    {
        // not available in android
    }
    
    public void MATSetVendorIdentifier(String vendorId)
    {
        // not available in android
    }
}
