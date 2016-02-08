# FPNativeUI-ANE (is Free!)
Use native UI components in AIR iOS application with ane library <a href="http://flashpress.ru/blog/ane/native-ui/?lang=en">FPNativeUI</a>. You can create UI programmatically or with XIB in Xcode.

<table>
<tr>
<td>
<b>Components<br>supported in XIB:</b>
<ul>
	<li>UIButton</li>
	<li>UIDatePicker</li>
	<li>UIPageControl</li>
	<li>UIPickerView</li>
	<li>UISegment</li>
	<li>UISlider</li>
	<li>UIStepper</li>
	<li>UISwitch</li>
	<li>UITable</li>
	<li>UITextField</li>
	<li>UITextView</li>

	<li>UILabel</li>
	<li>UIActivityIndicatorView</li>
	<li>UIImageView</li>
	<li>UIProgressView</li>
	<li>UISearchBar</li>
	<li>UIView</li>
	<li>UIWebView</li>
</ul>
</td>
<td>
<b>Components that can be created<br>programmatically without XIB:</b>
<ul>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPButton">FPButton</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPTextField-&-FPTextArea-&-FPLabel">FPTextField</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPTextField-&-FPTextArea-&-FPLabel">FPTextArea</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPTextField-&-FPTextArea-&-FPLabel">FPLabel</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPActivityIndicatorView">FPActivityIndicatorView</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPPageControl">FPPageControl</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPSegment">FPSegment</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPSlider">FPSlider</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPStepper">FPStepper</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPSwitch">FPSwitch</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPPicker">FPPicker</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPDatePicker">FPDatePicker</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPTable">FPTable</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPSearchBar">FPSearchBar</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPWebView">FPWebView</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPVideoPlayer">FPVideoPlayer</a></li>
	<li><a href="https://github.com/flashpress/FPNativeUI/wiki/FPDocumentController">FPDocumentController</a></li>
</ul>
</td>

<td>
<b>Supported gestures:</b>
<ul>
	<li>FPTapGesture</li>
	<li>FPSwipeGesture</li>
	<li>FPRotationGesture</li>
	<li>FPPinchGesture</li>
	<li>FPPanGesture</li>
	<li>FPLongPressGesture</li>
</ul>
<a href="https://github.com/flashpress/FPNativeUI/wiki/Gesture-example">Gesture example</a>.
</td>

</tr>
</table>

# ExtensionID
```xml
<extensions>
  <extensionID>ru.flashpress.FPNativeUI</extensionID>
</extensions>
```

## Example for load XIB file:

```ActionScript
import flash.display.Sprite;
import flash.events.MouseEvent;

import ru.flashpress.nui.core.loader.FPnuiLoader;
import ru.flashpress.nui.events.FPControlEvent;
import ru.flashpress.nui.events.FPSwitchEvent;
import ru.flashpress.nui.view.FPActivityIndicatorView;
import ru.flashpress.nui.view.FPXibView;
import ru.flashpress.nui.view.control.FPButton;
import ru.flashpress.nui.view.control.FPSwitch;
import ru.flashpress.nui.view.system.FPRootView;

FPNativeUI.init();
//
var loader:FPnuiLoader = new FPnuiLoader();
var xibView:FPXibView = loader.load('MyXib');
//
var activity:FPActivityIndicatorView = xibView.childById('myActivity') as FPActivityIndicatorView;
//
var switchView:FPSwitch = xibView.childById('mySwitch') as FPSwitch;
switchView.addEventListener(FPSwitchEvent.VALUE_CHANGED, switchChangeHandler);
//
var button:FPButton = xibView.childById('myButton') as FPButton;
button.addEventListener(FPControlEvent.TOUCH_DOWN, buttonDownHandler);
//
this.stage.addEventListener(MouseEvent.CLICK, stageClickHandler);

function stageClickHandler(event:MouseEvent):void
{
	FPRootView.root.presentChild(xibView);
}

function switchChangeHandler(event:FPSwitchEvent):void
{
	if (event.on) {
		activity.startAnimating();
	} else {
		activity.stopAnimating();
	}
}

function buttonDownHandler(event:FPControlEvent):void
{
	xibView.removeFromParent();
}
```

## Create UI programmatically without XIB:
```ActionScript

import flash.geom.Rectangle;
import flash.system.Capabilities;

import ru.flashpress.nui.FPNativeUI;
import ru.flashpress.nui.constants.FPTableCellStyle;

import ru.flashpress.nui.view.control.FPTable;
import ru.flashpress.nui.events.FPTableEvent;
import ru.flashpress.nui.view.system.FPWindowView;      


FPNativeUI.init();
//
var bounds:Rectangle = new Rectangle(0, 200, Capabilities.screenResolutionX, 400);
FPWindowView.window.screen.boundsFlashToNative(bounds);
//
var table:FPTable = new FPTable();
table.frame = bounds;
table.cellStyle = FPTableCellStyle.DEFAULT;
//
table.stage.addChild(table);
table.addEventListener(FPTableEvent.SELECTED, valueChangeHandler);
//
var dataSource:Array = [];
dataSource[0] = ['value11', 'value12', 'value13'];
dataSource[1] = ['value21', 'value22', 'value23', 'value24'];
table.dataSource = dataSource;
table.titleForHeaders = new <String>['Values1', 'Values2']; 


function valueChangeHandler(event:FPTableEvent):void
{
      trace(event.index);
}
```

## Gesture examples:
```ActionScript
import flash.geom.Rectangle;

import ru.flashpress.nui.FPNativeUI;
import ru.flashpress.nui.constants.FPGestureTypes;
import ru.flashpress.nui.constants.FPSwipeDirection;

import ru.flashpress.nui.events.FPGestureEvent;
import ru.flashpress.nui.gesture.FPGesture;
import ru.flashpress.nui.gesture.FPLongPressGesture;
import ru.flashpress.nui.gesture.FPPanGesture;
import ru.flashpress.nui.gesture.FPPinchGesture;
import ru.flashpress.nui.gesture.FPRotationGesture;
import ru.flashpress.nui.gesture.FPSwipeGesture;
import ru.flashpress.nui.gesture.FPTapGesture;
import ru.flashpress.nui.view.FPViewPanel;

FPNativeUI.init();
//
var view:FPViewPanel = new FPViewPanel();
view.backgroundEnabled = true;
view.backgroundColor = 0x99ff0000;
view.frame = new Rectangle(50, 50, 200, 200);
view.cornerRadius = 20;
view.stage.addChild(view);
//
view.addEventListener(FPGestureEvent.GESTURE_ACTIVATED, gestureActivatedHandler);
view.addGesture(new FPTapGesture());
view.addGesture(new FPSwipeGesture(FPSwipeDirection.LEFT));
view.addGesture(new FPRotationGesture());
view.addGesture(new FPPinchGesture());
view.addGesture(new FPPanGesture());
view.addGesture(new FPLongPressGesture());

function gestureActivatedHandler(event:FPGestureEvent):void
{
    var gesture:FPGesture = event.gesture;
    //
    trace('-------- viewGestureActivatedHandler --------');
    trace(' target:', event.currentTarget);
    trace(' gesture:', gesture);
    trace(' state:', event.state);
    trace(' numberOfTouches:', event.numberOfTouches);
    //
    switch (gesture.type) {
        case FPGestureTypes.TAP:
            trace(' tap:', event.numberOfTapsRequired, event.numberOfTouchesRequired);
            break;
        case FPGestureTypes.SWIPE:
            trace(' swipe:', event.numberOfTouchesRequired);
            break;
        case FPGestureTypes.ROTATION:
            trace(' rotation:', event.rotation, event.velocity);
            break;
        case FPGestureTypes.PINCH:
            trace(' pinch:', event.scale, event.velocity);
            break;
        case FPGestureTypes.PAN:
            break;
        case FPGestureTypes.LONG_PRESS:
            trace(' longPress:', event.allowableMovement, event.numberOfTapsRequired, event.numberOfTouchesRequired);
            break;
    }
}
```


## Video demonstration
<a href="http://www.youtube.com/watch?v=Q4J0oH8fTf0&list=PLw76-mHQ5mheGLkWjIW4pM3tWylz5R_Ct">Youtube playlist</a>
