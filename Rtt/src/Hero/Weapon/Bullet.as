/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 18.03.15
 * Time: 1:57
 * To change this template use File | Settings | File Templates.
 */
package Hero.Weapon {
import flash.display.MovieClip;
import flash.utils.getTimer;

public class Bullet extends MovieClip {
    private var bull:BulletMc;
    private var life:int;
    private var bornTime:int;
    private var gravity:Number;
    private var decG:Number;

    public function Bullet() {
        bull = new BulletMc();
        this.addChild(bull);
        bornTime = getTimer();
    }

    public function setParametrs(_x:Number, _y:Number, _w:int, _h:int,_g:Number = 0, decrementG:Number = 0 , cLife:int = 1):void {
        this.life = cLife;
        this.x = _x;
        this.y = _y;
        bull.width = _w;
        bull.height = _h;
        bornTime = getTimer();
        gravity = _g;
        decG = decrementG;
    }

    public function reduceLife(count:int = 1):void {
        this.life -= count;
    }

    public function getCurrLife():int {
        return life;
    }

    public function getLifeTime():Number {
        return ((getTimer() - bornTime)/1000 );
    }

    public function getGravity():Number {
        gravity -= decG;
        return gravity;
    }
}
}


