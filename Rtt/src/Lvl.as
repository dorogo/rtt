/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 10.03.14
 * Time: 22:39
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.filters.BitmapFilterQuality;
import flash.filters.BlurFilter;
import flash.geom.ColorTransform;
import flash.utils.getTimer;

public class Lvl extends Sprite {
    private const CALWPARTS:int = 2;    //count allowed parts. сколько частей разрешено для создания, "справа за кадром"
    private var vecLvlData:Vector.<Vector.<Vector.<int>>>;      //вектор с блоками из xml
    public var vecParts:Vector.<MovieClip>;                     //вектор частей уровня
    public var vecBl:Vector.<Block>;                            //вектор созданных блоков
    public var vecBlForDel:Vector.<MovieClip>;                      //вектор для элементов, которые должны проиграть анимацию перед исчезновением
    public var vecEn:Vector.<Enemy>;                            //вектор созданных врагов
//    public var vecDynamicEn:Vector.<Enemy>;                     //вектор созданных динмаичных врагов
    public var vecCoins:Vector.<Coin>;                          //вектор созданных монет
    public var vecTexturePartsBlocks:Vector.<Vector.<MovieClip>>;       //вектор частей из блоков для маски
    private var vecTexturePartsBlocksStroke:Vector.<MovieClip>; //вектор частей из блоков для маски
    private var vecTextures:Vector.<Vector.<MovieClip>>;                 //вектор текстур для блоков
    private var vecTexturesStroke:Vector.<Vector.<MovieClip>>;           //вектор текстур для блоков
    private var vecDopTextures:Vector.<Vector.<MovieClip>>;     //вектор доп текстур(трава деревья камни и тд)
    private var vecPreFrontTextures:Vector.<MovieClip>;// вектор для текстур спереди и на занем плане - фон
    private var vecPreBgTextures:Vector.<MovieClip>;
    //вектора для хранения не используемых элементов
    private var vecPoolBlocks:Vector.<Block>;
    private var vecPoolEnemies:Vector.<Enemy>;
    private var vecPoolCoins:Vector.<Coin>;
    private var tmpPartLvl:MovieClip;
    private var vecPoolPreFrontTextures:Vector.<MovieClip>;
    private var vecPoolPreBgTextures:Vector.<MovieClip>;

    private var preFrontTextureMc:PreFrontTextureMc;
    private var preBgTextureMc:PreFrontTextureMc;
    private var blurFilter:BlurFilter;

//    private var testBg:TestBg;
//    private var testBgStroke:TestBg;
    private var _root:MovieClip;
    private var spd:Number = 5;//8;         //пока что max скорость 8, фиксить надо с правым хитбоксом
    ///vars for textures
    private var valueStroke:int = 2;
//    private var loader:URLLoader;
//    private var request:URLRequest = new URLRequest("//Users/user/Documents/_develop/_flash/Rtt/src/xml/config.xml");
    public function Lvl(_r:MovieClip) {
        _root = _r;
        Global._spdLvl = spd;
        //load xml here
//        loader = new URLLoader();
//        loader.load(request);
//        loader.addEventListener(ProgressEvent.PROGRESS, onLoading);
//        loader.addEventListener(Event.COMPLETE, onComplete);
//        setup();
    }

    public function setup():void {
        var l:int;
        // надо чтоюы в 0-е мувика был блок
        // самым крайним должен быть обычный граунд-блок
        // TODO check чтобы подряд одинаковые не шли
//        vecLvlData = new Array([[0,0,0,0],[40,265,0,0],[80,260,0,0],[120, 255,0,0],[130, 230,0, 1],[40,285,0,0],[70,280,0,0],[100, 275,1,0],[130, 270,0, 0],[130, 210,0, 1],[260, 200,0,3], [220, 240,0,0],[220, 280,0,0],[300, 240,0,0],[300,280,0,0],[500,260,0,0],[600,200,0,0],[280,200,1,1],[285,195,1, 0],[520, 260,1, 3]],[[140, 210,0,0],[280, 200,0,0], [240, 240,0,0]]);//,[[0,0,0],[40,265,0],[70,260,0],[100, 255,0],[130, 250,0, 1],[130, 210,0, 1],[260, 200,0], [220, 240,0],[220, 280,0],[300, 240,0],[300,280,0],[500,260,0],[600,200,0],[280,200,1,1],[285,195,1, 2],[520, 260,1, 3]]);
        vecLvlData = Global._vecLvl;
        vecParts = new Vector.<MovieClip>();
        vecPoolBlocks = new Vector.<Block>();
        vecPoolEnemies = new Vector.<Enemy>();
        vecPoolCoins = new Vector.<Coin>();
        tmpPartLvl = new MovieClip();
        tmpPartLvl.x = 0;
        vecBl = new Vector.<Block>();
        vecBlForDel = new Vector.<MovieClip>();
        vecEn = new Vector.<Enemy>();
        vecCoins = new Vector.<Coin>();
//        vecDynamicEn = new Vector.<Enemy>();
        vecTexturePartsBlocks = new Vector.<Vector.<MovieClip>>();
        vecTexturePartsBlocksStroke = new Vector.<MovieClip>();
        vecTextures = new Vector.<Vector.<MovieClip>>();
        vecTexturesStroke = new Vector.<Vector.<MovieClip>>();
        vecDopTextures = new Vector.<Vector.<MovieClip>>();
        vecPreFrontTextures = new Vector.<MovieClip>();
        vecPoolPreFrontTextures = new Vector.<MovieClip>();
        vecPreBgTextures = new Vector.<MovieClip>();
        vecPoolPreBgTextures = new Vector.<MovieClip>();
        //delete
//        var tmp3:Block;
//        var tmp3:Block1;
//        var frontTextureBlock:FrontTextureBlock;
//        var backTextureBlock:BackTextureBlock;
        //нижняя полоска блоков
//        for (var i:int = 0; i <= 25; i++) {
//            tmp3 = new Block(40 / 2 + i * 40, 400 * .8, 40, 20);
////            tmp3 = new Block1();
////            tmp3.y = 400 * .8;
////            tmp3.x = tmp3.width/2 + i * tmp3.width;
//            addChild(tmp3);
//            vecBl.push(tmp3);
//
//            frontTextureBlock = new FrontTextureBlock();
//            frontTextureBlock.gotoAndStop(int(Math.random() * 2) + 1)
////            frontTextureBlock.cacheAsBitmap = true;
//            frontTextureBlock.x = tmp3.x + tmp3.width * .5;
//            frontTextureBlock.y = tmp3.y;
//            this.addChild(frontTextureBlock);
//
//            backTextureBlock = new BackTextureBlock();
//            backTextureBlock.gotoAndStop(int(Math.random() * 2) + 1)
////            backTextureBlock.cacheAsBitmap = true;
//            backTextureBlock.x = tmp3.x + tmp3.width * .5;
//            backTextureBlock.y = tmp3.y;
//            this.addChild(backTextureBlock);
//
//
//            tmp3 = null;
//            backTextureBlock = null;
//
//        }
        //delete
        //стартовые части
        for (var i:int = 0; i < CALWPARTS; i++) {      //TODO: для разных уровней сделать разные начальные части
            createPartLvl(i);
        }
    }

    public function reset():void {
//        var q:MovieClip;
        traceVecs();
        //vecParts
        for (var i:int = vecParts.length-1; i >= 0; i--) {
            trace(vecParts.length, " ", i);
            removePartLvl(i, true);
        }
//        for each (q in vecBl) {
//            q.parent.removeChild(q);
//            vecPoolBlocks.push(q);
//        }
//        vecBl.splice(0, vecBl.length);
//        for each (q in vecBlForDel) {
//            q.parent.removeChild(q);
//            vecPoolBlocks.push(q);
//        }
//        vecBlForDel.splice(0,vecBlForDel.length);
//        for each (q in vecCoins) {
//            q.parent.removeChild(q);
//            vecPoolCoins.push(q);
//        }
//        vecCoins.splice(0,vecCoins.length);
//        for each (q in vecEn) {
//            q.parent.removeChild(q);
//            vecPoolEnemies.push(q);
//        }
//        vecEn.splice(0,vecEn.length);
//        //destroy textures
//        for each (q in preFrontTextureMc) {
//            _root.getPreFrontTextureMc().removeChild(q);
//            preFrontTextureMc.push(q);
//        }
//        vecPreFrontTextures.splice(0,vecPreFrontTextures.length);
//        for (j = 0; j < vecDopTextures[i].length; j++) {
//            for (var k:int = vecDopTextures[i][j].numChildren - 1; k > -1; k--) {
//                vecDopTextures[i][j].removeChildAt(k);
//            }
//        }
//        _root.getFrontTextureMc().removeChild(vecDopTextures[i][0]);
//        _root.getBackTextureMc().removeChild(vecDopTextures[i][1]);
        traceVecs();
    }

    //========TODO temp for testing============
    public function traceVecs() : void {
        trace("======= Vecs in lvl ========")
        trace("vecBl:\t\t"+vecBl.length+" - "+vecPoolBlocks.length);
        trace("vecBlForDel:"+vecBlForDel.length+" - "+vecPoolBlocks.length);
        trace("vecCoins:\t"+vecCoins.length+" - "+vecPoolCoins.length);
        trace("vecEn:\t\t"+vecEn.length+" - "+vecPoolEnemies.length);
        trace("vecPreFront:"+vecPreFrontTextures.length+" - "+vecPoolPreFrontTextures.length);
        trace("============================");
    }
    //==================================

//    private function onComplete(e:Event){
//        trace("y. complete");
//        setup();
//    }
//    private function onLoading(e:ProgressEvent){
//        trace("loading...")
//    }
    private function createPartLvl(i:int = 0):void {
        var tmp:Block;
        var tmp_1:Block;
        var tmp_1_2:Block;
        var tmp2:Enemy;
        var tmp3:Coin;
        var l:int;
        var texturePart:MovieClip = new MovieClip();
        var texturePart2:MovieClip = new MovieClip();
        var texturePart3:MovieClip = new MovieClip();
        var texturePart4:MovieClip = new MovieClip();
        var textureStrokePart:MovieClip = new MovieClip();
//wqqwd   сделать отдельные мувики для разных групп блоков
        tmpPartLvl = new MovieClip();
        for (var j:int = 0; j < vecLvlData[i].length; j++) {
            if (vecLvlData[i][j][4] == 0) {
//                trace(vecPoolBlocks.length);
                if ((tmp = vecPoolBlocks.pop()) == null) {
                    tmp = new Block();
                }
                tmp.setBlock(vecLvlData[i][j][0], vecLvlData[i][j][1], vecLvlData[i][j][5], vecLvlData[i][j][6], vecLvlData[i][j][2], vecLvlData[i][j][3]);
                if (tmp.t != Global.BLOCK_BORDER) {
                    if ((tmp_1 = vecPoolBlocks.pop()) == null) {
                        tmp_1 = new Block();
                    }
                    tmp_1.setBlock(vecLvlData[i][j][0], vecLvlData[i][j][1], vecLvlData[i][j][5], vecLvlData[i][j][6]);
                    if (tmp.t == Global.BLOCK_NORMAL) {
                        texturePart.addChild(tmp_1);
                    } else if (tmp.t == Global.BLOCK_FASTER) {
                        texturePart3.addChild(tmp_1);
                    } else if (tmp.t == Global.BLOCK_SLOWLY) {
                        texturePart4.addChild(tmp_1);
                    }
                }
                if (tmp.t == Global.BLOCK_NORMAL) {
                    if ((tmp_1_2 = vecPoolBlocks.pop()) == null) {
                        tmp_1_2 = new Block();
                    }
                    tmp_1_2.setBlock(vecLvlData[i][j][0] - valueStroke, vecLvlData[i][j][1] - valueStroke, vecLvlData[i][j][5] + valueStroke * 2, vecLvlData[i][j][6] + valueStroke * 2);
                    textureStrokePart.addChild(tmp_1_2);
//                    trace(tmp_1.scale9Grid);
                }
                tmp.visible = true;
                tmp.alpha = .7;
                tmpPartLvl.addChild(tmp);
                vecBl.push(tmp);
                tmp = null;
            } else if (vecLvlData[i][j][4] > 0) {
                if ((tmp2 = vecPoolEnemies.pop()) == null) {
                    tmp2 = new Enemy();
                }
                tmp2.setEnemy(vecLvlData[i][j][0], vecLvlData[i][j][1], vecLvlData[i][j][4]);
//                траблы с врагами, которые были уничтожены оружием - или не появляяются или не двигаются; с просто уехавшими все норм
                tmpPartLvl.addChild(tmp2);
                vecEn.push(tmp2);
//                if (vecLvlData[i][j][4] >= 2) {
//                    vecDynamicEn.push(tmp2);
//                }
                tmp2 = null;
            } else {
                //значит делаем монетку
                if ((tmp3 = vecPoolCoins.pop()) == null) {
                    tmp3 = new Coin();
                }
                tmp3.setCoin(vecLvlData[i][j][0], vecLvlData[i][j][1], vecLvlData[i][j][7]);
                tmpPartLvl.addChild(tmp3);
                vecCoins.push(tmp3);
                tmp3 = null;
            }
        }
        l = vecParts.length;
        if (l != 0)
            tmpPartLvl.x = vecParts[l - 1].x + (vecParts[l - 1].width);// + vecParts[l - 1].getChildAt(0).x);// + tmpPartLvl.getChildAt(0).x;// TODO: почекать если текстура смещается - значит надо здесь чекнуть
        vecParts.push(tmpPartLvl);
        trace(tmpPartLvl.x, " = ", tmpPartLvl.getChildAt(0).x);
        l = vecTexturePartsBlocks.length;
        if (l != 0) {
//            texturePart.x = vecTexturePartsBlocks[l - 1][Global.TEXTURE_NORMAL].x + (vecTexturePartsBlocks[l - 1][Global.TEXTURE_NORMAL].width);// + vecTexturePartsBlocks[l - 1][Global.TEXTURE_NORMAL].getChildAt(0).x);
            texturePart.x = tmpPartLvl.x;
        }
//        texturePart2.x = texturePart.x;
        texturePart3.x = texturePart.x;
        texturePart4.x = texturePart.x;
        vecTexturePartsBlocks.push(new <MovieClip>[texturePart, texturePart3, texturePart4]);
        textureStrokePart.x = texturePart.x;
        vecTexturePartsBlocksStroke.push(textureStrokePart);
        trace("adding new part!");
        // trace ниже не правильный потому что кол-во блоков на карте считается неправильно, так как на обычный блок уходит 3, а на разрушающийся 1
//        trace("pool = " + vecPoolBlocks.length + "; vecBl = " + (vecBl.length - 25) * 3 + "; all=" + (vecPoolBlocks.length + (vecBl.length - 25) * 3));
        trace("pool = " + vecPoolBlocks.length + "; vecBl = " + vecBl.length + "; all=" + (vecPoolBlocks.length + vecBl.length));
//        trace("poolEn = " + vecPoolEnemies.length + "; vecEn = " + vecEn.length + "; all=" + (vecPoolEnemies.length + vecEn.length));
//        trace("poolCoins = " + vecPoolCoins.length + "; vecCoins = " + vecCoins.length + "; all=" + (vecPoolCoins.length + vecCoins.length));
        //Добавление текстуры на данную часть уровня
//        this.addTexturePlane(Global.TEXTURE_NORMAL);
//        this.addTexturePlane(Global.TEXTURE_NORMAL, true);
        vecTextures.push(new <MovieClip>[this.addTexturePlane(Global.TEXTURE_NORMAL),
            this.addTexturePlane(Global.TEXTURE_FASTER),//]);//,
            this.addTexturePlane(Global.TEXTURE_SLOWLY)]);
        vecTexturesStroke.push(new <MovieClip>[this.addTexturePlane(Global.TEXTURE_NORMAL, true)]);//,
//                this.addTexturePlane(Global.TEXTURE_FASTER,true)]);//,
//                this.addTexturePlane(Global.TEXTURE_SLOWLY,true),
//                this.addTexturePlane(Global.TEXTURE_BORDER,true)]);
//
        this.addChild(texturePart);
        this.addChild(texturePart3);
        this.addChild(texturePart4);
        this.addChild(textureStrokePart);
        this.addChild(tmpPartLvl);
        var i_t:int = vecTextures.length - 1;
        vecTextures[i_t][Global.TEXTURE_NORMAL].mask = vecTexturePartsBlocks[i_t][Global.TEXTURE_NORMAL];
        vecTextures[i_t][Global.TEXTURE_FASTER].mask = vecTexturePartsBlocks[i_t][Global.TEXTURE_FASTER];
        vecTextures[i_t][Global.TEXTURE_SLOWLY].mask = vecTexturePartsBlocks[i_t][Global.TEXTURE_SLOWLY];
        vecTexturesStroke[i_t][Global.TEXTURE_NORMAL].mask = vecTexturePartsBlocksStroke[i_t];
        this.setChildIndex(vecTextures[i_t][Global.TEXTURE_FASTER], this.numChildren - 1);
        this.setChildIndex(vecTextures[i_t][Global.TEXTURE_SLOWLY], this.numChildren - 1);
        this.setChildIndex(vecTextures[i_t][Global.TEXTURE_NORMAL], this.numChildren - 1);
        setupTextures(i_t);

    }

    /*
     *TODO структура: vecTextures имеет на каждый блок блоков свой контейнер из [normal, fast, slow, border]
     * аналогично с обводкой (надо еще по иксу поправить текстуры и цвет тинта),
     * по той же схеме сделать с vecTexturePartsBlocks - уже хз, мб лучше сразу в маску запихивать
     *
     * */
    public function addTexturePlane(type:int = 0, isTint:Boolean = false):MovieClip {
        var tmpTexture:MovieClip = new MovieClip();
        var partTexture:MovieClip;
        var testI:int = 0;
        do {
            switch (type) {
                case Global.TEXTURE_NORMAL :
                    partTexture = new NormalTextureMc();
                    break;
                case Global.TEXTURE_FASTER :
                    partTexture = new IceTextureMc();
                    break;
                case Global.TEXTURE_SLOWLY :
                    partTexture = new DirtTextureMc();
                    break;
                default:
                    trace("Error");
                    break;
            }
//            partTexture.visible = false;
//            partTexture.x = tmpTexture.getChildAt(tmpTexture.numChildren - 1).x;
            partTexture.x = tmpTexture.width;
            tmpTexture.addChild(partTexture);
        } while (tmpTexture.width <= vecParts[vecParts.length - 1].width);
        tmpTexture.x = vecTexturePartsBlocks[vecTexturePartsBlocks.length - 1][Global.TEXTURE_NORMAL].x;
//        if(vecTextures.length > 0)
//            tmpTexture.x = vecTextures[vecTextures.length - 1][0].x;
        if (isTint) {
            setTint(tmpTexture, 0x555555, .2);
//            vecTexturesStroke.push(tmpTexture);
        } else {
//            vecTextures.push(tmpTexture);
        }
        this.addChild(tmpTexture);
//        tmpTexture.visible = false;
        return tmpTexture;
        //обводка
        function setTint(displayObject:DisplayObject, tintColor:uint, tintMultiplier:Number):void {
            var colTransform:ColorTransform = new ColorTransform();
            colTransform.redMultiplier = colTransform.greenMultiplier = colTransform.blueMultiplier = 1 - tintMultiplier;
            colTransform.redOffset = Math.round(((tintColor & 0xFF0000) >> 16) * tintMultiplier);
            colTransform.greenOffset = Math.round(((tintColor & 0x00FF00) >> 8) * tintMultiplier);
            colTransform.blueOffset = Math.round(((tintColor & 0x0000FF)) * tintMultiplier);
            displayObject.transform.colorTransform = colTransform;
        }
    }

    public function deleteObj(mc:MovieClip = null, type:int = 1):void {
        //TODO check this deleting blocks
        if (type == 1) {
            for each (var tmp:MovieClip in vecParts) {
                if (tmp is Enemy)
                    tmp.resetEnemy();
                if (mc.parent == tmp) {
                    tmp.removeChild(mc);
                    return;
                }
            }
        }
    }

    public function stopSpd():void {
        spd = 0;
    }

    public function update():void {
        var started:Number = getTimer();
        var rdm:int;
        var l:int;
        for (var i:int = vecParts.length - 1; i >= 0; i--) {
            vecParts[i].x -= spd;
            vecTexturePartsBlocksStroke[i].x -= spd;
            for (var i_i:int = 0; i_i < vecTextures[i].length; i_i++) {
                vecTexturePartsBlocks[i][i_i].x -= spd;
                vecTextures[i][i_i].x -= spd;
            }
            vecTexturesStroke[i][0].x -= spd;
            vecDopTextures[i][0].x -= spd;
            vecDopTextures[i][1].x -= spd;
            if (vecParts[i].x <= -(vecParts[i].width + vecParts[i].getChildAt(0).x)) {
                removePartLvl(i);
            }
        }
        //update prefront textures
        if (blurFilter == null) {
            blurFilter = new BlurFilter(20,0,BitmapFilterQuality.LOW);
        }
        i = vecPreFrontTextures.length;         //кол-во существуюших частей префронт текстур
        if (i < 2 && Math.random() < .013 ) {   //TODO подкрутить псевдорандом
            if ((preFrontTextureMc = vecPoolPreFrontTextures.pop() as PreFrontTextureMc) == null) {
                preFrontTextureMc = new PreFrontTextureMc();
            }
            blurFilter.blurX = 20;
            blurFilter.blurY = 0;

            preFrontTextureMc.filters = [blurFilter];
            //TODO поправить x появления
            if (i> 0 && (vecPreFrontTextures[i-1].x + vecPreFrontTextures[i-1].width > Game.SWF_W)) {
                preFrontTextureMc.x = preFrontTextureMc.width + vecPreFrontTextures[i-1].x + vecPreFrontTextures[i-1].width + Math.round(Math.random() * 300);
            } else {
                preFrontTextureMc.x = preFrontTextureMc.width * 1.5;
            }
            vecPreFrontTextures.push(preFrontTextureMc);
            _root.getPreFrontTextureMc().addChild(preFrontTextureMc);
        }
        for (i = 0; i < vecPreFrontTextures.length; i++) {
            vecPreFrontTextures[i].x -= spd * 3;
            if(vecPreFrontTextures[i].x < -vecPreFrontTextures[i].width){
                vecPoolPreFrontTextures.push(vecPreFrontTextures[i]);
                _root.getPreFrontTextureMc().removeChild(vecPreFrontTextures[i]);
                vecPoolPreFrontTextures[i] = null;
                vecPreFrontTextures.splice(i, 1);
            }
        }
        //update preBg textures
        i = vecPreBgTextures.length;
        if (i < 2 && Math.random() < .013 ) {   //TODO подкрутить псевдорандом
            if ((preBgTextureMc = vecPoolPreBgTextures.pop() as PreFrontTextureMc) == null) {
                preBgTextureMc = new PreFrontTextureMc();
            }
//            if (blurFilter == null) {
//                blurFilter = new BlurFilter(20,20,BitmapFilterQuality.LOW);
//            }
            blurFilter.blurX = 50;
            blurFilter.blurY = 20;
            preBgTextureMc.filters = [blurFilter];
            //TODO поправить x появления
            if (i> 0 && (vecPreBgTextures[i-1].x + vecPreBgTextures[i-1].width > Game.SWF_W)) {
                preBgTextureMc.x = preBgTextureMc.width + vecPreBgTextures[i-1].x + vecPreBgTextures[i-1].width + Math.round(Math.random() * 300);
            } else {
                preBgTextureMc.x = preBgTextureMc.width * 1.5;
            }
            vecPreBgTextures.push(preBgTextureMc);
            _root.getPreBgTextureMc().addChild(preBgTextureMc);
        }
        for (i = 0; i < vecPreBgTextures.length; i++) {
            vecPreBgTextures[i].x -= spd * .5;
            if(vecPreBgTextures[i].x < -vecPreBgTextures[i].width){
                vecPoolPreBgTextures.push(vecPreBgTextures[i]);
                _root.getPreBgTextureMc().removeChild(vecPreBgTextures[i]);
                vecPreBgTextures[i] = null;
                vecPreBgTextures.splice(i, 1);
            }
        }



//        какие-то неполадки с бордер
        //чек и добавление новой части уровня
        if (vecParts[0] != null && vecParts[0].x <= 0 && vecParts.length == 2) {
            rdm = int(Math.random() * vecLvlData.length);
            if (vecRdm.length != vecLvlData.length && vecRdm.length != 0) {
                var flag:Boolean = true;
                while (flag) {
                    flag = false;
                    rdm = int(Math.random() * vecLvlData.length);
                    for (var r:int = 0; r < vecRdm.length; r++) {
                        if (rdm == vecRdm[r]) {
                            flag = true;
                        }
                    }
                }
                vecRdm.push(rdm);
            } else {
                vecRdm = new <int>[];
                rdm = int(Math.random() * vecLvlData.length);
                vecRdm.push(rdm);
            }
            createPartLvl(rdm);
//            createPartLvl(7);
        }
//        if (getTimer() - started > 0)
//            trace("delta = " + (getTimer() - started));
    }

    private function removePartLvl(i:int = 0, fullReset:Boolean = false) : void {
        var l:int = vecParts[i].numChildren - 1;
        var indexDetail:int;
        for (var j:int = l; j >= 0; j--) {
            if (vecParts[i].getChildAt(j) is Block) {
                indexDetail = vecBl.indexOf(vecParts[i].getChildAt(j));
                if (indexDetail >= 0) {
                    vecPoolBlocks.push(vecBl[indexDetail]);
//                            vecParts[i].removeChild(vecBl[indexDetail]);
                    vecBl[indexDetail] = null;
                    vecBl.splice(indexDetail, 1);
                } else {
                    indexDetail = vecBlForDel.indexOf(vecParts[i].getChildAt(j));
                    vecPoolBlocks.push(vecBlForDel[indexDetail]);
                    vecBlForDel[indexDetail] = null;
                    vecBlForDel.splice(indexDetail, 1);
                }
            } else if (vecParts[i].getChildAt(j) is Enemy) {
                indexDetail = vecEn.indexOf(vecParts[i].getChildAt(j));
                vecPoolEnemies.push(vecEn[indexDetail]);
//                        if (vecEn[indexDetail].getType() >= 3)
//                            vecDynamicEn.splice(vecDynamicEn.indexOf(vecEn[indexDetail]), 1);
                vecEn[indexDetail] = null;
                vecEn.splice(indexDetail, 1);
            } else if (vecParts[i].getChildAt(j) is Coin) {
                indexDetail = vecCoins.indexOf(vecParts[i].getChildAt(j));
                vecPoolCoins.push(vecCoins[indexDetail]);
                vecCoins[indexDetail] = null;
                vecCoins.splice(indexDetail, 1);
            }
            vecParts[i].removeChild(vecParts[i].getChildAt(j));
        }
        for (var d:int = 0; d < vecTexturePartsBlocks[i].length; d++) {
            for (j = vecTexturePartsBlocks[i][d].numChildren - 1; j > -1; j--) {
                vecPoolBlocks.push(vecTexturePartsBlocks[i][d].getChildAt(j));
                vecTexturePartsBlocks[i][d].removeChildAt(j);
                if (vecTexturePartsBlocksStroke[i].numChildren > 0) {
                    vecPoolBlocks.push(vecTexturePartsBlocksStroke[i].getChildAt(j));
                    vecTexturePartsBlocksStroke[i].removeChildAt(j);
                }
            }
            this.removeChild(vecTexturePartsBlocks[i][d]);
        }
        vecTexturePartsBlocks[i] = null;
        vecTexturePartsBlocks.splice(i, 1);
        this.removeChild(vecTexturePartsBlocksStroke[i]);
        vecTexturePartsBlocksStroke[i] = null;
        vecTexturePartsBlocksStroke.splice(i, 1);
        for (j = 0; j < vecDopTextures[i].length; j++) {
            for (var k:int = vecDopTextures[i][j].numChildren - 1; k > -1; k--) {
                vecDopTextures[i][j].removeChildAt(k);
            }
        }
        _root.getFrontTextureMc().removeChild(vecDopTextures[i][0]);
        _root.getBackTextureMc().removeChild(vecDopTextures[i][1]);
        vecDopTextures[i] = null;
        vecDopTextures.splice(i, 1);
        this.removeChild(vecParts[i]);
        vecParts[i] = null;
        vecParts.splice(i, 1);
        for (var i_i:int = 0; i_i < vecTextures[i].length; i_i++) {
            this.removeChild(vecTextures[i][i_i]);
        }
        this.removeChild(vecTexturesStroke[i][0]);
        vecTextures[i] = null;
        vecTextures.splice(i, 1);
//                this.removeChild(vecTexturesStroke[i]);
        vecTexturesStroke[i] = null;
        vecTexturesStroke.splice(i, 1);
        if (fullReset) {
            for (j = 0; j < vecPreFrontTextures.length; j++) {
//                vecPreFrontTextures[j].x -= spd * 3;
//                if(vecPreFrontTextures[j].x < -vecPreFrontTextures[j].width){
                    vecPoolPreFrontTextures.push(vecPreFrontTextures[j]);
                    _root.getPreFrontTextureMc().removeChild(vecPreFrontTextures[j]);
                    vecPoolPreFrontTextures[j] = null;
                    vecPreFrontTextures.splice(j, 1);
//                }
            }
            for (j = 0; j < vecPreBgTextures.length; j++) {
                vecPoolPreBgTextures.push(vecPreBgTextures[j]);
                _root.getPreBgTextureMc().removeChild(vecPreBgTextures[j]);
                vecPoolPreBgTextures[j] = null;
                vecPreBgTextures.splice(j, 1);
            }
        }

    }

    private var vecRdm:Vector.<int> = new Vector.<int>();
//    для обводки надо создавать такае же блоки и или scale9 их или просто создавать со смешением и увеличенными
//хз как по скорости конечно
    private function setupTextures(i:int = 0):void {
        var frontTextureBlock:FrontTextureBlock;
        var oneBlockCntr:MovieClip;
        var backTextureBlock:BackTextureBlock;
        var frontCntr:MovieClip;
        var backCntr:MovieClip;
        var tmp_mc:Block;
        var tmp_cur:Block;
        var flag:Boolean = true;
        frontCntr = new MovieClip();
        backCntr = new MovieClip();
        oneBlockCntr = new MovieClip();
        for (var k:int = 0; k < vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].numChildren; k++) {
            tmp_mc = vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].getChildAt(k) as Block;
            flag = true;
            for (var j:int = 0; j < vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].numChildren; j++) {
                tmp_cur = vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].getChildAt(j) as Block;
                // возможно нид добавить равно в условие ниже
                if (tmp_cur != tmp_mc && tmp_cur.y < tmp_mc.y && Math.max(tmp_cur.x, tmp_mc.x) + ((tmp_cur.x < tmp_mc.x) ? tmp_mc.width : tmp_cur.width) - Math.min(tmp_cur.x, tmp_mc.x) < tmp_cur.width + tmp_mc.width && Math.abs(tmp_cur.y - tmp_mc.y) < tmp_cur.height) {
                    flag = false;
                }
            }
//            sdasdasdasd
            //после создания битмапа делитить мувики
            if (flag) {
                oneBlockCntr = new MovieClip();
                frontTextureBlock = new FrontTextureBlock();
                frontTextureBlock.gotoAndStop(2);
                frontTextureBlock.x = oneBlockCntr.width;
                oneBlockCntr.addChild(frontTextureBlock);
                var ln:int = tmp_mc.width / frontTextureBlock.width;
                for (j = 0; j < ln; j++) {
                    frontTextureBlock = new FrontTextureBlock();
//                    frontTextureBlock.gotoAndStop(int(Math.random() * 2) + 1)
                    frontTextureBlock.gotoAndStop(1);
                    frontTextureBlock.x = oneBlockCntr.width;
                    oneBlockCntr.addChild(frontTextureBlock);
                }
                frontTextureBlock = new FrontTextureBlock();
                frontTextureBlock.gotoAndStop(2);
                frontTextureBlock.scaleX = -1;
                frontTextureBlock.x = oneBlockCntr.width;
                oneBlockCntr.addChild(frontTextureBlock);
                oneBlockCntr.x = vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].x + vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].getChildAt(k).x;// + vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].getChildAt(k).width * .5;
                oneBlockCntr.y = vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].getChildAt(k).y;
                var bitmapData:BitmapData = new BitmapData(oneBlockCntr.width * 2, oneBlockCntr.height * 2, true, 0);
                bitmapData.draw(oneBlockCntr);
                // And to actually see it
                var bitmap:Bitmap = new Bitmap(bitmapData);
                bitmap.x = -frontTextureBlock.width * .5 + vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].x + vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].getChildAt(k).x;// + vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].getChildAt(k).width * .5;
                bitmap.y = vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].getChildAt(k).y - bitmap.height * .5;
                frontCntr.addChild(bitmap);
                frontTextureBlock = null;
                oneBlockCntr = null;
                backTextureBlock = new BackTextureBlock();
                backTextureBlock.gotoAndStop(int(Math.random() * 2) + 1)
                backTextureBlock.x = vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].x + vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].getChildAt(k).x + vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].getChildAt(k).width * .5;
                backTextureBlock.y = vecTexturePartsBlocks[i][Global.TEXTURE_NORMAL].getChildAt(k).y;
                backCntr.addChild(backTextureBlock);
                backTextureBlock = null;
            }
        }



//        frontCntr.cacheAsBitmap = true;
        backCntr.cacheAsBitmap = true;
        vecDopTextures.push(new <MovieClip>[frontCntr, backCntr]);
//        _root.getFrontTextureMc().addChild(bitmap);
        _root.getFrontTextureMc().addChild(frontCntr);
        _root.getBackTextureMc().addChild(backCntr);
    }

    public function addFreeEnemyToPool(en:Enemy):void {
        this.vecPoolEnemies.push(en);
    }

    public function addFreeCoinToPool(c:Coin):void {
        this.vecPoolCoins.push(c);
    }

    public function addFreeBlockToPool(b:Block):void {
        this.vecPoolBlocks.push(b);
    }

    public function addBlockDelAnim(b:Block):void {
        this.vecBlForDel.push(b);
    }

    public function getCountDelAnim():int {
        return this.vecBlForDel.length;
    }

    public function getSpeed():int {
        return spd;
    }

//    проблемы с большим "dirt"
//    public function getArrBl():Array{
//        return arrBl;
//    }
//    public function getArrEn():Array{
//        return vecEn;
//    }
//    public function getArrCoins():Array{
//        return vecCoins;
//    }
//    private function checkX(a, b):int
//    {
//        if (a[0] > b[0])
//        {
//            return -1;
//        }
//        else if (a[0] < b[0])
//        {
//            return 1;
//        }
//        else
//        {
//            return 0;
//        }
//    }
//    private function checkY(a, b):int
//    {
//        if (a[1] < b[1])
//        {
//            return -1;
//        }
//        else if (a[1] > b[1])
//        {
//            return 1;
//        }
//        else
//        {
//            return 0;
//        }
//    }
}
}
