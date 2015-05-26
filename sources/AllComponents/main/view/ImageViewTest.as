/**
 * Created by sam on 30.04.15.
 */
package view
{
    import ru.flashpress.nui.events.FPControlEvent;
    import ru.flashpress.nui.events.FPTableEvent;
    import ru.flashpress.nui.view.FPImageView;
    import ru.flashpress.nui.view.control.FPButton;
    import ru.flashpress.nui.view.control.FPTable;

    public class ImageViewTest extends TestBase
    {
        public function ImageViewTest()
        {
            super('ImageViewTest');
            //
            create();
        }

        [Embed(source="image.png")]
        private static const ImageClass:Class

        private var idle1:Vector.<String>;
        private var idle2:Vector.<String>;
        private var idle3:Vector.<String>;
        private var attack:Vector.<String>;
        private var wound:Vector.<String>;
        private var block:Vector.<String>;
        private var startWalk:Vector.<String>;
        private var walk:Vector.<String>;
        private var stopWalk:Vector.<String>;
        private var die:Vector.<String>;

        private var imageView:FPImageView;
        private var table:FPTable;
        private var tableSource:Array;
        protected override function create():void
        {
            super.create();
            //
            imageView = xibView.childById('image') as FPImageView;
            imageView.image = (new ImageClass()).bitmapData;
            //
            //
            idle1 = getImages(1, 30);
            idle2 = getImages(31, 82);
            idle3 = getImages(83, 132);
            attack = getImages(133, 177);
            wound = getImages(178, 220);
            block = getImages(221, 260);
            startWalk = getImages(261, 266);
            walk = getImages(267, 288);
            stopWalk = getImages(289, 293);
            die = getImages(294, 343);
            //
            //
            tableSource = [];
            tableSource.push('idle1');
            tableSource.push('idle2');
            tableSource.push('idle3');
            tableSource.push('attack');
            tableSource.push('wound');
            tableSource.push('block');
            tableSource.push('walk');
            tableSource.push('die');
            //
            table = xibView.childById('table') as FPTable;
            table.allowsMultipleSelection = false;
            table.dataSource = [tableSource];
            table.addEventListener(FPTableEvent.SELECTED, selectHandler);
            //
            var button:FPButton = xibView.childById('stopButton') as FPButton;
            button.addEventListener(FPControlEvent.TOUCH_DOWN, stopDownHandler);
        }

        private function getImages(begin:int, end):Vector.<String>
        {
            var i:int;
            var imagesList:Vector.<String> = new <String>[];
            for (i=begin; i<end; i++) {
                imagesList.push('animation/unit_'+i+'.png');
            }
            return imagesList;
        }

        private function selectHandler(event:FPTableEvent):void
        {
            var label:String = tableSource[event.index.row];
            switch (label) {
                case 'idle1':
                    imageView.animationImages = idle1;
                    break;
                case 'idle2':
                    imageView.animationImages = idle2;
                    break;
                case 'idle3':
                    imageView.animationImages = idle3;
                    break;
                case 'attack':
                    imageView.animationImages = attack;
                    break;
                case 'wound':
                    imageView.animationImages = wound;
                    break;
                case 'block':
                    imageView.animationImages = block;
                    break;
                case 'walk':
                    imageView.animationImages = walk;
                    break;
                case 'die':
                    imageView.animationImages = die;
                    break;
            }
            imageView.startAnimating();
        }

        private function stopDownHandler(event:FPControlEvent):void
        {
            imageView.stopAnimating();
            table.deselect(table.selectedIndex);
        }



    }
}
