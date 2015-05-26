/**
 * Created by sam on 28.04.15.
 */
package view
{
    import ru.flashpress.nui.constants.FPControlState;
    import ru.flashpress.nui.events.FPControlEvent;
    import ru.flashpress.nui.events.FPWebViewEvent;
    import ru.flashpress.nui.view.FPActivityIndicatorView;
    import ru.flashpress.nui.view.FPWebView;
    import ru.flashpress.nui.view.control.FPButton;
    import ru.flashpress.nui.view.text.FPTextField;

    public class WebViewTest extends TestBase
    {
        public function WebViewTest()
        {
            super('WebViewTest');
            //
            create();
        }

        private var addressField:FPTextField;
        private var activity:FPActivityIndicatorView;
        private var actionButton:FPButton;
        private var webView:FPWebView;
        private var backButton:FPButton;
        private var forwardButton:FPButton;
        protected override function create():void
        {
            super.create();
            //
            addressField = xibView.childById('addressField') as FPTextField;
            //
            activity = xibView.childById('activity') as FPActivityIndicatorView;
            //
            actionButton = xibView.childById('actionButton') as FPButton;
            actionButton.setTitle('load', FPControlState.NORMAL);
            actionButton.addEventListener(FPControlEvent.TOUCH_DOWN, actionHandler);
            //
            webView = xibView.childById('webView') as FPWebView;
            webView.addEventListener(FPWebViewEvent.START_LOAD, startLoadHandler);
            webView.addEventListener(FPWebViewEvent.FINISH_LOAD, finishLoadHandler);
            webView.addEventListener(FPWebViewEvent.FAIL_LOAD, failLoadHandler);
            //
            backButton = xibView.childById('backButton') as FPButton;
            backButton.addEventListener(FPControlEvent.TOUCH_DOWN, backHandler);
            //
            forwardButton = xibView.childById('forwardButton') as FPButton;
            forwardButton.addEventListener(FPControlEvent.TOUCH_DOWN, forwardHandler);
        }

        private function actionHandler(event:FPControlEvent):void
        {
            if (!webView.isLoading) {
                if (addressField.text == '') return;
                //
                addressField.endEditing(true);
                var res:Boolean = webView.loadRequest(addressField.text);
                addressField.textColor = res ? 0x0 : 0xff0000;
                setGoEnableds();
            } else {
                webView.stopLoading();
                setGoEnableds();
            }
        }

        private function startLoadHandler(event:FPWebViewEvent):void
        {
            addressField.textColor = 0x0;
            activity.startAnimating();
            actionButton.setTitle('stop', FPControlState.NORMAL);
        }
        private function finishLoadHandler(event:FPWebViewEvent):void
        {
            activity.stopAnimating();
            actionButton.setTitle('load', FPControlState.NORMAL);
            setGoEnableds();
        }
        private function failLoadHandler(event:FPWebViewEvent):void
        {
            addressField.textColor = 0xff0000;
            activity.stopAnimating();
            actionButton.setTitle('load', FPControlState.NORMAL);
        }

        private function backHandler(event:FPControlEvent):void
        {
            webView.goBack();
            setGoEnableds();
        }
        private function forwardHandler(event:FPControlEvent):void
        {
            webView.goForward();
            setGoEnableds();
        }

        private function setGoEnableds():void
        {
            backButton.enabled =  webView.canGoBack();
            forwardButton.enabled =  webView.canGoForward();
        }

    }
}
