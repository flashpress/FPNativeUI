/**
 * Created by sam on 28.04.15.
 */
package control
{
    import ru.flashpress.nui.constants.FPDatePickerMode;
    import ru.flashpress.nui.events.FPDatePickerEvent;
    import ru.flashpress.nui.events.FPSegmentEvent;
    import ru.flashpress.nui.view.FPLabel;
    import ru.flashpress.nui.view.control.FPDatePicker;
    import ru.flashpress.nui.view.control.FPSegment;

    public class DatePickerTest extends TestBase
    {
        public function DatePickerTest()
        {
            super('DatePickerTest');
            //
            create();
        }

        private var segmentMode:FPSegment;
        private var datePicker:FPDatePicker;
        private var label:FPLabel;
        protected override function create():void
        {
            super.create();
            //
            segmentMode = xibView.childById('segmentMode') as FPSegment;
            segmentMode.addEventListener(FPSegmentEvent.SELECTED_CHANGE, segmentSelectedHandler);
            segmentMode.selectedIndex = 2;
            //
            datePicker = xibView.childById('datePicker') as FPDatePicker;
            datePicker.addEventListener(FPDatePickerEvent.VALUE_CHANGED, dateChangeHandler);
            //
            label = xibView.childById('dp_label') as FPLabel;
            label.text = 'select date';
        }

        private function segmentSelectedHandler(event:FPSegmentEvent):void
        {
            switch (event.selectedIndex) {
                case 0:
                    datePicker.mode = FPDatePickerMode.TIME;
                    break;
                case 1:
                    datePicker.mode = FPDatePickerMode.DATE;
                    break;
                case 2:
                    datePicker.mode = FPDatePickerMode.DATE_AND_TIME;
                    break;
                case 3:
                    datePicker.mode = FPDatePickerMode.COUNT_DOWN_TIMER;
                    break;
            }
        }

        private function dateChangeHandler(event:FPDatePickerEvent):void
        {
            var date:Date = new Date(event.date*1000);
            label.text = date.toString();
        }
    }
}
