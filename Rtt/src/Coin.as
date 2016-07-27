/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 02.03.15
 * Time: 21:37
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.MovieClip;

public class Coin extends MovieClip {
    private var type:int = 1;
    private var coinMc:CoinMc;

    public function Coin() {
    }

    public function setCoin(_x:int, _y:int, _type:int):void {
        this.x = _x;
        this.y = _y;
        this.type = _type;
        if (coinMc == null) {
            coinMc = new CoinMc();
            this.addChild(coinMc);
        }
        coinMc.gotoAndStop(type);
    }

    public function getMoney():int {
        if (type == 1) {
            return 1;
        } else {
            return 5;
        }
        return 0;
    }
}
}
