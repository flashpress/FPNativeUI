/**
 * Created by sam on 28.04.15.
 */
package control
{
    import ru.flashpress.nui.events.FPPageControlEvent;
    import ru.flashpress.nui.events.FPStepperEvent;

    import ru.flashpress.nui.view.FPLabel;
    import ru.flashpress.nui.view.control.FPPageControl;
    import ru.flashpress.nui.view.control.FPStepper;

    public class PageControlTest extends TestBase
    {
        public function PageControlTest()
        {
            super('PageControlTest');
            //
            create();
        }

        private var stepper:FPStepper;
        private var page:FPPageControl;
        private var label:FPLabel;
        protected override function create():void
        {
            super.create();
            //
            stepper = xibView.childById('stepper') as FPStepper;
            stepper.stepValue = 1;
            stepper.minimumValue = 3;
            stepper.maximumValue = 10;
            stepper.value = 5;
            stepper.addEventListener(FPStepperEvent.VALUE_CHANGED, stepperChangeHandler);
            //
            page = xibView.childById('page') as FPPageControl;
            page.addEventListener(FPPageControlEvent.VALUE_CHANGED, pageChangeHandler);
            page.pagesCount = stepper.value;
            //
            label = xibView.childById('label') as FPLabel;
        }

        private function stepperChangeHandler(event:FPStepperEvent):void
        {
            trace(xibView.backgroundEnabled, xibView.backgroundAlpha, xibView.backgroundColor);
            xibView.backgroundColor = 0xffffffff;
            //
            page.pagesCount = stepper.value;
        }
        private function pageChangeHandler(event:FPPageControlEvent):void
        {
            label.text = 'page: '+page.currentPage;
        }
    }
}
