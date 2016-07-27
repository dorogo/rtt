/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 15.03.15
 * Time: 20:46
 * To change this template use File | Settings | File Templates.
 */
package Hero.Weapon {
public interface IWeapon {
    function activate():void;

    function update():void;

    function getArrBullets():Array;
}
}
