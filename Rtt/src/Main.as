package {
import flash.display.MovieClip;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

import flashdynamix.utils.SWFProfiler;

//
// Run through time.
//
[SWF(height="400", width="640", frameRate="30", backgroundColor="#DBD9B5")]
public class Main extends MovieClip {
    private var _gameScreen:Game = new Game();

    public function Main() {
        if (stage) init();
        else addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        //загрузка xml
        addXmlInfo();
    }

    private function setup():void {
        SWFProfiler.init(stage, this);
//        stage.scaleMode = StageScaleMode.NO_SCALE;
        //убирает все за экраном
//        var mask_mc:Sprite = new Sprite();
//        mask_mc.graphics.beginFill(0xFFFFFF, 1);
//        mask_mc.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
//        mask_mc.graphics.endFill();
//        stage.addChild(mask_mc);
//        this.mask = mask_mc;
        this.addChild(_gameScreen);
        this.addEventListener(Event.ENTER_FRAME, update);
    }

    private function update(e:Event):void {
        _gameScreen.update(e);
    }

    private var loader:URLLoader = new URLLoader();

    private function addXmlInfo():void {
//        loader.load(new URLRequest("//Users/user/Documents/_develop/_flash/Rtt/src/xml/config.xml"));
        loader.load(new URLRequest("//Users/user/Documents/_develop/_flash/rtt_editor/out/config.xml"));
        loader.addEventListener(Event.COMPLETE, onLoadXML);
    }

    private function onLoadXML(e:Event):void {
        var myxml:XML = XML(e.target.data);
        var i:int = 0;
        var j:int;
        var vd:Vector.<Vector.<Vector.<int>>> = new Vector.<Vector.<Vector.<int>>>();
        while (myxml.num[i] != null) {
            j = 0;
            vd[i] = new Vector.<Vector.<int>>();
            while (myxml.num[i].block[j] != null) {
                vd[i][j] = new <int>[int(myxml.num[i].block[j].xPos), int(myxml.num[i].block[j].yPos), int(myxml.num[i].block[j].blockType), int(myxml.num[i].block[j].blockTypeDop), int(myxml.num[i].block[j].enmType), int(myxml.num[i].block[j].w), int(myxml.num[i].block[j].h), int(myxml.num[i].block[j].coinType)];
                j++;
            }
            i++;
        }
        Global._vecLvl = vd;
        setup();
    }
}
}


