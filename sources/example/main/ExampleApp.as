package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ru.flashpress.nui.FPNativeUI;
	import ru.flashpress.nui.core.loader.FPnuiLoader;
	import ru.flashpress.nui.events.FPControlEvent;
	import ru.flashpress.nui.events.FPSwitchEvent;
	import ru.flashpress.nui.view.FPActivityIndicatorView;
	import ru.flashpress.nui.view.FPXibView;
	import ru.flashpress.nui.view.control.FPButton;
	import ru.flashpress.nui.view.control.FPSwitch;

	public class ExampleApp extends Sprite
	{
		private var xibView:FPXibView;
		private var activity:FPActivityIndicatorView;
		public function ExampleApp()
		{
			super();
			//
			FPNativeUI.init();
			//
			var loader:FPnuiLoader = new FPnuiLoader();
			xibView = loader.load('MyXib');
			//
			activity = xibView.childById('myActivity') as FPActivityIndicatorView;
			//
			var switchView:FPSwitch = xibView.childById('mySwitch') as FPSwitch;
			switchView.addEventListener(FPSwitchEvent.VALUE_CHANGED, switchChangeHandler);
			//
			var button:FPButton = xibView.childById('myButton') as FPButton;
			button.addEventListener(FPControlEvent.TOUCH_DOWN, buttonDownHandler);
			//
			this.stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
		}
		
		private function stageClickHandler(event:MouseEvent):void
		{
			xibView.root.presentChild(xibView);
		}
		
		private function switchChangeHandler(event:FPSwitchEvent):void
		{
			if (event.on) {
				activity.startAnimating();
			} else {
				activity.stopAnimating();
			}
		}
		
		private function buttonDownHandler(event:FPControlEvent):void
		{
			xibView.removeFromParent();
		}
	}
}