// An example MobileAppTracker implementation

window.onload = init;

// Initialize MAT and set any optional params
function init()
{
    MobileAppTracker.init("877", "com.hasofferstestapp", MobileAppTracker.PLATFORM_ANDROID, "1");
    MobileAppTracker.setAppName("JS Test");

    MobileAppTracker.setDebugMode(true);
    MobileAppTracker.setAllowDuplicates(true);

    console.log("MobileAppTracker initialized");
}

// Track an app install, should be called after directly after init
function trackInstall()
{
    MobileAppTracker.trackInstall();
    console.log("trackInstall called");
}

// Track an app open, should be called directly after install
function trackOpen()
{
    MobileAppTracker.trackAction("open");
    console.log("trackAction(\"open\") called");
}

// Track an app event, you may define event name, optional: revenue, currency, advertiser reference id
function trackAction()
{
    MobileAppTracker.trackAction("test", 1, "USD", "ref_id");
    console.log("trackAction(\"test\", 1, \"USD\", \"ref_id\") called");
}

// Track an app event with additional event items information in addition to previous parameters
function trackEventItem()
{
    var eventItems = new Array();
    var eventItem = new MATEventItem({
        item: "item1",
        quantity: 1,
        unit_price: 0.99,
        revenue: 0.99,
        attribute_sub1: "1",
        attribute_sub2: "2",
        attribute_sub3: "3",
        attribute_sub4: "4",
        attribute_sub5: "5"
    });
    eventItems[0] = eventItem;

    var eventItem2 = new MATEventItem({
        item: "item2",
        quantity: 2,
        unit_price: 0.50,
        revenue: 1
    });
    eventItems[1] = eventItem2;
    
    MobileAppTracker.trackAction("test event item", 1, "USD", "", eventItems);
}
