/**
 * Created by sam on 17.05.15.
 */
package
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.system.Capabilities;

    import ru.flashpress.nui.view.video.events.FPVideoPlayerEvent;
    import ru.flashpress.nui.view.video.data.FPVideoPlayerThumbnail;

    public class VideoApp extends Sprite
    {
        private var thumbnailsCont:Sprite;
        private var player:NativeVideoPlayer;
        public function VideoApp()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            //
            thumbnailsCont =new Sprite();
            this.addChild(thumbnailsCont);
            xpos = 20;
            ypos = 20;
            //
            player = new NativeVideoPlayer();
            player.addEventListener(FPVideoPlayerEvent.THUMBNAIL_REQUEST_DID_FINISH, thumbnailFinishHandler);
        }

        private var xpos:Number;
        private var ypos:Number;
        private function thumbnailFinishHandler(event:FPVideoPlayerEvent):void
        {
            var thumbnail:FPVideoPlayerThumbnail = event.thumbnail;
            var bitmapData:BitmapData = thumbnail.image.toBitmapData();
            var bitmap:Bitmap = new Bitmap(bitmapData);
            bitmap.scaleX = bitmap.scaleY = 320/bitmap.height;
            bitmap.smoothing = true;
            //
            if (xpos+bitmap.width > Capabilities.screenResolutionX-40) {
                xpos = 20;
                ypos += 340;
            }
            bitmap.x = xpos;
            bitmap.y = ypos;
            xpos += bitmap.width+20;
            thumbnailsCont.addChild(bitmap);
        }
    }
}
