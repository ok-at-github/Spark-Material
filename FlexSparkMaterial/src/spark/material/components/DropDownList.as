package spark.material.components
{
	import flash.events.FocusEvent;
	
	import mx.core.mx_internal;
	import mx.graphics.SolidColorStroke;
	
	import spark.components.DropDownList;
	import spark.material.skins.DropDownListSkin;
	
	use namespace mx_internal;
	
	[SkinState("normalFocused")]
	[SkinState("normalWithFloatPrompt")]
	[SkinState("normalWithFloatPromptError")]
	[SkinState("normalFocusedWithFloatPrompt")]
	[SkinState("normalFocusedWithFloatPromptError")]
	[SkinState("disabledWithFloatPrompt")]
	[SkinState("disabledWithFloatPromptError")]
	
	public class DropDownList extends spark.components.DropDownList
	{
		[SkinPart(required="false")]
		public var borderStroke:SolidColorStroke;
		
		public function DropDownList()
		{
			super();
			
			if(!getStyle("skinClass"))
				setStyle("skinClass", DropDownListSkin);
			
			setStyle("focusSkin", null);
		}
		
		private var showErrorSkin:Boolean;
		
		mx_internal override function updateErrorSkin():void
		{
			if(errorString != null && errorString != "" && getStyle("showErrorSkin"))
			{
				showErrorSkin = true;
				if(skin.currentState.indexOf("Error") == -1)
					skin.currentState += "Error";
			}
			else
			{
				showErrorSkin = false;
				if(skin.currentState.indexOf("Error") != -1)
					skin.currentState = skin.currentState.substr(0, skin.currentState.indexOf("Error"));
			}
		}
		
		private var hasFocus:Boolean;
		override protected function focusInHandler(event:FocusEvent):void
		{
			super.focusInHandler(event);
			
			focusManager.hideFocus();
			invalidateSkinState();
		}
		
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusInHandler(event);
			hasFocus = false;
			invalidateSkinState();
		}
		
		override protected function getCurrentSkinState():String
		{
			var skinState:String = super.getCurrentSkinState();
			
			if(skinState == "open")
				return skinState;
			
			if(openButton)
				openButton.skin.currentState = selectedIndex == -1 ? "up" : "down";
			
			if(enabled && focusManager && focusManager.getFocus() == focusManager.findFocusManagerComponent(this))
			{
				skinState += "Focused";
				
				if(prompt != null && prompt != "")
					skinState += "WithFloatPrompt";
				
				if(openButton)
					openButton.skin.currentState = "down";
			}
			else if(prompt != null && prompt != "")
			{
				if(selectedIndex != -1)
					skinState += "WithFloatPrompt";
				else
					skinState += "WithPrompt";
			}
			
			if(showErrorSkin)
				skinState += "Error";
			
			return skinState;
		}
	}
}