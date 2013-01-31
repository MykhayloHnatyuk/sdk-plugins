package com.mobileapptrackernative;

import java.util.ArrayList;
import java.util.HashMap;

import android.util.Log;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class TrackActionWithEventItemFunction implements FREFunction {
    public static final String NAME = "trackActionWithEventItem";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        if (passedArgs.length == 7) {
            try {
                String event = "";
                double revenue = 0;
                String currency = "";
                String refId = "";
                ArrayList<HashMap<String, String>> eventItems = new ArrayList<HashMap<String, String>>();
                
                if (passedArgs[0] != null) {
                    event = passedArgs[0].getAsString();
                }
                // Read in list of HashMaps for event items
                if (passedArgs[1] != null) {
                    FREArray freEventItems = (FREArray) passedArgs[1];
                    
                    String itemName;
                    String unitPrice;
                    String itemQuantity;
                    String itemRevenue;
                    
                    for (int i = 0; i < freEventItems.getLength(); i+=4) {
                        itemName = freEventItems.getObjectAt(i).getAsString();
                        unitPrice = freEventItems.getObjectAt(i+1).getAsString();
                        itemQuantity = freEventItems.getObjectAt(i+2).getAsString();
                        itemRevenue = freEventItems.getObjectAt(i+3).getAsString();
                        
                        HashMap<String, String> eventItemMap = new HashMap<String, String>();
                        eventItemMap.put("item", itemName);
                        eventItemMap.put("unit_price", unitPrice);
                        eventItemMap.put("quantity", itemQuantity);
                        eventItemMap.put("revenue", itemRevenue);
                        
                        eventItems.add(eventItemMap);
                    }
                }
                if (passedArgs[2] != null) {
                    revenue = passedArgs[2].getAsDouble();
                }
                if (passedArgs[3] != null) {
                    currency = passedArgs[3].getAsString();
                }
                if (passedArgs[4] != null) {
                    refId = passedArgs[4].getAsString();
                }

                Log.i(MATExtensionContext.TAG, "Call " + NAME + " on event: " + event);
                MATExtensionContext mec = (MATExtensionContext)context;
                if (refId.length() > 0) {
                    mec.mat.setRefId(refId);
                }
                mec.mat.setRevenue(revenue);
                mec.mat.setCurrencyCode(currency);
                mec.mat.trackAction(event, eventItems);

                return FREObject.newObject(true);
            } catch (Exception e) {
                Log.d(MATExtensionContext.TAG, "ERROR: " + e);
                e.printStackTrace();
            }
        }
        return null;
    }
}
