#include "s3e.h"
#include "s3eMATSDK.h"
#include <memory.h>
#include <string.h>
#include <stdio.h>
#include "ExamplesMain.h"
#include "s3eDevice.h"

//Simple structure to track touches
struct CTouch
{
	int32 x; // position x
	int32 y; // position y
	bool active; // is touch active (currently down)
	int32 id; // touch's unique identifier
};


bool g_UseMultiTouch = false;
char g_TouchEventMsg[128] = {0};
#define MAX_TOUCHES 10


Button* startBtn = 0;
Button* showParmsBtn = 0;
Button* sendInstallBtn = 0;
Button* sendEventBtn = 0;
Button* sendEventRefBtn = 0;
Button* setDebugBtn = 0;

bool shouldDebug = false;
char g_package_name[128] = {0};
char g_site_id[128] = {0};

bool isPointInButton(s3ePointerEvent* event, Button* button)
{
	if (event->m_x < button->m_XPos)
		return false;
	
	if (event->m_x > button->m_XPos + button->m_Width)
		return false;
	
	if (event->m_y < button->m_YPos)
		return false;
	
	if (event->m_y > button->m_YPos + button->m_Height)
		return false;
	
	return true;
}

void SingleTouchButtonCB(s3ePointerEvent* event)
{
	// Don't register press events, actions will occur on release.
	if (event->m_Pressed)
	{
		return;
	}
	
    if (isPointInButton(event, startBtn))
    {
        MATStartMobileAppTracker("877", "8c14d6bbe466b65211e781d62e301eec");
        MATSetPackageName(g_package_name);
        MATSetSiteId(g_site_id);
        
        MATSetAge(52);
        MATSetGender(1);
        
        char strLat[32];
        char strLong[32];
        char strAlt[32];
        sprintf(strLat, "%f", 123.456f);
        sprintf(strLong, "%f", 67.3257f);
        sprintf(strAlt, "%f", 258.09f);
        
        MATSetLocation(strLat, strLong, strAlt);
        
        // testing set delegate
        MATSetDelegate(true);
        
        sprintf(g_TouchEventMsg, "`x666666MAT SDK Started %s %s", g_package_name, g_site_id);
    }
    if (isPointInButton(event, showParmsBtn))
    {
        MATSDKParameters();
    }
    if (isPointInButton(event, sendInstallBtn))
    {
        MATTrackInstall();
        sprintf(g_TouchEventMsg, "`x666666MAT SDK Install sent");
    }
    if (isPointInButton(event, setDebugBtn))
    {
        shouldDebug = !shouldDebug;
        MATSetDebugMode(shouldDebug);
		MATSetAllowDuplicates(shouldDebug);
        sprintf(g_TouchEventMsg, "`x666666Debug Set to %s", (shouldDebug)?"true":"false");
    }
    if (isPointInButton(event, sendEventRefBtn))
    {
        char strRevenue[32];
        sprintf(strRevenue, "%f", 12.34f);
        
        MATTrackAction("testDCLEventItemRef", false, strRevenue, "GBP");
        sprintf(g_TouchEventMsg, "`x666666MAT SDK Event with Reference Sent");
    }
    if (isPointInButton(event, sendEventBtn))
    {
        MATSDKEventItem *items = (MATSDKEventItem *)s3eMalloc(sizeof(MATSDKEventItem) * 2);
        
        char strUnitPrice1[32];
        sprintf(strUnitPrice1, "%f", 1.55f);
        
        char strRevenue1[32];
        sprintf(strRevenue1, "%f", 1.55f);
        
        strncpy(items[0].name, "coin", S3E_MATSDK_STRING_MAX);
        strncpy(items[0].unitPrice, strUnitPrice1, S3E_MATSDK_STRING_MAX);
        items[0].quantity = 1;
        strncpy(items[0].revenue, strRevenue1, S3E_MATSDK_STRING_MAX);
        strncpy(items[0].attribute1, "attrib_1_1", S3E_MATSDK_STRING_MAX);
        strncpy(items[0].attribute2, "attrib_1_2", S3E_MATSDK_STRING_MAX);
        strncpy(items[0].attribute3, "attrib_1_3", S3E_MATSDK_STRING_MAX);
        strncpy(items[0].attribute4, "attrib_1_4", S3E_MATSDK_STRING_MAX);
        strncpy(items[0].attribute5, "attrib_1_5", S3E_MATSDK_STRING_MAX);
        
        char strUnitPrice2[32];
        sprintf(strUnitPrice2, "%f", 2.10f);
        
        char strRevenue2[32];
        sprintf(strRevenue2, "%f", 2.10f);
        
        strncpy(items[1].name, "sword", S3E_MATSDK_STRING_MAX);
        strncpy(items[1].unitPrice, strUnitPrice2, S3E_MATSDK_STRING_MAX);
        items[1].quantity = 1;
        strncpy(items[1].revenue, strRevenue2, S3E_MATSDK_STRING_MAX);
        strncpy(items[1].attribute1, "attrib_2_1", S3E_MATSDK_STRING_MAX);
        strncpy(items[1].attribute3, "attrib_2_3", S3E_MATSDK_STRING_MAX);
        strncpy(items[1].attribute5, "attrib_2_5", S3E_MATSDK_STRING_MAX);
        
        MATArray array;
        array.m_count = 2;
        array.m_items = items;
        
        char strRevAmount[32];
        sprintf(strRevAmount, "%f", 13.67f);
        
        MATTrackActionForEventIdOrNameItems("testDCLEventItems",
                                                 false,
                                                 &array,
                                                 "testdclitems",
                                                 strRevAmount,
                                                 "GBP",
                                                 0,
                                                 NULL,
                                                 NULL);
        sprintf(g_TouchEventMsg, "`x666666MAT SDK Event Sent");
    }

}


void SingleTouchMotionCB(s3ePointerMotionEvent* event)
{

}

//--------------------------------------------------------------------------
void ExampleInit()
{
	//Register for standard pointer events
	s3ePointerRegister(S3E_POINTER_BUTTON_EVENT, (s3eCallback)SingleTouchButtonCB, NULL);
	s3ePointerRegister(S3E_POINTER_MOTION_EVENT, (s3eCallback)SingleTouchMotionCB, NULL);
    
	// Init buttons.
	startBtn = NewButton("Start MAT SDK");
	showParmsBtn = NewButton("Show SDK Parameters");
	sendInstallBtn = NewButton("Send Install");
    sendEventRefBtn = NewButton("Send Event With Ref");
	sendEventBtn = NewButton("Send Event Items");
    setDebugBtn = NewButton("Set Debug on/off");
	
    int32 osInt = s3eDeviceGetInt(S3E_DEVICE_OS);
    if (osInt == S3E_OS_ID_ANDROID)
    {
        strcpy(g_package_name, "com.marmaladeandroidtest");
        strcpy(g_site_id, "7488");
    }
    else
    {
        strcpy(g_package_name, "2GLFC47AY5.com.hasoffers.marmaladeTestApp");
        strcpy(g_site_id, "6864");
    }
	SetButtonScale(2);
    
}


//--------------------------------------------------------------------------
void ExampleShutDown()
{
	s3ePointerUnRegister(S3E_POINTER_BUTTON_EVENT, (s3eCallback)SingleTouchButtonCB);
	s3ePointerUnRegister(S3E_POINTER_MOTION_EVENT, (s3eCallback)SingleTouchMotionCB);
	
	DeleteButtons();
}


//--------------------------------------------------------------------------
bool ExampleUpdate()
{
	s3ePointerRegister(S3E_POINTER_BUTTON_EVENT, (s3eCallback)SingleTouchButtonCB, NULL);
	s3ePointerRegister(S3E_POINTER_MOTION_EVENT, (s3eCallback)SingleTouchMotionCB, NULL);

	return true;
}

void ExampleRender()
{
    // Get pointer to the screen surface
    // (pixel depth is 2 bytes by default)
    uint16* screen = (uint16*)s3eSurfacePtr();
    int height = s3eSurfaceGetInt(S3E_SURFACE_HEIGHT);
    int width = s3eSurfaceGetInt(S3E_SURFACE_WIDTH);
    int pitch = s3eSurfaceGetInt(S3E_SURFACE_PITCH);
    
    // Clear screen to white
    for (int i=0; i < height; i++)
    {
        memset((char*)screen + pitch * i, 255, (width * 2));
    }
    
    // This was causing an error to pop up.
    s3ePointerUpdate();
    
    ButtonsRender();
    
    s3eDebugPrint(20, 365, g_TouchEventMsg, 1);
}

void ExampleTerm()
{
}
