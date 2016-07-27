/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 07.08.14
 * Time: 14:36
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.MovieClip;
import flash.utils.getDefinitionByName;

public class Block extends MovieClip {
    public static const BLOCK:int = 0;
    public static const BORDER:int = 1;
    public static const ICE:int = 2;
    public static const DIRT:int = 3;
    public var t:int;
    private var life:int;
    private var debugBlock:Block1;
    private var classRef:Class;
    private var texture:MovieClip;
    private var b0:BorderTexture0Mc;
    private var b1:BorderTexture1Mc;
    private var b2:BorderTexture2Mc;

    public function Block() {
    }

    public function setBlock(startX:Number, startY:Number, w:int, h:int, t:int = 0, dop_t:int = 0):void {
        this.t = t;
        this.x = startX;
        this.y = startY;
        this.graphics.clear();
        if (texture != null) {
            this.removeChild(texture);
            texture = null;
        }
        if (t != Global.BLOCK_BORDER) {
            this.graphics.beginFill(getColor(t));
            this.graphics.drawRoundRect(0, 0, w, h, 5);
            this.graphics.endFill();
        } else {
            classRef = getDefinitionByName("BorderTexture" + dop_t.toString() + "Mc") as Class;
            texture = new classRef();
            texture.gotoAndStop(1);
            this.addChild(texture);
        }
        life = 1;
    }

    public function reduceLife(i:int = 1):void {
//        if (this.life >1 ){
//            this.texture.play();
        this.life -= i;
//        }
    }

    public function getCurrLife():int {
        return this.life;
    }

    private function getColor(t:int):uint {
        if (t == 0) {
            return 0x758731;
        } else if (t == 1) {
            return 0xffffff;
        } else if (t == 2) {
            return 0x15FFFF;
        } else if (t == 3) {
            return 0x666666;
        }
        return 0x000000;
    }

    public function playDestroy():void {
        this.texture.play();
    }
}
}
