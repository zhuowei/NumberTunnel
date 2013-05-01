package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	[SWF(width="1024", height="600", frameRate="30", backgroundColor="#000000")]
	public class NumberTunnel extends Sprite {

		public const Z_VELOCITY = -128;

		public const START_Z = 0x2fff;

		public var flyingSprites:Array = [];

		public var offscreenSprites:Array = [];

		public var bitmapCache:Array = new Array(2);

		public var framesUntilNextNumbers:int = 0;

		public function NumberTunnel() {
			addEventListener("enterFrame", frameHandler);
			buildBitmapFont();
			addInitSprites();
		}

		public function frameHandler(e:Event):void {
			for (var i:int = flyingSprites.length - 1; i >= 0; --i) {
				var a:DisplayObject = flyingSprites[i];
				a.z += Z_VELOCITY;
				if (a.z <= 0) {
					/*removeChild(a);
					flyingSprites.splice(i, 1);*/
					a.z = START_Z;
				}
			}
			/*if (framesUntilNextNumbers <= 0) {
				spawnSprites(START_Z);
				framesUntilNextNumbers = 2;/*Math.floor(Math.random() * 4)*/;
			/*} else {
				--framesUntilNextNumbers;
			}*/
		}

		public function createNewSprite():DisplayObject {
			var retval:Bitmap = new Bitmap(bitmapCache[Math.random() < 0.5? 0: 1]);
			return retval;
		}

		public function spawnSprites(startZ:Number):void {
			var numberOfSprites:int = Math.floor(Math.random() * 16) + 4;
			var halfStageWidth:int = stage.stageWidth / 2;
			var halfStageHeight:int = stage.stageHeight / 2;
			var radius:Number = Math.sqrt((halfStageWidth * halfStageWidth) + (halfStageHeight * halfStageHeight));
			for (var i:int = 0; i < numberOfSprites; i++) {
				var newSprite:DisplayObject = createNewSprite();
				var angleToPlace:Number = ((i / numberOfSprites) * 2 * Math.PI) + (Math.random() * 0.5);
				var xToPlace:Number = (Math.cos(angleToPlace) * radius) + halfStageWidth;
				var yToPlace:Number = (Math.sin(angleToPlace) * radius) + halfStageHeight;
				newSprite.x = xToPlace;
				newSprite.y = yToPlace;
				newSprite.z = startZ;
				addChild(newSprite);
				flyingSprites.push(newSprite);
			}
		}

		public function addInitSprites():void {
			for (var i:int = START_Z; i >= 0; i -= 384) {
				spawnSprites(i);
			}
		}

		public function buildBitmapFont():void {
			for (var i:int = 0; i < 2; i++) {
				var bitmapData:BitmapData = new BitmapData(64, 64, false, 0);
				var retval:TextField = new TextField();
				retval.defaultTextFormat = new TextFormat("_typewriter", 64, 0xffffff);
				retval.text = i.toString();
                                retval.background = false;
				retval.cacheAsBitmap = true;
				retval.height = retval.width = 64;
				bitmapData.draw(retval);
				bitmapCache[i] = bitmapData;
			}
		}

	}
}

