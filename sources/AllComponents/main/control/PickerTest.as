/**
 * Created by sam on 28.04.15.
 */
package control
{
    import ru.flashpress.nui.events.FPPickerEvent;
    import ru.flashpress.nui.events.FPStepperEvent;

    import ru.flashpress.nui.view.FPLabel;
    import ru.flashpress.nui.view.control.FPPicker;
    import ru.flashpress.nui.view.control.FPStepper;

    public class PickerTest extends TestBase
    {
        public function PickerTest()
        {
            super('PickerTest');
            //
            create();
        }

        private var pickerActive:FPPicker;
        private var stepRows:FPStepper;
        private var stepComponents:FPStepper;
        private var label:FPLabel;
        private var pickerClone:FPPicker;
        protected override function create():void
        {
            super.create();
            //
            pickerActive = xibView.childById('pickerActive') as FPPicker;
            pickerActive.addEventListener(FPPickerEvent.SELECTED, pickerSelectedHandler);
            //
            stepRows = xibView.childById('stepRow') as FPStepper;
            stepRows.value = 3;
            stepRows.minimumValue = 1;
            stepRows.maximumValue = 50;
            stepRows.stepValue = 1;
            stepRows.addEventListener(FPStepperEvent.VALUE_CHANGED, stepperChangeHandler);
            //
            stepComponents = xibView.childById('stepComponent') as FPStepper;
            stepComponents.value = 1;
            stepComponents.minimumValue = 1;
            stepComponents.maximumValue = 5;
            stepComponents.stepValue = 1;
            stepComponents.addEventListener(FPStepperEvent.VALUE_CHANGED, stepperChangeHandler);
            //
            label = xibView.childById('labelSelected') as FPLabel;
            //
            pickerClone = xibView.childById('pickerClone') as FPPicker;
            pickerClone.userInteractionEnabled = false;
            //
            init();
        }

        private function stepperChangeHandler(event:FPStepperEvent):void
        {
            init();
        }

        private function init():void
        {
            var rows:int = stepRows.value;
            var components:int = stepComponents.value;
            //
            //
            var dataSources:Array = [];
            for (var i:int=0; i<components; i++) {
                dataSources[i] = [];
                for (var j:int=0; j<rows; j++) {
                    dataSources[i][j] = j+'x'+i;
                }
            }
            pickerActive.init(rows, components);
            pickerActive.dataSource = dataSources;
            pickerActive.reload();
            //
            pickerClone.init(rows, components);
            pickerClone.dataSource = dataSources;
            pickerClone.reload();
        }

        private function pickerSelectedHandler(event:FPPickerEvent):void
        {
            var value:String = pickerActive.dataSource[event.component][event.row];
            label.text = 'row:'+event.row+', component:'+event.component+', value:'+value;
            //
            pickerClone.select(event.row, event.component, true);
        }
    }
}
