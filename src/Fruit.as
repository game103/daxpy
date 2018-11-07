package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Fruit extends MovieClip {
		private var fruitType:Number;
		private var dropFrames:Number;
		private var spoilFrames:Number;
		private var flipDirection = false;
		private var dropStop = false;
		private var dropVelocity = 1;
		private var initialSpoil:Number;
		private var initialDrop:Number;
		private var daxpy:Daxpy;

		public function Fruit(fruitType:Number, dropFrames:Number, spoilFrames:Number, daxpy:Daxpy) {
			this.fruitType = fruitType + 1;
			// set the drop and spoil rate with some randomness
			this.dropFrames = dropFrames + Math.round((Math.random() * dropFrames/4 - dropFrames/8));
			this.spoilFrames = spoilFrames + Math.round((Math.random() * spoilFrames/4 - spoilFrames/8));
			this.initialDrop = dropFrames;
			this.initialSpoil = spoilFrames;
			this.daxpy = daxpy;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// function to be called once the tree is added to the stage
		public function init(event:Event) {
			this.gotoAndStop(fruitType);
			this.addEventListener(Event.ENTER_FRAME, exist);
		}
		
		// function for the fruit to exist
		public function exist(event:Event) {
			if(!daxpy.getPaused()) {
				// Destroy oneself once the reset flag has been set on daxpy
				if(this.daxpy.getReset()) {
					this.end();
					return;
				}
				this.alpha = spoilFrames/initialSpoil;
				if(this.spoilFrames <= 0) {
					// Lose the game
					if(!this.daxpy.getLost()) { // This may not be necessary
						this.daxpy.lose();
					}
					this.end();
					return;
				}
				if(this.daxpy.head != null) {
					if(this.hitTestObject(this.daxpy.head)) {
						// add to score based on how quickly the fruit was gotten -> maximum possible -> 100
						var dropBonus = this.dropFrames/this.initialDrop;
						if(dropBonus < 0) {
							dropBonus = 0;
						}
						if(!this.daxpy.getLost()) {
							this.daxpy.addToScore( Math.round((dropBonus + this.spoilFrames/this.initialSpoil) * 50) );
							if(!daxpy.getMute()) {
								var bite = new Bite();
								bite.play();
							}
						}
						this.end();
					}
				}
				if(!dropStop) {
					if(this.y >= 225) {
						// Make sure that the fruit has passed over the bounce line again
						if(!flipDirection) {
							// flip velocity and cut it by at minimum divided by 1.25, maximum 1.75
							this.dropVelocity = -this.dropVelocity / (Math.random() * 0.5 + 1.25);
							flipDirection = true;
							// Stop the apple if slow enough
							if(Math.abs(this.dropVelocity) <= 4) {
								this.dropVelocity = 0;
								this.dropStop = true;
							}
						}
					}
					else {
						flipDirection = false;
					}
					if(this.dropFrames <= 0) {
						this.y = this.y + dropVelocity;
						// Fall acceleration rate
						dropVelocity = dropVelocity + 0.5;
					}
				}
				else {
					this.spoilFrames --;
				}
				this.dropFrames --;
			}
		}
		
		public function end() {
			this.removeEventListener(Event.ENTER_FRAME, exist);
			this.parent.removeChild(this);
		}
	}
	
}
