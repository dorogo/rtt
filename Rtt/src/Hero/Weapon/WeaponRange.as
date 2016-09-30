/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 18.03.15
 * Time: 0:34
 * To change this template use File | Settings | File Templates.
 */
package Hero.Weapon {
import flash.display.MovieClip;

public class WeaponRange extends MovieClip implements IWeapon {
    private var _root:MovieClip;
    private var _arrBullets:Array;
    private var _arrPoolFreeBullets:Array;
    private var bullet:Bullet;
    private const TYPE:int = 2;

    public function WeaponRange(_rt:MovieClip) {
        _arrBullets = [];
        _arrPoolFreeBullets = [];
        _root = _rt;
    }

    public function activate():void {
    }

    public function update():void {
        var len:int = _arrBullets.length - 1;
        if (len >= 0)
            for (var i:int = len; i >= 0; i--) {
                if (_arrBullets[i].getCurrLife() <= 0 || _arrBullets[i].x > 650) {
                    _root.getBulletnsContainerMc().removeChild(_arrBullets[i]);
                    _arrPoolFreeBullets.push(_arrBullets[i]);
                    _arrBullets[i] = null;
                    _arrBullets.splice(i, 1);
                }
            }
    }

    public function createBullet(_x:Number, _y:Number, _w:int, _h:int,_g:Number = 0, decrementG:Number = 0 , cLife:int = 1):void {
        if ((bullet = _arrPoolFreeBullets.pop()) == null) {
            bullet = new Bullet();
        }
        bullet.setParametrs(_x, _y, _w, _h, _g, decrementG,cLife);
        _root.getBulletnsContainerMc().addChild(bullet);
        _arrBullets.push(bullet);
    }

    public function getArrBullets():Array {
        return _arrBullets;
    }

    public function getType():int {
        return TYPE;
    }
}
}
