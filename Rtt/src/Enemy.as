/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 05.08.14
 * Time: 13:44
 * To change this template use File | Settings | File Templates.
 */
package {
import Hero.Weapon.Bullet;

import flash.display.MovieClip;
import flash.utils.getTimer;

public class Enemy extends MovieClip {
    public static const TYPE_STATIC:int = 1;
    public static const TYPE_RUNNER:int = 2;
    public static const TYPE_FLYING:int = 3;
    public static const TYPE_STATIC_WTIH_ATACK:int = 4;
    public static const TYPE_FLYING_WTIH_ATACK:int = 5;
    public static const TYPE_BOSS:int = 6;
    public var vy:Number = 0;
    public var vx:Number = 3;
    public const _maxVY:Number = 12;
    private var _gravity:Number = .9;
    private var _jumpV:Number = -11;
    private var life:int = 1;
    private var type:int;
    private var enemyDebug:EnemyDebug;
    private var bullet:Bullet;
    private var tmpTime:int;
    private var lastHitedEnemy:Boolean;
    private var direction:int = 1;//1 - left, -1 - right

    public function Enemy() {


        //под вопросом енеми с хп больше 1. если дальний бой будет - то да.
        //this.life = t+1;
//        switch (t){
//            case 0:
//                this.life = 1;
//                break;
//            case 1:
//                this.life = 2
//                break;
//            default :
//                this.life = 1;
//                break;
//        }
    }

    public function setEnemy(startX:int = 0, startY:int = 0, t:int = 0):void {
//        прочекать походу тут неправильно тип4 пересоздается
        vy = 0;
        this.x = startX;
        this.y = startY
        life = 1;
        type = t;
        if (type == Enemy.TYPE_BOSS) {
            life = 3;
        }
        //TODO : name возможно не обнуляется
        this.name = "enemy";
        if (enemyDebug == null) {
            enemyDebug = new EnemyDebug();
            this.addChild(enemyDebug);
        }
        enemyDebug.gotoAndStop(type);
        enemyDebug.p.visible = false;
        //TODO временное
        if (type == 1 || type == 2 || type == 3) {
            enemyDebug.i.gotoAndStop(1);
            enemyDebug.i.q.gotoAndPlay((int)(Math.random()*enemyDebug.i.q.totalFrames));
        }
//        tmpTime = getTimer();
        tmpTime == 0;
        tmpArray = new Array();
    }

    private var mark:Number = 0;

    public function reduceLife(count:int = 1):void {
        if (lastHitedEnemy) {
            this.life -= count;
            mark = this.x;
        }
    }

    private var tmpArray:Array;

    public function update():void {
//        ололол смотри щаметки
        if(type == Enemy.TYPE_BOSS)
            trace(this.x + " - " + direction);
        //TODO отбрасывание для всех
        if (type != Enemy.TYPE_STATIC && type != Enemy.TYPE_STATIC_WTIH_ATACK ) {
            //отбрасывание при ударе
            if (mark != 0 && this.x - mark < 100 && type != Enemy.TYPE_BOSS) {
                this.x += vx * 1.5;
                if (type == Enemy.TYPE_RUNNER && this.x - mark < 70)
                    this.y -= 10;
            } else {
                if (type != Enemy.TYPE_BOSS) {
                    this.x -= vx ;
                } else {
                    if ((this.x < Game.SWF_W * .7 && direction == 1) || (this.x > Game.SWF_W * 1.5 && direction == -1)) {
                        direction *= -1;
                    }
                    this.x -= vx * direction - Global._spdLvl * ((1 + direction)/ 2);
                }
                mark = 0;
                for (var i:int = 0; i > tmpArray.lengh; i++) {
                    tmpArray[i].x -= 10;
                }
            }
            if (type == Enemy.TYPE_RUNNER) {
                vy += _gravity;
                vy = (vy > _maxVY) ? _maxVY : vy;
                this.y += vy;
            }
//            else if (type == Enemy.TYPE_STATIC_WTIH_ATACK || type == Enemy.TYPE_FLYING_WTIH_ATACK) {
//                if(getTimer() - tmpTime >= 4000){
//                    bullet = new Bullet();
//                    bullet.setParametrs(0, 0, 10, 10, 1);
//                    tmpTime = getTimer();
//                    this.addChild(bullet);
//                    tmpArray.push(bullet);
//                }
//            }
        } else {
            if (mark != 0 && this.x - mark < 100) {
                this.x += vx * 1.5;
            } else {
                mark = 0;
            }
        }
        if (type == Enemy.TYPE_STATIC_WTIH_ATACK || type == Enemy.TYPE_FLYING_WTIH_ATACK) {
            if (getTimer() - tmpTime >= 4000) {
                bullet = new Bullet();
                bullet.setParametrs(0, 0, 10, 10, 1);
                tmpTime = getTimer();
                this.addChild(bullet);
                tmpArray.push(bullet);
            }
        }
        for each (var t:Bullet in tmpArray) {
            if (t.getCurrLife() <= 0) {
                this.removeChild(t);
                tmpArray.splice(tmpArray.indexOf(t), 1);
            } else {
                t.x -= 3;
                t.y = +.04 * Math.pow(t.x, 2) + 3 * t.x;
            }
        }
    }

    public function getType():int {
        return type;
    }

    public function getCurrLife():int {
        return life;
    }

    public function checkCollision(t:MovieClip):Boolean {
        lastHitedEnemy = false;
//        if(type != Enemy.TYPE_STATIC) {
        for (var i:int = tmpArray.length - 1; i >= 0; i--) {
            if (t.hitTestObject(tmpArray[i])) {
                tmpArray[i].reduceLife();
//                    this.removeChild(tmpArray[i]);
//                    tmpArray.slice(i, 1);
                trace("hit bullet")
                return true;
            }
        }
        lastHitedEnemy = t.hitTestObject(enemyDebug.p);
        return t.hitTestObject(enemyDebug.p);
//        }else {
//            return this.hitTestObject(t);
//        }
//        return false;
    }

    public function resetEnemy():void {
        if (tmpArray != null)
            for (var i:int = tmpArray.length - 1; i >= 0; i--) {
                this.removeChild(tmpArray[i]);
                tmpArray[i].splice(i, 1);
            }
        tmpArray = [];
    }

    public function playDestroy() : void {
        //TODO if временный
        if (enemyDebug.i != null) {
            enemyDebug.i.gotoAndStop(2);
            enemyDebug.i.q.play();

        }
    }
}
}
