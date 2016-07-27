/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 05.07.16
 * Time: 23:56
 * To change this template use File | Settings | File Templates.
 */
package Hero.Weapon {
import flash.display.MovieClip;

public class Bow extends WeaponRange {
    public function Bow(_rt:MovieClip) {
        super(_rt);
    }
    override public function activate():void {
        super.createBullet(this.parent.x, this.parent.y, 20, 20, 3,.2);
    }

    override public function update():void {
        super.update();
        if (super.getArrBullets().length > 0) {
            for each (var q:Bullet in super.getArrBullets()) {
                q.x += 8;
                q.y -= q.getGravity();
            }
        }
    }
}
}
