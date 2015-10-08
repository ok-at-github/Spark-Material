package spark.material.components
{
	import flash.display.InteractiveObject;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	
	import mx.core.mx_internal;
	import mx.graphics.SolidColorStroke;
	
	import spark.components.DropDownList;
	import spark.core.IDisplayText;
	import spark.events.DropDownEvent;
	import spark.material.skins.DropDownListSkin;
	import spark.utils.LabelUtil;
	
	use namespace mx_internal;
	
	[SkinState("normalError")]
	[SkinState("normalFocused")]
	[SkinState("normalFocusedError")]
	[SkinState("normalWithFloatPrompt")]
	[SkinState("normalWithFloatPromptError")]
	[SkinState("normalFocusedWithFloatPrompt")]
	[SkinState("normalFocusedWithFloatPromptError")]
	[SkinState("openError")]
	[SkinState("openFocused")]
	[SkinState("openFocusedError")]
	[SkinState("openWithFloatPrompt")]
	[SkinState("disabledWithFloatPrompt")]
	[SkinState("disabledWithFloatPromptError")]
	
	public class DropDownList extends spark.components.DropDownList
	{
		[SkinPart(required="false")]
		public var promptDisplay:IDisplayText;
		
		[SkinPart(required="false")]
		public var borderStroke:SolidColorStroke;
		
		public function DropDownList()
		{
			super();
			
			if(!getStyle("skinClass"))
				setStyle("skinClass", DropDownListSkin);
			
			setStyle("focusSkin", null);
			
			addEventListener(DropDownEvent.CLOSE, onDropDownClose);
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance == promptDisplay)
			{
				promptDisplay.text = prompt;
			}
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
		
		override mx_internal function updateLabelDisplay(displayItem:* = undefined):void
		{
			if(labelDisplay)
			{
				if(displayItem == undefined)
					displayItem = selectedItem;
				
				if(displayItem != null && displayItem != undefined)
				{
					labelDisplay.text = LabelUtil.itemToLabel(displayItem, labelField, labelFunction);
					labelDisplay["visible"] = true;
				}
				else
				{
					if(labelDisplay["visible"] && skin.currentState.indexOf("WithFloatPrompt") != -1)
						skin.currentState = skin.currentState.slice(0,skin.currentState.indexOf("WithFloatPrompt"));
										
					labelDisplay["visible"] = false;
					if(promptDisplay)
						promptDisplay.text = prompt;					
				}
			}
			
			if(focusManager && focusManager.getFocus() != focusManager.findFocusManagerComponent(this) && skin.currentState.indexOf("Focused") != -1)
			{
				skin.currentState = skin.currentState.substr(0,skin.currentState.indexOf("Focused")).substr(skin.currentState.indexOf("Focused"), skin.currentState.length);
			}
		}
		
		override public function set selectedItem(value:*):void
		{
			super.selectedItem = value;			
		}
		
		protected function onDropDownClose(evt:DropDownEvent):void
		{
			var focusPoint:Point = new Point(stage.mouseX, stage.mouseY);
			var objectsUnderPoint:Array = stage.getObjectsUnderPoint(focusPoint);
			stage.focus = InteractiveObject(objectsUnderPoint.pop().parent);
		}
		
		override protected function focusInHandler(event:FocusEvent):void
		{
			super.focusInHandler(event);
			invalidateSkinState();
		}
		
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusInHandler(event);
			invalidateSkinState();
		}
		
		override protected function getCurrentSkinState():String
		{
			var skinState:String = super.getCurrentSkinState();
						
			if(enabled && focusManager && focusManager.getFocus() == focusManager.findFocusManagerComponent(this))
			{
				skinState += "Focused";
				
				if(openButton)
					openButton.skin.currentState = "down";
				
				if(selectedIndex != -1)
					skinState += "WithFloatPrompt";
			}
			else if(prompt != null && prompt != "" && selectedIndex != -1)
			{
				skinState += "WithFloatPrompt";
			}
			
			if(showErrorSkin)
				skinState += "Error";
			
			trace(skinState);
			return skinState;
		}
	}
}