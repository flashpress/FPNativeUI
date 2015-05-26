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
    import flash.text.SoftKeyboardType;
    import flash.text.StageText;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class FlashFormTest extends Sprite
    {
        [Embed(source="logo.png")]
        private static var LogoClass:Class;

        private var fieldsList:Vector.<StageText>;
        public function FlashFormTest()
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
            var ypos:Number = Capabilities.screenResolutionY-750;
            //
            fieldsList = new Vector.<StageText>();
            createField('code', ypos, SoftKeyboardType.DEFAULT);
            createField('name', ypos+150, SoftKeyboardType.DEFAULT);
            createField('age', ypos+300, SoftKeyboardType.NUMBER);
            createField('email', ypos+450, SoftKeyboardType.EMAIL);
            createField('phone', ypos+600, SoftKeyboardType.CONTACT);
        }

        private function createField(label:String, ypos:Number, type:String):StageText
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
            var back:Shape = new Shape();
            back.graphics.lineStyle(1, 0x0, 1);
            back.graphics.drawRoundRect(0, 0, nativeFrame.width+20, nativeFrame.height+20, 50, 50);
            back.x = nativeFrame.x-10;
            back.y = nativeFrame.y-10;
            this.addChild(back);
            //
            var nativeField:StageText = new StageText();
            nativeField.fontSize = 30;
            nativeField.softKeyboardType = type;
            nativeField.viewPort = nativeFrame;
            nativeField.stage = stage;
            //
            fieldsList.push(nativeField);
            //
            return nativeField;
        }
    }
}
