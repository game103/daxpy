package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Tree extends MovieClip {
		private var growFrames;
		private var dropFrames;
		private var spoilFrames;
		//private static const fallFrames = 50;
		private var fruitType = 0;
		private var growWait;
		private var daxpy;

		public function Tree() {
			//addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// Set the type of fruit to use for this tree
		public function setFruit(fruitType:Number) {
			this.fruitType = fruitType;
		}
		
		// Set Daxpy
		public function setDaxpy(daxpy:Daxpy) {
			this.daxpy = daxpy;
		}
		
		// function to be called once the tree is added to the stage
		public function init() {
			growWait = 0;
			growFrames = 120;
			dropFrames = 120;
			spoilFrames = 120;
			this.addEventListener(Event.ENTER_FRAME, exist);
		}
		
		// function to go on throughout the trees life
		public function exist(event:Event) {
			if(!daxpy.getPaused()) {
				if(growWait <= 0) {
					var fruitY = 50;
					var fruitX = Math.random() * 233 + 15;
					var fruit = new Fruit(this.fruitType, dropFrames, spoilFrames, daxpy);
					this.addChild(fruit);
					fruit.x = fruitX;
					fruit.y = fruitY;
					// decrease the amount of time the user has
					if(this.growFrames > 50) {
						this.growFrames -= Math.round(Math.random() * 4);
					}
					if(this.dropFrames > 50) {
						this.dropFrames -= Math.round(Math.random() * 4);
					}
					if(this.spoilFrames > 50) {
						this.spoilFrames -= Math.round(Math.random() * 4);
					}
					// set the new grow wait with some randomness
					growWait = growFrames + Math.round((Math.random() * growFrames/4 - growFrames/8));
				}
				growWait --;
			}
		}
		
		// function to end
		public function end() {
			this.removeEventListener(Event.ENTER_FRAME, exist);
		}
	}
	
}
