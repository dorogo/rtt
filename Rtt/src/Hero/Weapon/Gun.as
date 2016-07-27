/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 18.03.15
 * Time: 0:58
 * To change this template use File | Settings | File Templates.
 */
package Hero.Weapon {
import flash.display.MovieClip;

public class Gun extends WeaponRange {
    public function Gun(_rt:MovieClip) {
        super(_rt);
    }

    override public function activate():void {
        super.createBullet(this.parent.x, this.parent.y-20, 5, 5);
    }

    override public function update():void {
        super.update();
        if (super.getArrBullets().length > 0) {
            for each (var q:Bullet in super.getArrBullets()) {
                q.x += 9;
            }
        }
    }
}
}