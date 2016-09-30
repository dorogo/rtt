/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 10.04.15
 * Time: 2:40
 * To change this template use File | Settings | File Templates.
 */
package Hero.Weapon {
import flash.display.MovieClip;

public class WeaponMelee extends MovieClip implements IWeapon {
    private var meleeArea:MeleeWeapMc;
    private var _root:MovieClip;
    private var tick:int;
    private var isActivated:Boolean = false;
    private const TYPE:int = 1;

    public function WeaponMelee(_rt:MovieClip) {
        _root = _rt;
    }

    public function activate():void {
//        meleeArea.visible = false;
        tick = 0;
        isActivated = true;
        trace("adasd");
    }

//    почекать динамик енеми. неправильно восстанавливаются координатф
//переименовать weapon в weaponrange
    public function update():void {
        if(isActivated && tick++ >= 1) {
//            meleeArea.visible = true;
//            tick = 3;
            isActivated = false;
        }
        if (meleeArea.visible && tick-- <= 0) {
//            meleeArea.visible = false;
        }
    }

    public function addMeleeWeap(_w:int, _h:int):void {
        meleeArea = new MeleeWeapMc();
        meleeArea.width = _w;
        meleeArea.height = _h;
        meleeArea.visible = false;
        _root.addChild(meleeArea);
    }

    public function getMeleeWeap():MeleeWeapMc {
        return meleeArea;
    }

    public function getArrBullets():Array {
        return [];
    }

    public function getType() : int {
        return TYPE;
    }
}
}
