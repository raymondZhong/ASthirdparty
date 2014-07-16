package feathers.examples.helloWorld
{
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.Radio;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.data.ListCollection;
	import feathers.themes.AeonDesktopTheme;
	import feathers.themes.MetalWorksMobileTheme;
	import flash.utils.setTimeout;
	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import zebra.graphics.bitmaps.TilesEffect;

	/**
	 * An example to help you get started with Feathers. Creates a "theme" and
	 * displays a Button component that you can trigger.
	 *
	 * <p>Note: This example requires the MetalWorksMobileTheme, which is one of
	 * the themes included with Feathers.</p>
	 *
	 * @see http://wiki.starling-framework.org/feathers/getting-started
	 */
	public class Main extends Sprite
	{
		/**
		 * Constructor.
		 */
		public function Main()
		{
			//we'll initialize things after we've been added to the stage
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		/**
		 * A Feathers theme will automatically pass skins to any components that
		 * are added to the stage. Components do not have default skins, so you
		 * must always use a theme or skin the components manually.
		 *
		 * @see http://wiki.starling-framework.org/feathers/themes
		 */
		protected var theme:MetalWorksMobileTheme;
		//protected var theme:AeonDesktopTheme;

		/**
		 * The Feathers Button control that we'll be creating.
		 */
		protected var button:Button;

		/**
		 * Where the magic happens. Start after the main class has been added
		 * to the stage so that we can access the stage property.
		 */
		
		
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			//create the theme. this class will automatically pass skins to any
			//Feathers component that is added to the stage. you should always
			//create a theme immediately when your app starts up to ensure that
			//all components are properly skinned.
			//this.theme = new AeonDesktopTheme(this.stage);
			this.theme = new MetalWorksMobileTheme(this.stage);
			//this.theme.setInitializerForClass(Button,
			
			//create a button and give it some text to display.
			this.button = new Button();
			this.button.label = "点击";

			//an event that tells us when the user has tapped the button.
			this.button.addEventListener(Event.TRIGGERED, button_triggeredHandler);

			//add the button to the display list, just like you would with any
			//other Starling display object. this is where the theme give some
			//skins to the button.
			 this.addChild(this.button);

			//the button won't have a width and height until it "validates". it
			//will validate on its own before the next frame is rendered by
			//Starling, but we want to access the dimension immediately, so tell
			//it to validate right now.
			this.button.validate();

			//center the button
			this.button.x = (this.stage.stageWidth - this.button.width) / 2;
			this.button.y = (this.stage.stageHeight - this.button.height) / 2;
			
		
			label.text = "中国人Hi, I'm Feathers!\nHave a nice day.";
		 	Callout.show(label, this.button);
			setTimeout(function():void { 
				// Callout.show(null, button);
				}, 3000);
				
			 var  cc:ToggleSwitch = new ToggleSwitch();
				  cc.onText = "成功";
				  cc.offText = "失败";
			 addChild(cc);
			 
			 
		 	var b1:Button = new Button();
				b1.label = "左边按钮";
			
			var b2:Button = new Button();
			 	b2.label = "222222222222222222";
				
			var b3:Button = new Button();
			 	b3.label = "33333333333333333333";	 
				
				
			var label2:Label = new Label()
				label2.text = "xxxxxxxxxxxxxx";
				label2.y = 100;
				addChild(label2)
				
				
				
				
				trace("Button:",this.button.width,this.button.height,this.scaleX,this.scaleY)
			
				setTimeout(function():void{
				button.width = 50;
				button.height = 50;
				trace("Button:", button.width, button.height, scaleX, scaleY)
				
				
				trace("Label:",label2.width,label2.height)
				
				},3000);
				
			//var navigator:ScreenNavigator = new ScreenNavigator();
			//navigator.addScreen("mainMenu1", new ScreenNavigatorItem(b1));
			//navigator.addScreen("mainMenu2", new ScreenNavigatorItem(b2));
			//navigator.addScreen("mainMenu3", new ScreenNavigatorItem(b3));
			//this.addChild(navigator);
			//
			//navigator.showScreen("mainMenu1");
			 //
			 //
			//var t:TilesEffect = new TilesEffect(navigator);
				//t.onTransition(b1, b2, xxxx);
			
				var header:Header = new Header();
					header.title = "Settings";
					this.addChild( header );
					
					
					header.leftItems = new <DisplayObject>[b1]
					
			 
			 //var t:TextArea = new TextArea();
			 //t.width = 300;
			 //t.height = 100; 
			 //
			 //addChild(t)
			 //
			 
			 //var  tt:TextFieldTextEditor  = new TextFieldTextEditor()
			 //tt.width = 300;
			 //tt.height = 500;
			 //tt.isEditable = true;
			 //tt.text="adsfasdfasfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjadsfasdfasfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjadsfasdfasfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjadsfasdfasfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjadsfasdfasfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjadsfasdfasfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjadsfasdfasfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjadsfasdfasfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjadsfasdfasf\njjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"
			 //addChild(tt)
			 
		
			 
		}
		
		private function xxxx():void 
		{
			
		}

		
		protected var label:Label = new Label();
		/**
		 * Listener for the Button's Event.TRIGGERED event.
		 */
		protected function button_triggeredHandler(event:Event):void
		{
			
				label.text = "1234567890";
			Callout.show(label, this.button);
		}
	}
}
