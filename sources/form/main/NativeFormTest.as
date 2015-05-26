/**
 * Created by sam on 03.05.15.
 */
package
{
    import flash.display.Bitmap;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    import ru.flashpress.nui.FPNativeUI;
    import ru.flashpress.nui.constants.FPTextBorderStyle;
    import ru.flashpress.nui.constants.FPTextFieldViewMode;
    import ru.flashpress.nui.constants.FPTextKeyboardTypes;
    import ru.flashpress.nui.events.FPKeyboardEvent;
    import ru.flashpress.nui.events.FPTextFieldEvent;
    import ru.flashpress.nui.keyboard.FPKeyboard;
    import ru.flashpress.nui.keyboard.FPKeyboardInfo;
    import ru.flashpress.nui.view.system.FPStageView;
    import ru.flashpress.nui.view.system.FPWindowView;
    import ru.flashpress.nui.view.text.FPTextField;
    import ru.flashpress.tween.FPTween;
    import ru.flashpress.tween.core.constants.FPTEaseTypes;
    import ru.flashpress.tween.ease.FPTEaseQuad;
    import ru.flashpress.tween.ease.FPTEaseStrong;
    import ru.flashpress.tween.events.FPTEvent;

    public class NativeFormTest extends Sprite
    {
        [Embed(source="logo.png")]
        private static var LogoClass:Class;

        private var fieldsList:Vector.<FPTextField>;
        public function NativeFormTest()
        {
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            this.stage.align = StageAlign.TOP_LEFT;
            //
            createFlashUI();
            createNativeUI();
        }

        private function createFlashUI():void
        {
            var w:int = Capabilities.screenResolutionX;
            var h:int = Capabilities.screenResolutionY;
            //
            var back:Shape = new Shape();
            back.graphics.beginFill(0xeeeeee, 1);
            back.graphics.drawRect(0, 0, w, h);
            back.graphics.endFill();
            this.addChild(back);
            //
            var logo:Bitmap = new LogoClass();
            logo.alpha = 0.5;
            logo.x = w-logo.width;
            logo.y = h-logo.height;
            this.addChild(logo);
            //
            var titleField:TextField = new TextField();
            titleField.defaultTextFormat = new TextFormat('Tahoma', 50, 0x0);
            titleField.autoSize = TextFieldAutoSize.LEFT;
            titleField.text = 'FlashPress.ru';
            titleField.x = 40;
            titleField.y = 100;
            this.addChild(titleField);
        }

        private function createNativeUI():void
        {
            FPNativeUI.init();
            trace('FPNativeUI:', FPNativeUI.VERSION+'.'+FPNativeUI.BUILD);
            //
            var ypos:Number = Capabilities.screenResolutionY-750;
            //
            fieldsList = new Vector.<FPTextField>();
            createField('code', ypos, FPTextKeyboardTypes.NUMBERS_AND_PUNCTUATION);
            createField('name', ypos+150, FPTextKeyboardTypes.DEFAULT);
            createField('age', ypos+300, FPTextKeyboardTypes.NAME_PHONE_PAD);
            createField('email', ypos+450, FPTextKeyboardTypes.EMAIL_ADDRESS);
            createField('phone', ypos+600, FPTextKeyboardTypes.NAME_PHONE_PAD);
            //
            FPKeyboard.instance.addEventListener(FPKeyboardEvent.KEYBOARD_WILL_SHOW, keyboardShowHandler);
            FPKeyboard.instance.addEventListener(FPKeyboardEvent.KEYBOARD_CHANGE_ACTIVE, keyboardChangeActiveHandler);
            FPKeyboard.instance.addEventListener(FPKeyboardEvent.KEYBOARD_WILL_HIDE, keyboardHideHandler);
        }

        private function createField(label:String, ypos:Number, type:int):FPTextField
        {
            var labelView:TextField = new TextField();
            labelView.autoSize = TextFieldAutoSize.LEFT;
            labelView.defaultTextFormat = new TextFormat('Tahoma', 26);
            labelView.text = label;
            labelView.x = 40;
            labelView.y = ypos+30;
            this.addChild(labelView);
            //
            var nativeFrame:Rectangle = new Rectangle(200, ypos, 400, 100);
            FPWindowView.window.screen.boundsFlashToNative(nativeFrame);
            //
            var nativeField:FPTextField = new FPTextField();
            nativeField.frame = nativeFrame;
            nativeField.clearButtonMode = FPTextFieldViewMode.ALWAYS;
            nativeField.hideAfterReturn = true;
            nativeField.backgroundColor = 0xffffff;
            nativeField.backgroundAlpha = 0.8;
            nativeField.borderStyle = FPTextBorderStyle.ROUNDED_RECT;
            nativeField.placeholder = 'enter '+label;
            nativeField.keyboardType = type;
            FPStageView.stage.addChild(nativeField);
            //
            nativeField.addEventListener(FPTextFieldEvent.KEYBOARD_RETURN, returnHandler);
            fieldsList.push(nativeField);
            //
            return nativeField;
        }

        private function returnHandler(event:FPTextFieldEvent):void
        {
            var index:int = fieldsList.indexOf(event.currentTarget as FPTextField);
            index++;
            if (index >= fieldsList.length) index = 0;
            fieldsList[index].beginEditing();
        }

        private var keyboardInfo:FPKeyboardInfo;
        private function keyboardShowHandler(event:FPKeyboardEvent):void
        {
            keyboardInfo = event.keyboardInfo;
            trace('keyboardShowHandler', keyboardInfo.duration);
            setStagePosition();
        }
        private function keyboardChangeActiveHandler(event:FPKeyboardEvent):void
        {
            if (keyboardInfo) {
                trace('keyboardChangeActiveHandler', keyboardInfo.duration);
                setStagePosition();
            }
        }
        private function keyboardHideHandler(event:FPKeyboardEvent):void
        {
            startAnimation(0, keyboardInfo.duration);
            keyboardInfo = null;
        }

        private function setStagePosition():void
        {
            var activeField:FPTextField = FPKeyboard.instance.activeView as FPTextField;
            var activeFrame:Rectangle = activeField.frame;
            //
            var animateTo:Number;
            if (activeFrame.y+activeFrame.height > keyboardInfo.boundsEnd.y) {
                animateTo = -(activeFrame.y+activeFrame.height-keyboardInfo.boundsEnd.y)-10;
            } else {
                animateTo = 0;
            }
            startAnimation(animateTo, keyboardInfo.duration);
        }

        private var tween:FPTween;
        private function startAnimation(animateTo:Number, duration:Number):void
        {
            if (!tween) {
                tween = new FPTween({ease:FPTEaseTypes.QUAD_OUT});
                tween.addEventListener(FPTEvent.CHANGE, tweenChangeHandler);
            }
            tween.ease = animateTo != 0 ? FPTEaseQuad.easeOut : FPTEaseStrong.easeOut;
            tween.begin = FPStageView.stage.y;
            tween.finish = animateTo;
            tween.duration = duration;
            tween.start();
        }

        private function tweenChangeHandler(event:FPTEvent):void
        {
            FPStageView.stage.y = event.state.value;
        }

    }
}
