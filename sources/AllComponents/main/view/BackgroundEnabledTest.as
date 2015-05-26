/**
 * Created by sam on 28.04.15.
 */
package view
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    import ru.flashpress.nui.events.FPControlEvent;
    import ru.flashpress.nui.events.FPSliderEvent;
    import ru.flashpress.nui.events.FPSwitchEvent;
    import ru.flashpress.nui.view.control.FPButton;
    import ru.flashpress.nui.view.control.FPSlider;
    import ru.flashpress.nui.view.control.FPSwitch;

    public class BackgroundEnabledTest extends TestBase
    {
        private var stage:Stage;
        public function BackgroundEnabledTest(stage:Stage)
        {
            super('BackgroundEnabledTest');
            this.stage = stage;
            //
            create();
        }

        private var flashView:Sprite;
        //
        private var addWithAnim:FPSwitch;
        private var backgroundAlpha:FPSlider;
        private var backgroundEnabled:FPSwitch;
        private var nativeButton:FPButton;
        protected override function create():void
        {
            super.create();
            //
            addWithAnim = xibView.childById('addWithAnimSwitch') as FPSwitch;
            //
            backgroundAlpha = xibView.childById('backgroundAlphaSlider') as FPSlider;
            backgroundAlpha.minimumValue = 0;
            backgroundAlpha.maximumValue = 1;
            backgroundAlpha.value = 1;
            backgroundAlpha.addEventListener(FPSliderEvent.VALUE_CHANGED, backgroundAlphaChangeHandler);
            //
            backgroundEnabled = xibView.childById('backEnabledSwitch') as FPSwitch;
            backgroundEnabled.addEventListener(FPSwitchEvent.VALUE_CHANGED, backgroundEnabledChangeHandler);
            backgroundEnabled.on = false;
            //
            nativeButton = xibView.childById('nativeButton') as FPButton;
            nativeButton.addEventListener(FPControlEvent.TOUCH_DOWN, closeDownHandler);
            //
            var buttonFrame:Rectangle = nativeButton.frame;
            nativeButton.window.screen.boundsNativeToFlash(buttonFrame);
            //
            flashView = new Sprite();
            var flButton:FLButton = new FLButton('flash button', buttonFrame.width, buttonFrame.height);
            flashView.addChild(flButton);
            flButton.x = 60;
            flButton.y = buttonFrame.y;
            flButton.addEventListener(MouseEvent.CLICK, flButtonClickHandler);
        }

        public override function show():void
        {
            stage.addChild(flashView);
        }
        public override function hide():void
        {
            super.hide();
            if (stage.contains(flashView)) stage.removeChild(flashView);
        }

        private function flButtonClickHandler(event:MouseEvent):void
        {
            if (!xibView.parent) {
                if(addWithAnim.on) {
                    xibView.root.presentChild(xibView);
                } else {
                    xibView.root.addChild(xibView);
                    xibView.y = 0;
                }
            } else {
                xibView.removeFromParent(true);
            }
        }

        private function backgroundAlphaChangeHandler(event:FPSliderEvent):void
        {
            xibView.backgroundAlpha = event.value;
        }

        private function backgroundEnabledChangeHandler(event:FPSwitchEvent):void
        {
            xibView.backgroundEnabled = event.on;
        }

        private function closeDownHandler(event:FPControlEvent):void
        {
            xibView.removeFromParent(true);
        }
    }
}

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;


class FLButton extends Sprite
{
    public function FLButton(label:String, width:Number, height:Number)
    {
        var textField:TextField = new TextField();
        var format:TextFormat = new TextFormat('Tahoma', 35, 0xffff00);
        format.align = TextFormatAlign.CENTER;
        textField.defaultTextFormat = format;
        textField.text = label;
        this.addChild(textField);
        textField.width = width;
        textField.height = 50;
        textField.y = (height-textField.height)/2;
        textField.mouseWheelEnabled = false;
        //
        this.graphics.beginFill(0xff0000, 1);
        this.graphics.drawRect(0, 0, width, height);
        this.graphics.endFill();
        //
        this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
        this.addEventListener(MouseEvent.MOUSE_UP, upHandler);
    }

    private var glow:GlowFilter = new GlowFilter(0x999999, 0.8, 30, 30, 2, 3);
    private function downHandler(event:MouseEvent):void
    {
        this.filters = [glow];
        this.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
    }
    private function upHandler(event:MouseEvent):void
    {
        this.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
        this.filters = [];
    }
}