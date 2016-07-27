/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 27.02.14
 * Time: 21:14
 * To change this template use File | Settings | File Templates.
 */
package Hero {
import Hero.Weapon.Gun;
import Hero.Weapon.IWeapon;
import Hero.Weapon.Sword;
import Hero.Weapon.WeaponMelee;
import Hero.Weapon.WeaponRange;

import flash.display.MovieClip;

public class Hero extends MovieClip {
    private var _root:MovieClip;
    public var vy:Number;
    public var vx:Number;
    public const _maxVX:Number = 12;
    public const _maxVY:Number = 10;
    public var state:int;//1 - normal, 2 - bend
    public var countJumps:int;//for double jump
    public var countAttacks:int;
    public var alrdAttacked:Boolean;
    public var isAttack:Boolean;
    public var isJump:Boolean;
    public var secondJumpAllowed:Boolean;
    public var groundType:int;// 0 - block, 1 - ice, 2 - dirt
    private var _gravity:Number = .9;
    private var _jumpV:Number = -11;
    private var _friction:Number = .95;
    private var _heroDebug:HeroDebug;
    private var _weaponCurrent:IWeapon;
    private var _gun:Gun;
    private var _sword:Sword;
    private var _weaponRange:WeaponRange;
    private var _weaponMelee:WeaponMelee;
    private var _vecWeapons:Vector.<IWeapon>;
    private var _vecHitedHitboxes:Vector.<Boolean>;
    private var _p1:MovieClip;
    private var _p2:MovieClip;
    private var _p3:MovieClip;
    private var _p4:MovieClip;

    public function Hero(_rt:MovieClip, wp1:WeaponMelee = null, wp2:WeaponRange = null) {
        //TODO: сволота все равно проваливается
        reset();
        _root = _rt;
        _heroDebug = new HeroDebug();
        _heroDebug.area_mc.visible = false;
        _heroDebug.magnit_mc.visible = false;
        this.addChild(_heroDebug);
        _vecWeapons = new Vector.<IWeapon>();
//        _vecWeapons.push(wp1,wp2);
        _weaponMelee = wp1;
        _weaponRange = wp2;
//
        _weaponCurrent = _weaponMelee;
        _gun = new Gun(_rt);
        _gun.x = _heroDebug.x;
        _gun.y = _heroDebug.y - _heroDebug.height/2;
        this.addChild(_gun);
        _sword = new Sword();
        this.addChild(_sword);
        _vecWeapons.push(_gun, _sword);
        _weaponMelee = _sword;
        _weaponRange = _gun;
        _weaponCurrent = _vecWeapons[0];
//        _weapon = _gun;
        _p1 = new MovieClip();
        _p2 = new MovieClip();
        _p3 = new MovieClip();
        _p4 = new MovieClip();
//        this.addChild(_p1);
//        this.addChild(_p2);
//        this.addChild(_p3);
//        this.addChild(_p4);
        vy = 0;
    }

    public function reset():void{
        vx = 0;
        vy = 0;
        state = 1;
        countJumps = 0;
        countJumps= 0;//for double jump
        countAttacks = 0;
        alrdAttacked = false;
        isAttack = false;
        isJump = false;
        secondJumpAllowed = false;
        groundType = 0;// 0 - block, 1 - ice, 2 - dirt

    }

    public function atack():void {
//        _weaponMelee.activate();
        trace("activate");
//        _weapon.activate();
        _weaponCurrent.activate();
    }

    public function get debugHero():HeroDebug {
        return _heroDebug;
    }

    public function getWeapon(t:int = 0):IWeapon {
        if (t == 0)
            return _weaponCurrent;
        if (t == 1)
            return _weaponMelee;
        if (t == 2)
            return _weaponRange;
        return null;
    }

//    public function getWeapon():WeaponRange {
//        return _weapon;
//    }
//    public function setDirectionX(q:int = 1):void {
////        if (_directionX != q){
////            vx = 0;
////            _directionX = q;
////        }
//    }
    public function update():void {
        if (this.groundType == Block.DIRT)
            this._friction = .5;
        else if (this.groundType == Block.ICE)
            this._friction = .99;
        else
            this._friction = .95;
        vx *= _friction;
        if (vx > 0)
            vx = (vx > _maxVX) ? _maxVX : vx;
        else if (vx < 0)
            vx = (vx < _maxVX * -1) ? _maxVX * -1 : vx;
        this.x += vx;// * _directionX;
        vy += _gravity;
        vy = (vy > _maxVY) ? _maxVY : vy;
        this.y += vy;
        isJump = (vy < 50 && vy > 1 ) ? true : isJump;
//        if(_heroDebug.weapon != null)
//            _heroDebug.weapon.visible = this.isAttack;
        for each (var wp:IWeapon in _vecWeapons) {
            wp.update();
        }
//        _weaponCurrent.update();
//        _weaponMelee.update();
//        if(this.isAttack && !_timerAttack.running){
//            this.countAttacks = 1;
//            _timerAttack.start();
//        }else if(!this.isAttack && _timerAttack.running){
//            this.countAttacks = 0;
//            _timerAttack.stop();
//            _timerAttack.reset();
//        }
//        this._heroDebug.alpha = .2;
        _p1.graphics.clear();
        _p1.graphics.beginFill(0x000000, .3);
        _p1.graphics.drawRect(_heroDebug.p1.getBounds(this).x - _heroDebug.p5.getBounds(this).width * .2, (_heroDebug.p1.getBounds(this).y), _heroDebug.p5.getBounds(this).width * .6, _heroDebug.p1.getBounds(this).height);
//        _p1.graphics.drawRect(_heroDebug.p1.getBounds(this).x- _heroDebug.p5.getBounds(this).width * .2+vx  * _directionX,(_heroDebug.p1.getBounds(this).y)+vy*2,_heroDebug.p5.getBounds(this).width * .6,_heroDebug.p1.getBounds(this).height);
        _p1.graphics.endFill();
        _p2.graphics.clear();
        _p2.graphics.beginFill(0x000000, .3);
        _p2.graphics.drawRect(_heroDebug.p2.getBounds(this).x, (_heroDebug.p2.getBounds(this).y), _heroDebug.p2.getBounds(this).width, _heroDebug.p2.getBounds(this).height * .5);
//        _p2.graphics.drawRect(_heroDebug.p2.getBounds(this).x+vx*2*_directionX,(_heroDebug.p2.getBounds(this).y)+vy+_heroDebug.p4.getBounds(this).height *.2,_heroDebug.p2.getBounds(this).width,_heroDebug.p2.getBounds(this).height *.5);
        _p2.graphics.endFill();
        _p3.graphics.clear();
        _p3.graphics.beginFill(0x000000, .3);
        _p3.graphics.drawRect(_heroDebug.p3.getBounds(this).x - _heroDebug.p5.getBounds(this).width * .2, (_heroDebug.p3.getBounds(this).y), _heroDebug.p5.getBounds(this).width * .6, _heroDebug.p3.getBounds(this).height);
//        _p3.graphics.drawRect(_heroDebug.p3.getBounds(this).x- _heroDebug.p5.getBounds(this).width * .2+vx *_directionX,(_heroDebug.p3.getBounds(this).y)+vy*2,_heroDebug.p5.getBounds(this).width * .6,_heroDebug.p3.getBounds(this).height);
        _p3.graphics.endFill();
        _p4.graphics.clear();
        _p4.graphics.beginFill(0x000000, .3);
        _p4.graphics.drawRect(_heroDebug.p4.getBounds(this).x, (_heroDebug.p4.getBounds(this).y), _heroDebug.p4.getBounds(this).width, _heroDebug.p4.getBounds(this).height * .5);
//        _p4.graphics.drawRect(_heroDebug.p4.getBounds(this).x+vx*2*_directionX,(_heroDebug.p4.getBounds(this).y)+vy+_heroDebug.p4.getBounds(this).height *.2,_heroDebug.p4.getBounds(this).width,_heroDebug.p4.getBounds(this).height *.5);
        _p4.graphics.endFill();
    }

    public function switchWeapon():void {
        trace(_vecWeapons);
//        _vecWeapons.push(_vecWeapons[0]);
        _vecWeapons.push(_vecWeapons.splice(0, 1)[0]);
        _weaponCurrent = _vecWeapons[0];
        trace("currWeap=" + _weaponCurrent);
    }

    private function drawBound(mc:MovieClip):void {
    }

    public function jump():void {
        if (!isJump || (secondJumpAllowed && countJumps < 3)) {
            secondJumpAllowed = false;
            countJumps++;
            isJump = true;
            vy = _jumpV;
        }
    }

    public function changeState(st:int, vec:Vector.<Block>):void {
        var tmp:Boolean = false;
        if (state != st) {
            //if(st == 2)
            for (var i:int = 0; i < vec.length && !tmp; i++) {
                tmp = this.isHitWith(0, vec[i]);
                if (tmp)
                    vy = 0;
            }
            if (tmp == false || state == 1) {
                debugHero.gotoAndStop(st);
                state = st;
            }
        }
    }

    private var hitedHBoxes:int = 0;

    public function isHitWith(type:int, mc:MovieClip = null):Boolean {
        //type: 0-top, 1-right, 2-bot, 3-left, 4 -all, 5 - weapon, 6 - coins
        hitedHBoxes = createVecHitedHBoxes(mc);
        /*
         createVecHitedHBoxes(mc);
         if (type == 0) {
         return mc.hitTestObject(this._p1);
         //            return mc.hitTestObject(this._heroDebug.p1);
         }
         if (type == 1) {
         return mc.hitTestObject(this._p2);
         //            return mc.hitTestObject(this._heroDebug.p2);
         }
         if (type == 2) {
         return mc.hitTestObject(this._p3);
         //            return mc.hitTestObject(this._heroDebug.p3);
         }
         if (type == 3) {
         return mc.hitTestObject(this._p4);
         //            return mc.hitTestObject(this._heroDebug.p4);
         }
         //        */
//        var tmp:int = 5;// <- скорость уровня
        if (type == 4) {
            if (mc is Enemy)
                return mc.checkCollision(this._heroDebug.p5);
            return mc.hitTestObject(this._heroDebug.p5);
        } else if (type == 5 && _weaponMelee != null) {
            if (mc is Enemy)
                return mc.checkCollision(this._weaponMelee);
            return mc.hitTestObject(this._weaponMelee);
        } else if (type == 6) {
            return mc.hitTestObject(_heroDebug.magnit_mc);
        } else {
            if (hitedHBoxes > 1) {
                if (vx >= 0 && vy >= 0) {
                    if (vx / (_maxVX + Global._spdLvl) > vy / _maxVY) {
                        if (type == 1)
                            return _vecHitedHitboxes[1];
                    } else if (type == 2) {
                        return _vecHitedHitboxes[2];
                    }
                } else if (vx >= 0 && vy <= 0) {
                    if (vx / (_maxVX + Global._spdLvl) > Math.abs(vy) / _maxVY) {
                        if (type == 1)
                            return _vecHitedHitboxes[1];
                    } else if (type == 0) {
                        return _vecHitedHitboxes[0];
                    }
                } else if (vx <= 0 && vy <= 0) {
                    if (Math.abs(vx) / (_maxVX + Global._spdLvl) > Math.abs(vy) / _maxVY) {
                        if (type == 3)
                            return _vecHitedHitboxes[3];
                    } else if (type == 0) {
                        return _vecHitedHitboxes[0];
                    }
                } else if (vx <= 0 && vy >= 0) {
                    if (Math.abs(vx) / (_maxVX + Global._spdLvl) > vy / _maxVY) {
                        if (type == 3)
                            return _vecHitedHitboxes[3];
                    } else if (type == 2) {
                        return _vecHitedHitboxes[2];
                    }
                }
            } else if (createVecHitedHBoxes(mc) == 1) {
                return _vecHitedHitboxes[type];
            }

        }
        return false;
    }

    private function createVecHitedHBoxes(mc:MovieClip = null):int {
        _vecHitedHitboxes = null;
        _vecHitedHitboxes = new Vector.<Boolean>();
        _vecHitedHitboxes.push(
                mc.hitTestObject(this._heroDebug.p1),
                mc.hitTestObject(this._heroDebug.p2),
                mc.hitTestObject(this._heroDebug.p3),
                mc.hitTestObject(this._heroDebug.p4)
//                mc.hitTestObject(this._p1),
//                mc.hitTestObject(this._p2),
//                mc.hitTestObject(this._p3),
//                mc.hitTestObject(this._p4)
        );
        var q:int = int(_vecHitedHitboxes[0] + _vecHitedHitboxes[1] + _vecHitedHitboxes[2] + _vecHitedHitboxes[3]);
        return q;
    }

    public function resetCJumps():void {
        countJumps = 0;
        secondJumpAllowed = true;
    }

//    private function onTick(e:TimerEvent):void{
//        this.countAttacks ++;
////        trace(" tick");
////        if(e.target.count == 2)
//
//    }
}
}
