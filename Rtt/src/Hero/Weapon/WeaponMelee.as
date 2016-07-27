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

    public function WeaponMelee(_rt:MovieClip) {
        _root = _rt;
    }

    public function activate():void {
        meleeArea.visible = true;
        tick = 3;
        trace("adasd");
    }

//    почекать динамик енеми. неправильно восстанавливаются координатф
//переименовать weapon в weaponrange
    public function update():void {
        if (meleeArea.visible && tick-- <= 0)
            meleeArea.visible = false;
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
}
}
