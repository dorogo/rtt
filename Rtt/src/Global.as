/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 03.02.15
 * Time: 3:32
 * To change this template use File | Settings | File Templates.
 */
package {
public final class Global {
    //public const
    public static const TEXTURE_NORMAL:int = 0;
    public static const TEXTURE_FASTER:int = 1;
    public static const TEXTURE_SLOWLY:int = 2;
    public static const BLOCK_NORMAL:int = 0;
    public static const BLOCK_BORDER:int = 1;
    public static const BLOCK_FASTER:int = 2;
    public static const BLOCK_SLOWLY:int = 3;
//        public static var _arrLvl:Array = new Array([[],[],[],[],[],[],[],[],[],[],[],[]],[[],[],[],[],[],[],[],[],[],[],[],[]],[[],[],[],[],[],[],[],[],[],[],[],[]],[[],[],[],[],[],[],[],[],[],[],[],[]]);
//        public static var _arrLvl:Vector.<int> = new Vector.<int>();
    public static var _arrLvl:Array = [];
    public static var _vecLvl:Vector.<Vector.<Vector.<int>>> = new Vector.<Vector.<Vector.<int>>>();
    public static var _spdLvl:int;

    public function Global() {
    }

    static public function initXml() {
    }
}
}
