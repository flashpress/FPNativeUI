/**
 * Created by sam on 16.05.15.
 */
package {
    import ru.flashpress.nui.view.FPView;
    import ru.flashpress.tween.FPTween;

    public class Animation
    {
        private var target:FPView;
        private var property:String;
        private var tween:FPTween;
        public function Animation(target:FPView, property:String)
        {
            this.target = target;
            this.property = property;
            //
            this._animateProperty = target[property];
            this.tween = new FPTween({duration:0.8, target:this, property:'animateProperty'});
        }

        private var _animateProperty:Number = 0;
        public function get animateProperty():Number
        {
            return this._animateProperty;
        }
        public function set animateProperty(value:Number):void
        {
            this._animateProperty = value;
            target[property] = value;
        }

        public function start(finishValue:Number, ease:Function):void
        {
            tween.finish = finishValue;
            tween.ease = ease;
            tween.start();
        }
    }
}
