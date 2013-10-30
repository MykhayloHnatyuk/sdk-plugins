// This is a test harness for the MobileAppTracker module.
// It shows sample calls to variaus methods supported by MobileAppTrakcer.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var label = Ti.UI.createLabel({text: "MAT Titanium Test App", top: 20, width: 230, height: 30 });
label.textAlign = Titanium.UI.TEXT_ALIGNMENT_CENTER;
win.add(label);

var mat = require('ti.mobileapptracker');
Ti.API.info("module is => " + mat);

var MAT_ADVERTISER_ID = "your_mat_advertiser_id";
var MAT_CONVERSION_KEY = "your_mat_conversion_key";
//var MAT_PACKAGE_NAME = "your_mat_app_package_name";

var button = Titanium.UI.createButton({ title: 'Start MAT', top: 60, width: 230, height: 30 });
button.addEventListener('click',function(e) {
	mat.initTracker([MAT_ADVERTISER_ID, MAT_CONVERSION_KEY]);
	
	// Optional: Only required if the app's bundle id does not match the app package name set on MAT.  
	//mat.setPackageName(MAT_PACKAGE_NAME);
	
	// only for debugging
	//mat.setDelegate(true);
});
win.add(button);

var isMATDebugEnabled = false;
var button = Titanium.UI.createButton({ title: 'Toggle Debug Mode', top: 100, width: 230, height: 30 });
isMATDebugEnabled = !isMATDebugEnabled;
button.addEventListener('click',function(e) { mat.setDebugMode(isMATDebugEnabled); });
win.add(button);

var isMATDuplicatesAllowed = false;
var button = Titanium.UI.createButton({ title: 'Toggle Allow Duplicates', top: 140, width: 230, height: 30 });
isMATDuplicatesAllowed = !isMATDuplicatesAllowed;
button.addEventListener('click',function(e) { mat.setAllowDuplicates(isMATDuplicatesAllowed); });
win.add(button);

var button = Titanium.UI.createButton({ title: 'Print SDK Data Parameters', top: 180, width: 230, height: 30 });
button.addEventListener('click',function(e) { mat.printSDKDataParameters(); });
win.add(button);

var button = Titanium.UI.createButton({ title: 'Track Install', top: 220, width: 230, height: 30 });
button.addEventListener('click',function(e) { mat.trackInstall(); });
win.add(button);

var button = Titanium.UI.createButton({ title: 'Track Update', top: 260, width: 230, height: 30 });
button.addEventListener('click',function(e) { mat.trackUpdate('ref11'); });
win.add(button);

var button = Titanium.UI.createButton({ title: 'Track Action', top: 300, width: 230, height: 30 });
button.addEventListener('click',function(e) { mat.trackAction(["purchase",
                                                    false,
                                                    "ref1",
                                                    0.99,
                                                    "USD"]); });
win.add(button);

var button = Titanium.UI.createButton({ title: 'Track Action With EventItems', top: 340, width: 230, height: 30 });
button.addEventListener('click',function(e) { 
	
	var eventItems = new Array();

                var eventItem1 = {"item":"item1",
                    "quantity":1,
                    "unit_price":0.99,
                    "revenue":0.99,
                    "attribute_sub1":"1",
                    "attribute_sub2":"2",
                    "attribute_sub3":"3",
                    "attribute_sub4":"4",
                    "attribute_sub5":"5"
                };
                eventItems[0] = eventItem1;
                
                var eventItem2 = {"item":"item2",
                    "quantity":2,
                    "unit_price":0.50,
                    "revenue":1
                };
                eventItems[1] = eventItem2;
	
	mat.trackActionWithItems(["purchase",
								false,
								eventItems,
                                "ref1",
                                0.99,
                                "USD"]);
});

win.add(button);

var button = Titanium.UI.createButton({ title: 'Track Action With IAP Receipt', top: 380, width: 230, height: 30 });
button.addEventListener('click',function(e) { 
	
	var eventItems = new Array();
                
                var eventItem1 = {"item":"item1",
                    "quantity":1,
                    "unit_price":0.99,
                    "revenue":0.99,
                    "attribute_sub1":"1",
                    "attribute_sub2":"2",
                    "attribute_sub3":"3",
                    "attribute_sub4":"4",
                    "attribute_sub5":"5"
                };
                eventItems[0] = eventItem1;
                
                var eventItem2 = {"item":"item2",
                    "quantity":2,
                    "unit_price":0.50,
                    "revenue":1
                };
                eventItems[1] = eventItem2;
	
	mat.trackActionWithReceipt(["purchase",
                                 false,
                                 eventItems,
                                 "ref1",
                                 0.99,
                                 "USD",
                                 0,
                                 getSampleiTunesIAPReceipt(),
                                 null]); 

});
win.add(button);


var button = Titanium.UI.createButton({ title: 'Test Setter Methods', top: 420, width: 230, height: 30 });
button.addEventListener('click',function(e) { 
	
	mat.setODIN1("tempODIN1");
    mat.setOpenUDID("tempOpenUDID");
    mat.setMACAddress("tempMACAddress");
    mat.setTrusteTPID("tempTrusteTPID");
    mat.setUserId("tempUserId");
    mat.setUIID("tempUIID");
    mat.setCurrencyCode("tempCurrencyCode");
    mat.setGender([1]);
    mat.setLocation(1.1,2.2);
    mat.setLocationWithAltitude(3.3,4.4,5.5);
    mat.setUseCookieTracking(false);
    mat.setUseHTTPS(false);
    mat.setUseCookieTracking(false);
    mat.setAppAdTracking(true);
    mat.setAge(23);
    mat.setJailbroken(false);
    mat.setMATAdvertiserId("tempMATAdvId");
    mat.setMATConversionKey("tempMATConvKey");
    mat.setAppleAdvertisingIdentifier("12345678-1234-1234-1234-123456789012");
    mat.setAppleVendorIdentifier("12345678-1234-1234-1234-123456789012");
	});
win.add(button);

win.open();

function getSampleiTunesIAPReceipt()
{
	return "{\"signature\" = \"AiuR/oePW4lQq2qAFerYcL/lU7HB7rqPKoddrjnqLUqvLywbSukO3OUwWwiRGE8iFiNvaqVF2CaG8siBkfkP5KYaeiTHT2RNLCIKyCfhOIr4q0wYCKwxNp2vdo3S8b+4boeSAXzgzBHCR1S1hTN5LuoeRzDeIWHoYT66CBweqDetAAADVzCCA1MwggI7oAMCAQICCGUUkU3ZWAS1MA0GCSqGSIb3DQEBBQUAMH8xCzAJBgNVBAYTAlVTMRMwEQYDVQQKDApBcHBsZSBJbmMuMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEzMDEGA1UEAwwqQXBwbGUgaVR1bmVzIFN0b3JlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA5MDYxNTIyMDU1NloXDTE0MDYxNDIyMDU1NlowZDEjMCEGA1UEAwwaUHVyY2hhc2VSZWNlaXB0Q2VydGlmaWNhdGUxGzAZBgNVBAsMEkFwcGxlIGlUdW5lcyBTdG9yZTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMrRjF2ct4IrSdiTChaI0g8pwv/cmHs8p/RwV/rt/91XKVhNl4XIBimKjQQNfgHsDs6yju++DrKJE7uKsphMddKYfFE5rGXsAdBEjBwRIxexTevx3HLEFGAt1moKx509dhxtiIdDgJv2YaVs49B0uJvNdy6SMqNNLHsDLzDS9oZHAgMBAAGjcjBwMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUNh3o4p2C0gEYtTJrDtdDC5FYQzowDgYDVR0PAQH/BAQDAgeAMB0GA1UdDgQWBBSpg4PyGUjFPhJXCBTMzaN+mV8k9TAQBgoqhkiG92NkBgUBBAIFADANBgkqhkiG9w0BAQUFAAOCAQEAEaSbPjtmN4C/IB3QEpK32RxacCDXdVXAeVReS5FaZxc+t88pQP93BiAxvdW/3eTSMGY5FbeAYL3etqP5gm8wrFojX0ikyVRStQ+/AQ0KEjtqB07kLs9QUe8czR8UGfdM1EumV/UgvDd4NwNYxLQMg4WTQfgkQQVy8GXZwVHgbE/UC6Y7053pGXBk51NPM3woxhd3gSRLvXj+loHsStcTEqe9pBDpmG5+sk4tw+GK3GMeEN5/+e1QT9np/Kl1nj+aBw7C0xsy0bFnaAd1cSS6xdory/CUvM6gtKsmnOOdqTesbp0bs8sn6Wqs0C9dgcxRHuOMZ2tm8npLUm7argOSzQ==\";\"purchase-info\" = \"ewoJIm9yaWdpbmFsLXB1cmNoYXNlLWRhdGUtcHN0IiA9ICIyMDEzLTA2LTE5IDEzOjMyOjE5IEFtZXJpY2EvTG9zX0FuZ2VsZXMiOwoJInVuaXF1ZS1pZGVudGlmaWVyIiA9ICJjODU0OGI1YWExZjM5NDA2NmY1ZWEwM2Q3ZGU0YTBiYzdjMTEyZDk5IjsKCSJvcmlnaW5hbC10cmFuc2FjdGlvbi1pZCIgPSAiMTAwMDAwMDA3Nzk2MDgzNSI7CgkiYnZycyIgPSAiMS4xIjsKCSJ0cmFuc2FjdGlvbi1pZCIgPSAiMTAwMDAwMDA4MzE1MjA1NCI7CgkicXVhbnRpdHkiID0gIjEiOwoJIm9yaWdpbmFsLXB1cmNoYXNlLWRhdGUtbXMiID0gIjEzNzE2NzM5MzkwMDAiOwoJInVuaXF1ZS12ZW5kb3ItaWRlbnRpZmllciIgPSAiQTM3MjFCQzctNDA3Qi00QzcyLTg4RDAtMTdGNjIwRUMzNzEzIjsKCSJwcm9kdWN0LWlkIiA9ICJjb20uaGFzb2ZmZXJzLmluYXBwcHVyY2hhc2V0cmFja2VyMS5iYWxsIjsKCSJpdGVtLWlkIiA9ICI2NTMyMzA4MjkiOwoJImJpZCIgPSAiY29tLkhhc09mZmVycy5JbkFwcFB1cmNoYXNlVHJhY2tlcjEiOwoJInB1cmNoYXNlLWRhdGUtbXMiID0gIjEzNzU4MTM2NDcxMDIiOwoJInB1cmNoYXNlLWRhdGUiID0gIjIwMTMtMDgtMDYgMTg6Mjc6MjcgRXRjL0dNVCI7CgkicHVyY2hhc2UtZGF0ZS1wc3QiID0gIjIwMTMtMDgtMDYgMTE6Mjc6MjcgQW1lcmljYS9Mb3NfQW5nZWxlcyI7Cgkib3JpZ2luYWwtcHVyY2hhc2UtZGF0ZSIgPSAiMjAxMy0wNi0xOSAyMDozMjoxOSBFdGMvR01UIjsKfQ==\";\"environment\" = \"Sandbox\";\"pod\" = \"100\";\"signing-status\" = \"0\";}";
}

if (Ti.Platform.name == "android") {
	var proxy = MobileAppTrackerModule.createExample({
		message: "Creating an example Proxy",
		backgroundColor: "red",
		width: 100,
		height: 100,
		top: 100,
		left: 150
	});

	proxy.printMessage("Hello world!");
	proxy.message = "Hi world!.  It's me again.";
	proxy.printMessage("Hello world!");
	win.add(proxy);
}

