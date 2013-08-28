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
        MATSetLocation(123.456, 67.3257, 258.09);
        
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
        //MATTrackInstallWithReferenceId("Marmalade Install Test");
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
        //void MATTrackActionForEventIdOrName(const char* eventIdOrName, bool isId, const char* refId)
        MATTrackActionForEventIdOrName("testDCLEventItemRef", false, "testDCLRef");
        sprintf(g_TouchEventMsg, "`x666666MAT SDK Event with Reference Sent");
    }
    if (isPointInButton(event, sendEventBtn))
    {
        MATSDKEventItem *items = (MATSDKEventItem *)s3eMalloc(sizeof(MATSDKEventItem) * 2);
        
        strncpy(items[0].name, "coin", S3E_MATSDK_STRING_MAX);
        items[0].unitPrice = 1.55f;
        items[0].quantity = 1;
        items[0].revenue = 1.55f;
        strncpy(items[0].attribute1, "attrib_1_1", S3E_MATSDK_STRING_MAX);
        strncpy(items[0].attribute2, "attrib_1_2", S3E_MATSDK_STRING_MAX);
        strncpy(items[0].attribute3, "attrib_1_3", S3E_MATSDK_STRING_MAX);
        strncpy(items[0].attribute4, "attrib_1_4", S3E_MATSDK_STRING_MAX);
        strncpy(items[0].attribute5, "attrib_1_5", S3E_MATSDK_STRING_MAX);
        
        strncpy(items[1].name, "sword", S3E_MATSDK_STRING_MAX);
        items[1].unitPrice = 2.10f;
        items[1].quantity = 1;
        items[1].revenue = 2.00f;
        strncpy(items[1].attribute1, "attrib_2_1", S3E_MATSDK_STRING_MAX);
        strncpy(items[1].attribute3, "attrib_2_3", S3E_MATSDK_STRING_MAX);
        strncpy(items[1].attribute5, "attrib_2_5", S3E_MATSDK_STRING_MAX);
        
        MATArray array;
        array.m_count = 2;
        array.m_items = items;
        
//        s3eDebugTracePrintf("MATSDK events array: %i", array.m_count);
//        for (uint i=0; i < array.m_count; i++) {
//            s3eDebugTracePrintf("Item %s, unitPrice %f, quanity %i, revenue %f, attr1 %s, attr2 %s, attr3 %s, attr4 %s, attr5 %s",
//                          ((MATSDKEventItem*)array.m_items)[i].item,
//                          ((MATSDKEventItem*)array.m_items)[i].unitPrice,
//                          ((MATSDKEventItem*)array.m_items)[i].quantity,
//                          ((MATSDKEventItem*)array.m_items)[i].revenue,
//                          ((MATSDKEventItem*)array.m_items)[i].attribute1,
//                          ((MATSDKEventItem*)array.m_items)[i].attribute2,
//                          ((MATSDKEventItem*)array.m_items)[i].attribute3,
//                          ((MATSDKEventItem*)array.m_items)[i].attribute4,
//                          ((MATSDKEventItem*)array.m_items)[i].attribute5);
//        }

        double revAmount = 1.67;
        MATTrackActionForEventIdOrNameItems("testDCLEventItems",
                                                 false,
                                                 &array,
                                                 "testdclitems",
                                                 revAmount,
                                                 "USD",
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
