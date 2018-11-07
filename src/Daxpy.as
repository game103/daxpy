package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	//private static constant UP_SECONDS = 5;
	
	public class Daxpy extends MovieClip {
		private static const UP_FRAMES = 100;
		private static const DOWN_FRAMES = 160;
		private static const RECHARGE_AMOUNT_PER_FRAME = UP_FRAMES/DOWN_FRAMES;
		private static const MOVE_AMOUNT = 6;
		
		private var moveLeft;
		private var moveRight;
		private var dinoState = 1; // down = 0, normal = 1, up = 2
		private var framesUp = UP_FRAMES;
		
		private var trees:Array;
		
		private var score;
		
		private var initialWidth = 191.3;
		
		private var lost = true;
		private var resetTime;
		
		private var gamePaused = false;
		private var canPause = true;
		private var mute = false;

		// Constructor
		public function Daxpy() {
			//this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// function to be called once Daxpy is added to the stage
		public function init(trees:Array) {
			this.score = 0;
			this.framesUp = UP_FRAMES;
			this.dinoState = 1;
			this.x = 179.5;
			this.scaleX = 1;
			this.gotoAndStop(1);
			this.lost = false;
			this.resetTime = false;
			this.trees = trees;
			this.moveLeft = false;
			this.moveRight = false;
			this.gamePaused = false;
			this.canPause = true;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			this.addEventListener(Event.ENTER_FRAME, exist);
			for(var i:Number = 0; i < this.trees.length; i++) {
				this.trees[i].init();
			}
		}
		
		// function to set the trees that Daxpy interacts with
		public function setTrees(trees:Array) {
			this.trees = trees;
		}
		
		// function to exist while Daxpy is on frame
		public function exist(event:Event) {
			if(!getPaused()) {
				if(moveLeft) {
					this.x -= MOVE_AMOUNT;
					if(this.x < -this.initialWidth) {
						this.x = 550;
					}
				}
				else if(moveRight) {
					this.x += MOVE_AMOUNT;
					if(this.x > 550 + this.initialWidth) {
						this.x = 0;
					}
				}
				if(!moveLeft && !moveRight) {
					this.stop();
				}
				else{
					this.play();
				}
				if(this.dinoState == 2) {
					this.framesUp -= 1;
					if(this.framesUp <= 0) {
						changeState(-1);
					}
				}
				else if(this.framesUp < UP_FRAMES) {
					if(this.framesUp + RECHARGE_AMOUNT_PER_FRAME < UP_FRAMES) {
						this.framesUp += RECHARGE_AMOUNT_PER_FRAME;
					}
					else {
						this.framesUp = UP_FRAMES;
					}
				}
			}
		}
		
		// function to respond to key down events
		public function keyDownHandler(event:KeyboardEvent) {
			if(!getPaused()) {
				if(event.keyCode == Keyboard.LEFT) {
					if(this.scaleX == -1) {
						this.scaleX = 1;
						this.x -= this.width;
					}
					moveRight = false;
					moveLeft = true;
				}
				else if(event.keyCode == Keyboard.RIGHT) {
					if(this.scaleX == 1) {
						this.scaleX = -1;
						this.x += this.width;
					}
					moveLeft = false;
					moveRight = true;
				}
				else if(event.keyCode == Keyboard.UP) {
					changeState(1);
				}
				else if(event.keyCode == Keyboard.DOWN) {
					changeState(-1);
				}
			}
			if(event.keyCode == 80) {
				if(canPause) {
					this.togglePause();
					canPause = false;
				}
			}
		}
		
		// function to respond to key up events
		public function keyUpHandler(event:KeyboardEvent) {
			if(event.keyCode == Keyboard.LEFT) {
				moveLeft = false;
			}
			else if(event.keyCode == Keyboard.RIGHT) {
				moveRight = false;
			}
			if(event.keyCode == 80) {
				canPause = true;
			}
		}
		
		// function to change the state of Daxpy
		public function changeState(changeDir:Number) {
			var prevState = dinoState;
			if(changeDir > 0) {
				if(dinoState + changeDir >= 2) {
					// You must be able to go up
					if(framesUp > 0) {
						dinoState = 2;
					}
				}
				else {
					// This should always be 1 for now at least...
					dinoState = dinoState + changeDir;
				}
			}
			else {
				if(dinoState + changeDir <= 0) {
					dinoState = 0;
				}
				else {
					dinoState = dinoState + changeDir;
				}
			}
			updateState(prevState);
		}
		
		// function to update the visual state of Daxpy
		public function updateState(prevState:Number) {
			var framesChange = 17 * (dinoState - prevState);
			if(moveLeft || moveRight) {
				this.gotoAndPlay(this.currentFrame + framesChange);
			}
			else {
				this.gotoAndStop(this.currentFrame + framesChange);
			}
		}
		
		// get the number of frames up
		public function getFramesUp():Number {
			return this.framesUp;
		}
		
		// function to get score
		public function getScore():Number {
			return this.score;
		}
		
		// function to set score
		public function setScore(score:Number) {
			this.score = score;
		}
		
		// function to increase score
		public function addToScore(score:Number) {
			this.score += score;
		}
		
		// function to lose()
		public function lose() {
			this.end();
		}
		
		public function getLost():Boolean {
			return this.lost;
		}
		
		public function getReset():Boolean {
			return this.resetTime;
		}
		
		public function togglePause() {
			if(this.gamePaused) {
				this.gamePaused = false;
			}
			else {
				this.gamePaused = true;
				this.stop();
			}
		}
		
		public function getPaused():Boolean {
			return this.gamePaused;
		}
		
		public function getMute():Boolean {
			return this.mute;
		}
		
		public function setMute(mute:Boolean) {
			this.mute = mute;
		}
		
		// function to end
		// This will stop the exist functions for this and the trees
		public function end() {
			this.stop();
			for(var i:Number = 0; i < this.trees.length; i++) {
				this.trees[i].end();
			}
			this.removeEventListener(Event.ENTER_FRAME, exist);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			// The lost flag is solely for the overall stage to know when to show lost
			lost = true;
			// just to ensure
			this.gamePaused = false;
		}
		
		// function to reset
		public function resetGame() {
			// Note that the Fruit is waiting for this
			this.resetTime = true;
			// wait for the all the fruit to be gone
			this.addEventListener(Event.ENTER_FRAME, waitReset);
		}
		
		// function to wait to reset until all the fruit is gone
		function waitReset(event:Event) {
			var count = 0;
			for(var i:Number = 0; i < this.trees.length; i++) {
				if(this.trees[i].numChildren <= 1) {
					count ++;
					if(count == this.trees.length) {
						this.removeEventListener(Event.ENTER_FRAME, waitReset);
						this.init(this.trees);
					}
				}
			}
		}

	}
	
}
