package com.hasoffers.nativeExtensions
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.utils.Dictionary;
	
	[RemoteClass(alias="com.hasoffers.nativeExtensions.MobileAppTracker")]
	public class MobileAppTracker extends EventDispatcher
	{
		// If the AIR application creates multiple MobileAppTracker objects,
		// all the objects share one instance of the ExtensionContext class.
		private static var extId:String = "com.hasoffers.MobileAppTracker";
		private static var extContext:ExtensionContext = null;
		public var advertiserId:String;
		public var key:String;
		
		private static var _instance:MobileAppTracker = null;
		
		public static function get instance():MobileAppTracker {
			trace ("MATAS.instance");
			if (_instance == null)
			{
				_instance = new MobileAppTracker(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function MobileAppTracker(enforcer:SingletonEnforcer)
		{
			trace ("MATAS.Constructor");
			if (enforcer == null) throw new Error("Invalid singleton access. Please use MobileAppTracker.instance() instead.");
		}
		
		public function init(advertiserId:String, key:String):void
		{
			trace ("MATAS.init(" + advertiserId + ", " + key + ")");
			// If the one instance of the ExtensionContext class has not
			// yet been created, create it now.
			if (!extContext)
			{
				if(null == advertiserId || null == key || 0 == advertiserId.length || 0 == key.length)
				{
					throw new Error("advertiser id and key cannot be null or empty"); 
				}
				
				this.advertiserId = advertiserId;
				this.key = key;
				
				initExtension(advertiserId, key);
			}
		}
		
		// Initialize the extension by calling our "initNativeCode" ANE function
		private static function initExtension(advertiserId:String, key:String):void
		{
			trace ("MATAS.initExtension(" + advertiserId + ", " + key + "): Create an extension context");
			
			// The extension context's context type is NULL, because this extension
			// has only one context type.
			extContext = ExtensionContext.createExtensionContext(extId, null);
			
			if ( extContext )
			{
				extContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
				
				trace ("MATAS.initExtension: calling initNativeCode");
				extContext.call(NativeMethods.initNativeCode, advertiserId, key);
			}
			else
			{
				trace ("MATAS.initExtension: extContext = null");
				throw new Error("Error when instantiating MobileAppTracker native extension." );
			}
		}
		
		public function trackInstall(refId:String=null):void
		{
			trace ("MATAS.trackInstall()");
			extContext.call(NativeMethods.trackInstall, refId);
		}

		public function trackAction(event:String, revenue:Number=0, currency:String="USD", refId:String=null, isEventId:Boolean=false):void
		{
			trace("MATAS.trackAction(" + event + ", " + revenue.toString() + ", " + currency + ", " + refId + ", " + isEventId + ")");
			extContext.call(NativeMethods.trackAction, event, revenue, currency, refId, isEventId);
		}

		public function trackActionWithEventItem(event:String, eventItems:Array, revenue:Number=0, currency:String="USD", refId:String=null, isEventId:Boolean=false, transactionState:int=0):void
		{
			trace("MATAS.trackActionWithEventItem(" + event + ")");
			
			var arrItems:Array = new Array();
			
			for each (var dictItem:Dictionary in eventItems)
			{
				arrItems.push(new String(dictItem.item));
				arrItems.push(new String(dictItem.unit_price));
				arrItems.push(new String(dictItem.quantity));
				arrItems.push(new String(dictItem.revenue));
			}
			
			extContext.call(NativeMethods.trackActionWithEventItem, event, arrItems, revenue, currency, refId, isEventId, transactionState);
		}
		
		public function trackUpdate(refId:String=null):void
		{
			trace("MATAS.trackUpdate(refId:String=null)");
			extContext.call(NativeMethods.trackUpdate, refId);
		}
		
		public function startAppToAppTracking(targetAppId:String, advertiserId:String, offerId:String, publisherId:String, shouldRedirect:Boolean):void
		{
			trace("MATAS.startAppToAppTracking()");
			extContext.call(NativeMethods.startAppToAppTracking, targetAppId, advertiserId, offerId, publisherId, shouldRedirect);
		}
		
		public function setAdvertiserIdentifier(advertiserIdentifier:String):void
		{
			trace("MATAS.setAdvertiserIdentifier(" + advertiserIdentifier + ")");
			extContext.call(NativeMethods.setAdvertiserIdentifier, advertiserIdentifier);
		}

		public function setCurrencyCode(currencyCode:String):void
		{
			trace("MATAS.setCurrencyCode(" + currencyCode + ")");
			extContext.call(NativeMethods.setCurrencyCode, currencyCode);
		}

		public function setDebugMode(enable:Boolean):void
		{
			trace("MATAS.setDebugMode(" + enable + ")");
			extContext.call(NativeMethods.setDebugMode, enable);
		}

		public function setPackageName(packageName:String):void
		{
			trace("MATAS.setPackageName(" + packageName + ")");
			extContext.call(NativeMethods.setPackageName, packageName);
		}
		
		public function setRedirectUrl(redirectUrl:String):void
		{
			trace("MATAS.setRedirectUrl(" + redirectUrl + ")");
			extContext.call(NativeMethods.setRedirectUrl, redirectUrl);
		}
		
		public function setUseCookieTracking(useCookieTracking:Boolean):void
		{
			trace("MATAS.setDebugMode(" + useCookieTracking + ")");
			extContext.call(NativeMethods.setDebugMode, useCookieTracking);
		}
		
		public function setUseHTTPS(useHTTPS:Boolean):void
		{
			trace("MATAS.setUseHTTPS(" + useHTTPS + ")");
			extContext.call(NativeMethods.setDebugMode, useHTTPS);
		}
		
		public function setSiteId(siteId:String):void
		{
			trace("MATAS.setSiteId(" + siteId + ")");
			extContext.call(NativeMethods.setSiteId, siteId);
		}

		public function setTRUSTeId(tpid:String):void
		{
			trace("MATAS.setTRUSTeId(" + tpid + ")");
			extContext.call(NativeMethods.setTRUSTeId, tpid);
		}
		
		public function setVendorIdentifier(vendorId:String):void
		{
			trace("MATAS.setVendorIdentifier(" + vendorId + ")");
			extContext.call(NativeMethods.setVendorIdentifier, vendorId);
		}

		public function setUserId(userId:String):void
		{
			trace("MATAS.setUserId(" + userId + ")");
			extContext.call(NativeMethods.setUserId, userId);
		}
		
		public function setDeviceId(enable:Boolean):void
		{
			trace("MATAS.setDeviceId(" + enable + ")");
			extContext.call(NativeMethods.setDeviceId, enable);
		}
		
		public function setOpenUDID(openUDID:String):void
		{
			trace("MATAS.setOpenUDID(" + openUDID + ")");
			extContext.call(NativeMethods.setOpenUDID, openUDID);
		}
		
		public function setAllowDuplicates(allowDuplicates:Boolean):void
		{
			trace("MATAS.setAllowDuplicates(" + allowDuplicates + ")");
			extContext.call(NativeMethods.setAllowDuplicates, allowDuplicates);
		}
		
		public function setShouldAutoGenerateAdvertiserIdentifier(shouldAutoGenerate:Boolean):void
		{
			trace("MATAS.setShouldAutoGenerateAdvertiserIdentifier(" + shouldAutoGenerate + ")");
			extContext.call(NativeMethods.setShouldAutoGenerateAdvertiserIdentifier, shouldAutoGenerate);
		}
		
		public function setShouldAutoGenerateMacAddress(shouldAutoGenerate:Boolean):void
		{
			trace("MATAS.setShouldAutoGenerateMacAddress(" + shouldAutoGenerate + ")");
			extContext.call(NativeMethods.setShouldAutoGenerateMacAddress, shouldAutoGenerate);
		}
		
		public function setShouldAutoGenerateODIN1Key(shouldAutoGenerate:Boolean):void
		{
			trace("MATAS.setShouldAutoGenerateODIN1Key(" + shouldAutoGenerate + ")");
			extContext.call(NativeMethods.setShouldAutoGenerateODIN1Key, shouldAutoGenerate);
		}
		
		public function setShouldAutoGenerateOpenUDIDKey(shouldAutoGenerate:Boolean):void
		{
			trace("MATAS.setShouldAutoGenerateOpenUDIDKey(" + shouldAutoGenerate + ")");
			extContext.call(NativeMethods.setShouldAutoGenerateOpenUDIDKey, shouldAutoGenerate);
		}
		
		public function setShouldAutoGenerateVendorIdentifier(shouldAutoGenerate:Boolean):void
		{
			trace("MATAS.setShouldAutoGenerateVendorIdentifier(" + shouldAutoGenerate + ")");
			extContext.call(NativeMethods.setShouldAutoGenerateVendorIdentifier, shouldAutoGenerate);
		}
		
		public function setDelegate(enable:Boolean):void
		{
			trace("MATAS.setDelegate(" + enable + ")");
			extContext.call(NativeMethods.setDelegate, enable);
		}
		
		public function getSDKDataParameters():String
		{
			trace("MATAS.getSDKDataParameters()");
			return extContext.call(NativeMethods.getSDKDataParameters) as String;
		}
		
		public static function onStatusEvent(event:StatusEvent):void
		{
			trace("MATAS.statusHandler(): " + event);
			
			if("success" == event.code)
			{
				trackerDidSucceed(event.level);
			}
			else if("failure" == event.code)
			{
				trackerDidFail(event.level);
			}
		}
		
		public static function trackerDidSucceed(data:String):void
		{
			trace("MATAS.trackerDidSucceed()");
			trace("MATAS.data = " + data);
		}
		
		public static function trackerDidFail(error:String):void
		{
			trace("MATAS.trackerDidFail()");
			trace("MATAS.error = " + error);
		}
	}
}