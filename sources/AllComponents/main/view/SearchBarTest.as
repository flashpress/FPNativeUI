/**
 * Created by sam on 29.04.15.
 */
package view
{
    import ru.flashpress.nui.events.FPSearchBarEvent;
    import ru.flashpress.nui.events.FPViewEvent;
    import ru.flashpress.nui.events.FPWebViewEvent;
    import ru.flashpress.nui.view.FPActivityIndicatorView;
    import ru.flashpress.nui.view.FPSearchBar;
    import ru.flashpress.nui.view.FPWebView;

    public class SearchBarTest extends TestBase
    {
        public function SearchBarTest()
        {
            super('SearchBarTest');
            //
            create();
        }

        private var search:FPSearchBar;
        private var web:FPWebView;
        private var activity:FPActivityIndicatorView;
        protected override function create():void
        {
            super.create();
            //
            this.xibView.addEventListener(FPViewEvent.PRESENT_COMPLETE, presentCompleteHandler);
            //
            search = xibView.childById('searchBar') as FPSearchBar;
            search.placeholder = 'question';
            search.addEventListener(FPSearchBarEvent.SEARCH, searchHandler);
            search.addEventListener(FPSearchBarEvent.SEARCH_SELECTED_SCOPE, searchScopeHandler);
            search.addEventListener(FPSearchBarEvent.SEARCH_RESULTS, searchResutsHandler);
            search.addEventListener(FPSearchBarEvent.SEARCH_CANCEL, searchCancelHandler);
            //
            web = xibView.childById('searchWebView') as FPWebView;
            web.addEventListener(FPWebViewEvent.FINISH_LOAD, webFinishHandler);
            web.visible = false;
            //
            activity = xibView.childById('searchActivity') as FPActivityIndicatorView;
        }

        private function presentCompleteHandler(event:FPViewEvent):void
        {
            search.beginEditing();
        }

        private function searchResutsHandler(event:FPSearchBarEvent):void
        {
            search.visibleScopeBar = !search.visibleScopeBar;
        }
        private function searchCancelHandler(event:FPSearchBarEvent):void
        {
            activity.stopAnimating();
            web.visible = false;
            web.stopLoading();
            search.endEditing();
            search.text = '';
            currentText = null;
        }
        private function searchHandler(event:FPSearchBarEvent):void
        {
            search.endEditing();
            find(event.text, search.selectedScope);
        }
        private function searchScopeHandler(event:FPSearchBarEvent):void
        {
            if (currentText) {
                 find(currentText, event.scope);
                search.text = currentText;
            }
        }

        private var currentText:String;
        private function find(text:String, finder:int):void
        {
            activity.startAnimating();
            web.visible = false;
            //
            currentText = text;
            switch (finder) {
                case 0:
                    web.loadRequest('http://bing.com?q='+text);
                    break;
                case 1:
                    web.loadRequest('http://yandex.ru?q='+text);
                    break;
            }
        }

        private function webFinishHandler(event:FPWebViewEvent):void
        {
            web.visible = true;
            activity.stopAnimating();
        }

        public override function hide():void
        {
            super.hide();
            //
            search.endEditing(true);
        }
    }
}
