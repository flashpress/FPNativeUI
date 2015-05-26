/**
 * Created by sam on 28.04.15.
 */
package control
{
    import flash.display.Stage;
    import flash.events.Event;

    import ru.flashpress.nui.constants.FPTableCellStyle;
    import ru.flashpress.nui.events.FPTableEvent;
    import ru.flashpress.nui.view.control.FPTable;

    import view.BackgroundEnabledTest;
    import view.ImageViewTest;
    import view.SearchBarTest;
    import view.WebViewTest;

    public class TableTest extends TestBase
    {
        private var stage:Stage;
        public function TableTest(stage:Stage)
        {
            super('TableTest');
            this.stage = stage;
            //
            create();
        }

        private var tableView:FPTable;
        private var dataSource:Array;
        protected override function create():void
        {
            super.create();
            //
            tableView = xibView.childById('tableView') as FPTable;
            tableView.cellStyle = FPTableCellStyle.DEFAULT;
            //
            dataSource = [];
            dataSource[0] = ['PageControlTest', 'DatePickerTest', 'PickerTest'];
            dataSource[1] = ['BackgroundEnabledTest', 'WebViewTest', 'SearchBarTest', 'ImageViewTest'];
            tableView.dataSource = dataSource;
            tableView.titleForHeaders = new <String>['Controls', 'Views'];
            tableView.allowsMultipleSelection = false;
            tableView.reload();
            //
            tableView.addEventListener(FPTableEvent.DESELECTED, tableDeselectHandler);
            tableView.addEventListener(FPTableEvent.SELECTED, tableSelectHandler);
        }

        private function tableDeselectHandler(event:FPTableEvent):void
        {
        }

        private var currentTest:TestBase;
        private var cash:Object = {};
        private function tableSelectHandler(event:FPTableEvent):void
        {
            xibView.removeFromParent(true);
            //
            if (currentTest) {
                currentTest.hide();
                currentTest = null;
            }
            //
            var label:String = dataSource[event.index.section][event.index.row];
            //
            if (cash[label]) {
                currentTest = cash[label];
            } else {
                switch (label) {
                    case 'PageControlTest':
                        currentTest = new PageControlTest();
                        break;
                    case 'DatePickerTest':
                        currentTest = new DatePickerTest();
                        break;
                    case 'PickerTest':
                        currentTest = new PickerTest();
                        break;
                    case 'BackgroundEnabledTest':
                        currentTest = new BackgroundEnabledTest(stage);
                        break;
                    case 'WebViewTest':
                        currentTest = new WebViewTest();
                        break;
                    case 'SearchBarTest':
                        currentTest = new SearchBarTest();
                        break;
                    case 'ImageViewTest':
                        currentTest = new ImageViewTest();
                        break;
                }
                cash[label] = currentTest;
            }
            //
            if (currentTest) {
                currentTest.addEventListener(Event.CLOSE, closeHandler);
                currentTest.show();
            }
        }

        private function closeHandler(event:Event):void
        {
            tableView.deselectAll(false);
            this.show();
        }
    }
}
