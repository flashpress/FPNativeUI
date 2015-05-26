# FPNativeUI-ANE
Use native UI components in AIR iOS application. You can create UI programmatically or with XIB in Xcode.

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
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:ButtonProgrammatically">FPButton</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:TextProgrammatically">FPTextField</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:TextProgrammatically">FPTextArea</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:TextProgrammatically">FPLabel</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:ActivityProgrammatically">FPActivityIndicatorView</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:PageControlProgrammatically">FPPageControl</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:SegmentProgrammatically">FPSegment</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:SliderProgrammatically">FPSlider</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:StepperProgrammatically">FPStepper</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:SwitchProgrammatically">FPSwitch</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:PickerProgrammatically">FPPicker</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:DatePickerProgrammatically">FPDatePicker</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:TableProgrammatically">FPTable</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:SearchBarProgrammatically">FPSearchBar</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:WebViewProgrammatically">FPWebView</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:VideoPlayerExample">FPVideoPlayer</a></li>
	<li><a href="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:DocumentTest">FPDocumentController</a></li>
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
<a onclick="http://flashpress.ru/blog/ane/native-ui/?lang=en#examples:GestureTest" href="#examples">Gesture examples</a>.
</td>

</tr>
</table>

Example for load XIB file:

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