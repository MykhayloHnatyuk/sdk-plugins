package com.mobileapptrackernative;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.mobileapptracker.MobileAppTracker;

public class MATExtensionContext extends FREContext {
    public static final String TAG = "MobileAppTrackerANE";
    public MobileAppTracker mat;

    @Override
    public void dispose() {
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();

        functionMap.put(InitFunction.NAME, new InitFunction());
        functionMap.put(TrackInstallFunction.NAME, new TrackInstallFunction());
        functionMap.put(TrackActionFunction.NAME, new TrackActionFunction());
        functionMap.put(TrackActionWithEventItemFunction.NAME, new TrackActionWithEventItemFunction());
        functionMap.put(TrackUpdateFunction.NAME,  new TrackUpdateFunction());

        functionMap.put(GetReferrerFunction.NAME, new GetReferrerFunction());

        functionMap.put(SetAllowDuplicatesFunction.NAME, new SetAllowDuplicatesFunction());
        functionMap.put(SetCurrencyCodeFunction.NAME, new SetCurrencyCodeFunction());
        functionMap.put(SetDebugModeFunction.NAME, new SetDebugModeFunction());
        functionMap.put(SetPackageNameFunction.NAME, new SetPackageNameFunction());
        functionMap.put(SetSiteIdFunction.NAME, new SetSiteIdFunction());
        functionMap.put(SetTRUSTeIdFunction.NAME,  new SetTRUSTeIdFunction());
        functionMap.put(SetUserIdFunction.NAME,  new SetUserIdFunction());

        functionMap.put(StartAppToAppFunction.NAME, new StartAppToAppFunction());

        // iOS functions that are no-op on Android
        functionMap.put(iOSNoOpFunction.DELEGATE, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.JAILBROKEN, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.GEN_MAC, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.GEN_JAILBROKEN, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.GEN_ODIN, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.GEN_OPEN_UDID, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.GEN_ADVERTISER, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.GEN_VENDOR, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.GET_PARAMS, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.OPEN_UDID, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.REDIRECT_URL, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.SET_ADVERTISER, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.SET_VENDOR, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.USE_COOKIE, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.USE_HTTPS, new iOSNoOpFunction());

        return functionMap;
    }

}
