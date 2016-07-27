/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 27.02.14
 * Time: 19:38
 * To change this template use File | Settings | File Templates.
 */
package {
import Hero.Hero;
import Hero.Weapon.Bullet;

import com.senocular.utils.KeyObject;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.system.System;
import flash.ui.Keyboard;

//TODO: если тормоза - можно разбить циклы по тикам. чтобы не в одном каде все перебиралось, а частями. в закладках где-то висит страница с этим
public class Game extends MovieClip {
    public static const SWF_H:int = 400;
    public static const SWF_W:int = 640;
    private var boundsOffsetX:Number = .15;
    private var boundsOffsetY:Number = .15;
//    private var _arrBlocks:Array;
//    private var _arrEnemies:Array;
    private var _hero:Hero;
    private var _keyObj:KeyObject;
    private var _preFrontTexturesMc:MovieClip;
    private var _preBgTexturesMc:MovieClip;
    private var _frontTexturesMc:MovieClip;
    private var _backTexturesMc:MovieClip;
    private var _bulletsContainer:MovieClip;
    private var currMoney:int;
    private var tmpLvl:Lvl;

    public function Game() {
        if (stage) init();
        else addEventListener(Event.ADDED_TO_STAGE, init);
    }

    public function reset() : void {
        currMoney = 0;
        _hero.reset();
        //next reset all vecs
        tmpLvl.reset();
    }

    public function getHero():Hero {
        return _hero;
    }

    public function getPreFrontTextureMc():MovieClip {
        return _preFrontTexturesMc;
    }

    public function getPreBgTextureMc():MovieClip {
        return _preBgTexturesMc;
    }

    public function getFrontTextureMc():MovieClip {
        return _frontTexturesMc;
    }

    public function getBackTextureMc():MovieClip {
        return _backTexturesMc;
    }

    public function getBulletnsContainerMc():MovieClip {
        return _bulletsContainer;
    }

    private function init(e:Event = null):void {
        _backTexturesMc = new MovieClip();
        _preFrontTexturesMc = new MovieClip();
        _preBgTexturesMc = new MovieClip();
        _frontTexturesMc = new MovieClip();
        _bulletsContainer = new MovieClip();
        setup();
        setupTextures()
    }

    private function setup():void {
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        _keyObj = new KeyObject(stage);
//        _arrBlocks = new Array();
//        _arrEnemies = new Array();
        //adding blocks
        _hero = new Hero(this);
        _hero.x = SWF_W * .5;
        _hero.y = SWF_H * .7;
        this.addChild(_hero);
//чекнуть fps с перемещением уровня частями.
        //add lvl
        tmpLvl = new Lvl(this);
        tmpLvl.setup();
//        _arrBlocks = _arrBlocks.concat(tmpLvl.arrBl);
//        _arrEnemies = _arrEnemies.concat(tmpLvl.vecEn);
        this.addChild(tmpLvl);
        //сортировка массива, для правильной обработки хитбоксов.
//        _arrBlocks.sort(checkX);
//        _arrBlocks.sort(checkY);
//        trace(_arrBlocks);
        currMoney = 0;
    }

    private function onKeyUp(e:KeyboardEvent):void {
        if (e.keyCode == Keyboard.UP) {
            _hero.secondJumpAllowed = true;
            _hero.countJumps++;
        }
        if (e.keyCode == Keyboard.SPACE) {
            _hero.isAttack = false;
            _hero.alrdAttacked = false;
        }
        if (e.keyCode == Keyboard.P) {
            isPause = (isPause) ? false : true;
        }
        if (e.keyCode == Keyboard.ESCAPE) {
            tmpLvl.reset();
//            System.exit(0);
        }
    }

    private function onKeyDown(e:KeyboardEvent):void {
        if (e.keyCode == Keyboard.Q) {
            _hero.switchWeapon();
            trace("pressed");
        }
    }

    private var isPause:Boolean = false;
    private var tmpX:int = 0;
    private var tmpY:int = 0;

    public function update(e:Event):void {
        _hero.update();
        if (!isPause)
            tmpLvl.update();
        //TODO FOR TESTING
        //============! tmp for testing !===================
        if (_keyObj.isDown(Keyboard.U)) {
//            trace("vx=", (_hero.vx / (_hero._maxVX + tmpLvl.getSpeed())), ", vy=", (_hero.vy / _hero._maxVY));
            tmpLvl.traceVecs();
        }
        if (_keyObj.isDown(Keyboard.R)) {
            _hero.x = SWF_W/2;
            _hero.y = SWF_H/2;
        }
        //==================================================
//        var start:Number = getTimer();
        //TODO:если будут лаги попробовать запихнуть то что ниже в один цикл
        //TODO:мб переделать массивы на приват. но надо почитать про это
//        var q1:int = tmpLvl.arrBl.length;
//        var q2:int = tmpLvl.vecEn.length;
//        var q3 = Math.max(q1,q2);
        var i:int;
        var l:int = tmpLvl.vecBl.length - 1;
        _hero.groundType = -1;
        for (i = l; i >= 0; i--) {
            if (_hero.debugHero.area_mc.hitTestObject(tmpLvl.vecBl[i])) {
                if (_hero.isHitWith(2, tmpLvl.vecBl[i])) {
//                   надо придумать как обрбатывать при одновременном ите 2х сенсоров
//                    PixelPerfectCollisionDetection.
                    _hero.isJump = false;
                    _hero.y = tmpLvl.vecBl[i].y;
                    _hero.vy = 0;
                    _hero.resetCJumps();
                    _hero.groundType = tmpLvl.vecBl[i].t; // для скольжения/грязи и тдз
                } else if (_hero.isHitWith(0, tmpLvl.vecBl[i])) {
                    _hero.y = tmpLvl.vecBl[i].y + tmpLvl.vecBl[i].height + _hero.debugHero.p5.height;
                    _hero.vy += .2 * _hero._maxVY;
                } else if (_hero.isHitWith(1, tmpLvl.vecBl[i])) {
                    _hero.vx = 0;
                    _hero.x = tmpLvl.vecBl[i].parent.x + tmpLvl.vecBl[i].x - _hero.debugHero.p5.width * .5 - 5;// 5 = 2.5*2 - выступающие части хитбоксов по бокам
                } else if (_hero.isHitWith(3, tmpLvl.vecBl[i])) {
                    _hero.vx = 0;
                    _hero.x = tmpLvl.vecBl[i].parent.x + tmpLvl.vecBl[i].x + tmpLvl.vecBl[i].width + _hero.debugHero.p5.width * .5 + 5;
                }
            }
            //чек
            if (tmpLvl.vecBl[i].t == 1 && _hero.isHitWith(5, tmpLvl.vecBl[i])) {
                if (_hero.isAttack && !_hero.alrdAttacked) {
                    _hero.alrdAttacked = true;
                    tmpLvl.vecBl[i].reduceLife();
                }
            }
            //чек попадания снарядов в блок
            if (_hero.getWeapon(2) != null)
                for each (var q:Bullet in _hero.getWeapon(2).getArrBullets()) {
                    if (tmpLvl.vecBl[i].hitTestObject(q)) {
                        q.reduceLife();
                        if (tmpLvl.vecBl[i].t == 1)
                            tmpLvl.vecBl[i].reduceLife();
                    }
                }
            //чек контакта с enemyDynamic
            for each (var en:Enemy in tmpLvl.vecEn) {
                if (en.getType() == Enemy.TYPE_RUNNER && en.hitTestObject(tmpLvl.vecBl[i])) {
                    en.y = tmpLvl.vecBl[i].y;
                    en.vy = 0;
                }
                if (en.getType() == Enemy.TYPE_FLYING_WTIH_ATACK)
//                if(en.getType() == 4)
                {
                    en.checkCollision(tmpLvl.vecBl[i]);
                }
            }
            //delete borders
            if (tmpLvl.vecBl[i].getCurrLife() <= 0) {
                //удаление border после попадания достаточного колва патрон
//                tmpLvl.deleteObj(tmpLvl.vecBl[i]);
//                tmpLvl.addFreeBlockToPool(tmpLvl.vecBl[i]);
                tmpLvl.vecBl[i].playDestroy();
                tmpLvl.addBlockDelAnim(tmpLvl.vecBl[i]);
                tmpLvl.vecBl[i] = null;
                tmpLvl.vecBl.splice(i, 1);
            }
        }
        if (tmpX != 0 || tmpY != 0) {
        //TODO прочекать мб это вообще ересь
            if (Math.abs(tmpX - _hero.x) > 200 || Math.abs(tmpY - _hero.y) > 100) {
                _hero.x = tmpX;
                _hero.y = tmpY;
            }
        }
        tmpX = _hero.x;
        tmpY = _hero.y;
        l = tmpLvl.vecEn.length - 1;
        for (i = l; i >= 0; i--) {
            if (_hero.getWeapon(2) != null)
                for each (var q1:Bullet in _hero.getWeapon(2).getArrBullets()) {
                    //                if (tmpLvl.vecEn[i].hitTestObject(q1)) {
                    if (tmpLvl.vecEn[i].checkCollision(q1)) {
                        q1.reduceLife();
                        tmpLvl.vecEn[i].reduceLife();
                    }
                }
            if (_hero.isHitWith(5, tmpLvl.vecEn[i])) {
                if (_hero.isAttack && !_hero.alrdAttacked) {
                    _hero.alrdAttacked = true;
                    tmpLvl.vecEn[i].reduceLife();
                    trace("HIT!enemy -1 LIFE!");
                }
            }
            else if (_hero.isHitWith(4, tmpLvl.vecEn[i])) {
//            else if (tmpLvl.vecEn[i].checkCollision(_hero.debugHero.p5)) {
                trace("HIT!hero -1 LIFE!");
            }
            //delete enemies
            if (tmpLvl.vecEn[i].getCurrLife() <= 0) {
                tmpLvl.deleteObj(tmpLvl.vecEn[i]);
                tmpLvl.addFreeEnemyToPool(tmpLvl.vecEn[i]);
//                tmpLvl.vecDynamicEn.splice(tmpLvl.vecDynamicEn.indexOf(tmpLvl.vecEn[i]), 1);
                tmpLvl.vecEn[i] = null;
                tmpLvl.vecEn.splice(i, 1);
            }
        }
        //почекать по памяти. + после части уровня с динамическим енеми - следующий появляется с пропуском - наверное длина неправильно считается
        for each (var en2:Enemy in tmpLvl.vecEn) {
            if (en2.parent.x + en2.x > -en2.width && en2.parent.x + en2.x < en2.width + SWF_W)
                en2.update();
        }
        l = tmpLvl.vecCoins.length - 1;
        for (i = l; i >= 0; i--) {
            if (_hero.isHitWith(6, tmpLvl.vecCoins[i])) {
                currMoney += tmpLvl.vecCoins[i].getMoney();
                tmpLvl.deleteObj(tmpLvl.vecCoins[i]);
                tmpLvl.addFreeCoinToPool(tmpLvl.vecCoins[i]);
                tmpLvl.vecCoins[i] = null;
                tmpLvl.vecCoins.splice(i, 1);
            }
        }
//        var r:Number =getTimer() - start;
//        trace(r+"asd");
        if (_keyObj.isDown(Keyboard.RIGHT)) {
//            _hero.x += _hero.vx;
            if(_hero.x < SWF_W * (1  - boundsOffsetX)){
                _hero.vx += 1;
            } else {
                _hero.vx = 0;
            }

//            _hero.setDirectionX(1);
        } else if (_keyObj.isDown(Keyboard.LEFT)) {
//            _hero.x -= (_hero.vx+tmpLvl.getSpeed()/2);
            if(_hero.x > boundsOffsetX * SWF_W) {
                _hero.vx -= 1.5;
            } else {
                _hero.vx = 0;
            }

//            _hero.setDirectionX(-1);
        } else {
            //if (_hero.ground != "ice" || "water" || "dirt")
            if (_hero.groundType == Block.DIRT)
                _hero.x -= Global._spdLvl - 1;
            if (_hero.groundType == Block.BLOCK)
                _hero.vx = 0;
        }
        if (_keyObj.isDown(Keyboard.UP)) {
            if (!_hero.isJump || _hero.secondJumpAllowed)
                _hero.jump();
        }
        if (_keyObj.isDown(Keyboard.DOWN)) {
            _hero.changeState(2, tmpLvl.vecBl);
        } else {
            _hero.changeState(1, tmpLvl.vecBl);
        }
        if (_keyObj.isDown(Keyboard.SPACE) && _hero.state != 2 && !_hero.isAttack) {
            _hero.isAttack = true;
            _hero.atack();
        }
    }

    public function setupTextures():void {
        var bg:Bg = new Bg();
        bg.x = 320;
        bg.y = 200;
        trace("it's work", this.getChildIndex(_hero));
//        this.addChild(_preBgTexturesMc);
        this.addChildAt(_backTexturesMc, this.getChildIndex(_hero));
        this.addChildAt(_bulletsContainer, this.getChildIndex(_hero));
        this.addChildAt(bg, this.getChildIndex(_backTexturesMc));
        this.addChildAt(_preBgTexturesMc, this.getChildIndex(_backTexturesMc));
        this.addChild(_frontTexturesMc);
        this.addChild(_preFrontTexturesMc);
//        _frontTexturesMc.visible = false;
    }

//    private function checkY(a:Block, b:Block):int {
//        if (a.y < b.y) {
//            return -1;
//        }
//        else if (a.y > b.y) {
//            return 1;
//        }
//        else {
//            return 0;
//        }
//    }
//
//    private function checkX(a:Block, b:Block):int {
//        if (a.x < b.x) {
//            return -1;
//        }
//        else if (a.x > b.x) {
//            return 1;
//        }
//        else {
//            return 0;
//        }
//    }
}
}
