/**
 * Created by sam on 29.04.15.
 */
package {
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import ru.flashpress.nui.events.FPControlEvent;
    import ru.flashpress.nui.view.FPXibView;
    import ru.flashpress.nui.view.control.FPButton;

    public class TestBase extends EventDispatcher
    {
        protected var name:String;
        protected var xibView:FPXibView;
        protected var closeButton:FPButton;
        public function TestBase(name:String)
        {
            this.name = name;
        }

        protected function create():void
        {
            xibView = new FPXibView(name);
            //
            closeButton = xibView.childById(name+'_closeButton') as FPButton;
            if (closeButton) {
                closeButton.addEventListener(FPControlEvent.TOUCH_DOWN, closeDownHandler);
            }
        }

        private function closeDownHandler(event:FPControlEvent):void
        {
            this.hide();
            this.dispatchEvent(new Event(Event.CLOSE));
        }

        public function show():void
        {
            xibView.root.presentChild(xibView);
        }

        public function hide():void
        {
            xibView.removeFromParent();
        }
    }
}
