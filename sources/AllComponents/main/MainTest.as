/**
 * Created by sam on 29.04.15.
 */
package
{
    import control.TableTest;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;

    import ru.flashpress.nui.FPNativeUI;

    public class MainTest extends Sprite
    {
        public function MainTest()
        {
            super();
            //
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            this.stage.align = StageAlign.TOP_LEFT;
            //
            FPNativeUI.init();
            trace('FPNativeUI:', FPNativeUI.VERSION+'.'+FPNativeUI.BUILD);
            //
            var table:TableTest = new TableTest(this.stage);
            table.show();
        }
    }
}
