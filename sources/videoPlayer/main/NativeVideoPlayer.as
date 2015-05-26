/**
 * Created by sam on 15.05.15.
 */
package
{
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    import flash.utils.getTimer;

    import ru.flashpress.nui.FPNativeUI;
    import ru.flashpress.nui.constants.FPSwipeDirection;
    import ru.flashpress.nui.events.FPGestureEvent;
    import ru.flashpress.nui.gesture.FPSwipeGesture;
    import ru.flashpress.nui.gesture.FPTapGesture;
    import ru.flashpress.nui.view.box.FPHBox;
    import ru.flashpress.nui.view.box.FPVBox;
    import ru.flashpress.nui.constants.FPControlState;
    import ru.flashpress.nui.view.control.FPButton;
    import ru.flashpress.nui.view.control.FPSegment;
    import ru.flashpress.nui.view.control.FPSlider;
    import ru.flashpress.nui.view.control.FPSwitch;
    import ru.flashpress.nui.core.FPSize;
    import ru.flashpress.nui.events.FPControlEvent;
    import ru.flashpress.nui.events.FPSegmentEvent;
    import ru.flashpress.nui.events.FPSliderEvent;
    import ru.flashpress.nui.events.FPSwitchEvent;
    import ru.flashpress.nui.view.system.FPScreen;
    import ru.flashpress.nui.view.system.FPStageView;

    import ru.flashpress.nui.view.video.FPVideoPlayer;
    import ru.flashpress.nui.view.video.constants.FPVideoPlayerControlStyle;
    import ru.flashpress.nui.view.video.constants.FPVideoPlayerPlaybackState;
    import ru.flashpress.nui.view.video.constants.FPVideoPlayerScalingMode;
    import ru.flashpress.nui.view.video.constants.FPVideoPlayerTimeOption;
    import ru.flashpress.nui.view.video.events.FPVideoPlayerEvent;
    import ru.flashpress.nui.view.FPLabel;
    import ru.flashpress.nui.view.FPViewPanel;
    import ru.flashpress.tween.ease.FPTEaseElastic;
    import ru.flashpress.tween.ease.FPTEaseStrong;

    public class NativeVideoPlayer extends EventDispatcher
    {
        private var containerBounds:Rectangle;
        private var animation:Animation;
        //
        private var player:FPVideoPlayer;
        private var loadButton:FPButton;
        private var playButton:FPButton;
        private var embedSwith:FPSwitch;
        private var thumbnailTimes:FPSlider;
        public function NativeVideoPlayer()
        {
            var stageW:Number = Capabilities.screenResolutionX;
            var stageH:Number = Capabilities.screenResolutionY;
            //
            FPNativeUI.init();
            //
            containerBounds = new Rectangle(60, 60, stageW-120, stageH-120);
            var labelSize:FPSize = new FPSize(300, 40);
            var paramsWidth:Number = containerBounds.width-50-labelSize.width;
            //
            // root native container
            var container:FPViewPanel = new FPViewPanel();
            container.backgroundEnabled = true;
            container.frame = FPScreen.boundsFlashToNative(containerBounds);
            container.backgroundColor = 0xaaaaaa;
            container.backgroundAlpha = 0.6;
            container.cornerRadius = 15;
            container.borderWidth = 1;
            container.borderColor = 0x99000000;
            //
            animation = new Animation(container, 'y');
            //
            //
            // vertical box
            var vbox:FPVBox = new FPVBox(20);
            vbox.position = FPScreen.pointFlashToNative(new Point(20, 20));
            //
            // video player
            player = new FPVideoPlayer();
            player.autoplay = false;
            player.clearAllBackground();
            player.backgroundColor = 0x0;
            player.controlStyle = FPVideoPlayerControlStyle.EMBEDDED;
            player.size = FPScreen.sizeFlashToNative(new FPSize(containerBounds.width-40, containerBounds.height-600));
            player.addEventListener(FPVideoPlayerEvent.DURATION_AVAILABLE, durationAvailableHandler);
            player.addEventListener(FPVideoPlayerEvent.WILL_EXIT_FULLSCREEN, exitFullScreenHandler);
            player.addEventListener(FPVideoPlayerEvent.PLAYBACK_STATE_DID_CHANGE, playbackStateHandler);
            player.addEventListener(FPVideoPlayerEvent.THUMBNAIL_REQUEST_DID_FINISH, thumbnailFinishHandler);
            //
            // button controls
            var buttonWidth:Number = (containerBounds.width-60)/(2*FPScreen.scale);
            loadButton = createButton('load', buttonWidth);
            //
            playButton = createButton('play', buttonWidth);
            playButton.enabled = false;
            //
            // embed switch
            var labelSwitch:FPLabel = new FPLabel('show controls');
            labelSwitch.size = FPScreen.sizeFlashToNative(labelSize);
            embedSwith = new FPSwitch();
            embedSwith.on = true;
            embedSwith.addEventListener(FPSwitchEvent.VALUE_CHANGED, embedSwithHandler);
            //
            // background alpha slider
            var labelAlphaSlider:FPLabel = new FPLabel('back alpha');
            labelAlphaSlider.size = FPScreen.sizeFlashToNative(labelSize);
            var backAlphaSlider:FPSlider = new FPSlider();
            backAlphaSlider.width =  paramsWidth/FPScreen.scale;
            backAlphaSlider.minimumValue = 0;
            backAlphaSlider.maximumValue = 1;
            backAlphaSlider.value = 1;
            backAlphaSlider.addEventListener(FPSliderEvent.VALUE_CHANGED, backAlphaSliderHandler);
            //
            // scale segment
            var labelScale:FPLabel = new FPLabel('scaling mode');
            labelScale.size = FPScreen.sizeFlashToNative(labelSize);
            var scaleSegment:FPSegment = new FPSegment(['none', 'aspect fit', 'aspect fill', 'fill']);
            scaleSegment.size = FPScreen.sizeFlashToNative(new FPSize(containerBounds.width-40, 60))
            scaleSegment.addEventListener(FPSegmentEvent.SELECTED_CHANGE, scaleSegmentHandler);
            //
            // thumbnai load
            var thumbnailButton:FPButton = createButton('load thumb', 160);
            thumbnailButton.addEventListener(FPControlEvent.TOUCH_DOWN, thumbnailDownHandler);
            //
            thumbnailTimes = new FPSlider();
            thumbnailTimes.y = 10;
            thumbnailTimes.size = FPScreen.sizeFlashToNative(new FPSize(containerBounds.width-400, 30));
            thumbnailTimes.minimumValue = 0;
            thumbnailTimes.value = 0;
            thumbnailTimes.enabled = false;
            //
            // add childs to root container
            FPStageView.stage.addChild(container);
            container.addChild(vbox);
            vbox.addChild(player);
            vbox.addChild(new FPHBox(10, loadButton, playButton));
            vbox.addChild(new FPHBox(10, labelSwitch, embedSwith));
            vbox.addChild(new FPHBox(10, labelAlphaSlider, backAlphaSlider));
            vbox.addChild(new FPVBox(0, labelScale, scaleSegment));
            vbox.addChild(new FPHBox(10, thumbnailTimes, thumbnailButton));
            //
            //
            // set default properties
            player.scalingMode = FPVideoPlayerScalingMode.NONE;
            player.backgroundAlpha = backAlphaSlider.value;
            //
            //
            //
            container.addEventListener(FPGestureEvent.GESTURE_ACTIVATED, gestureActivatedHandler);
            container.addGesture(new FPSwipeGesture(FPSwipeDirection.UP));
            container.addGesture(new FPSwipeGesture(FPSwipeDirection.DOWN));
            //
            player.addEventListener(FPGestureEvent.GESTURE_ACTIVATED, gestureActivatedHandler);
            player.addGesture(new FPSwipeGesture(FPSwipeDirection.UP));
            player.addGesture(new FPSwipeGesture(FPSwipeDirection.DOWN));
            //
            var playerTap:FPTapGesture = new FPTapGesture();
            playerTap.delegate.shouldReceiveTouch = true;
            playerTap.delegate.shouldRecognizeSimultaneouslyWithGestureRecognizer = true;
            player.addGesture(playerTap);
        }

        private var tapTime:Number = 0;
        private function gestureActivatedHandler(event:FPGestureEvent):void {
            if(event.gesture is FPSwipeGesture) {
                var gesture:FPSwipeGesture = event.gesture as FPSwipeGesture;
                var value:Number;
                var ease:Function;
                switch (gesture.direction) {
                    case FPSwipeDirection.UP:
                        value = -containerBounds.height + 200;
                        ease = FPTEaseElastic.easeOut;
                        break;
                    case FPSwipeDirection.DOWN:
                        value = containerBounds.y;
                        ease = FPTEaseStrong.easeOut;
                        break;
                }
                animation.start(value / FPScreen.scale, ease);
            } else if(event.gesture is FPTapGesture) {
                if(getTimer() - tapTime < 300) {
                    player.setFullscreen(true);
                    player.controlStyle = FPVideoPlayerControlStyle.FULLSCREEN;
                }
                tapTime = getTimer();
            }
        }
        private function exitFullScreenHandler(event:FPVideoPlayerEvent):void
        {
            if (embedSwith.on) {
                player.controlStyle = FPVideoPlayerControlStyle.EMBEDDED;
            } else {
                player.controlStyle = FPVideoPlayerControlStyle.NONE;
            }
        }


        private function createButton(text:String, width:Number):FPButton
        {
            var button:FPButton = new FPButton();
            button.setTitle(text, FPControlState.NORMAL);
            button.setTitleColor(0xffffffff, FPControlState.NORMAL);
            button.setTitleColor(0xffff0000, FPControlState.HIGHLIGHTED);
            button.setTitleColor(0x88ffffff, FPControlState.DISABLED);
            button.width = width;
            button.height = 30;
            button.backgroundColor = 0xff179fe5;
            button.addEventListener(FPControlEvent.TOUCH_DOWN, buttonDownHandler);
            return button;
        }

        private function buttonDownHandler(event:FPControlEvent):void
        {
            if (event.currentTarget == loadButton) {
                if (!player.url) {
                    player.url = 'http://flashpress.ru/video3.mov';
                }
                if (!player.isPreparedToPlay) {
                    loadButton.setTitle('stop', FPControlState.NORMAL);
                    player.load();
                    //
                    playButton.enabled = true;
                } else {
                    loadButton.setTitle('load', FPControlState.NORMAL);
                    player.stop();
                    //
                    playButton.enabled = false;
                }
            } else if (event.currentTarget == playButton) {
                switch (player.playbackState) {
                    case FPVideoPlayerPlaybackState.PLAYING:
                        player.pause();
                        break;
                    case FPVideoPlayerPlaybackState.STOPPED:
                    case FPVideoPlayerPlaybackState.PAUSED:
                        player.play();
                        break;
                }
            }
        }


        private function playbackStateHandler(event:FPVideoPlayerEvent):void
        {
            switch (player.playbackState) {
                case FPVideoPlayerPlaybackState.PAUSED:
                case FPVideoPlayerPlaybackState.STOPPED:
                    playButton.setTitle('play', FPControlState.NORMAL);
                    break;
                case FPVideoPlayerPlaybackState.PLAYING:
                    playButton.setTitle('pause', FPControlState.NORMAL);
                    break;
            }
        }


        private function embedSwithHandler(event:FPSwitchEvent):void
        {
            if (event.on) {
                player.controlStyle = FPVideoPlayerControlStyle.EMBEDDED;
            } else {
                player.controlStyle = FPVideoPlayerControlStyle.NONE;
            }
        }

        private function backAlphaSliderHandler(event:FPSliderEvent):void
        {
            player.backgroundAlpha = event.value;
        }

        private function scaleSegmentHandler(event:FPSegmentEvent):void
        {
            switch (event.selectedIndex) {
                case 0:
                    player.scalingMode = FPVideoPlayerScalingMode.NONE;
                    break;
                case 1:
                    player.scalingMode = FPVideoPlayerScalingMode.ASPECT_FIT;
                    break;
                case 2:
                    player.scalingMode = FPVideoPlayerScalingMode.ASPECT_FILL;
                    break;
                case 3:
                    player.scalingMode = FPVideoPlayerScalingMode.FILL;
                    break;
            }
        }

        private function durationAvailableHandler(event:FPVideoPlayerEvent):void
        {
            thumbnailTimes.maximumValue = player.duration;
            thumbnailTimes.enabled = true;
        }


        private function thumbnailDownHandler(event:FPControlEvent):void
        {
            player.requestThumbnails(new <Number>[thumbnailTimes.value], FPVideoPlayerTimeOption.NEAREST_KEY_FRAME);
        }

        private function thumbnailFinishHandler(event:FPVideoPlayerEvent):void
        {
            this.dispatchEvent(event.clone());
        }

    }
}