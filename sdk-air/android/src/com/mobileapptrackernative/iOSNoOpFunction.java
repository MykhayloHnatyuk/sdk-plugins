package com.mobileapptrackernative;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class iOSNoOpFunction implements FREFunction {
    public static final String GET_PARAMS       = "getSDKDataParameters";
    public static final String SET_ADVERTISER   = "setAdvertiserIdentifier";
    public static final String ALLOW_DUP        = "setAllowDuplicates";
    public static final String DELEGATE         = "setDelegate";
    public static final String DEVICE_ID        = "setDeviceId";
    public static final String OPEN_UDID        = "setOpenUDID";
    public static final String REDIRECT_URL     = "setRedirectUrl";
    public static final String GEN_ADVERTISER   = "setShouldAutoGenerateAdvertiserIdentifier";
    public static final String GEN_MAC          = "setShouldAutoGenerateMacAddress";
    public static final String GEN_ODIN         = "setShouldAutoGenerateODIN1Key";
    public static final String GEN_OPEN_UDID    = "setShouldAutoGenerateOpenUDIDKey";
    public static final String GEN_VENDOR       = "setShouldAutoGenerateVendorIdentifier";
    public static final String USE_COOKIE       = "setUseCookieTracking";
    public static final String USE_HTTPS        = "setUseHTTPS";
    public static final String SET_VENDOR       = "setVendorIdentifier";

    @Override
    public FREObject call(FREContext arg0, FREObject[] arg1) {
        return null;
    }

}
