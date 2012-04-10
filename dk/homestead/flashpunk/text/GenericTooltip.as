package dk.homestead.flashpunk.text 
{
	import dk.homestead.flashpunk.groups.*;
	import flash.events.ActivityEvent;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	/**
	 * The (true) generic tooltip class. Uses the base EntityGroup class
	 * since it requires no automatic placement of contents, only constant
	 * relational positioning.
	 * Important! Anchors have yet to be implemented. I need something elegant.
	 * Important! The class does not have any pretty line breaks just yet. I'm
	 * looking into acceptable solutions at the very least for the non-monospaced
	 * default font for Flashpunk.
	 * @author Johannes L. Borresen
	 */
	public class GenericTooltip extends EntityGroup 
	{
		[Embed(source = '../../../../../defragged/img/fonts/arcade.TTF', embedAsCFF="false", fontFamily = 'MONOTYPE_FONT')] public static const MONOTYPE_FONT:Class;
		
		public var Title:String;
		
		public var Content:String;
		
		public var TitleText:Entity;
		
		public var ContentText:Entity;
		
		public var Background:Entity;
		
		/**
		 * Padding between Title and Content.
		 */
		public var VerticalPadding:int;
		
		/**
		 * Currently active anchor type.
		 */
		public var MouseAnchor:int = ANCHOR_TOPLEFT;
		
		/**
		 * Anchor, top-left.
		 */
		public static const ANCHOR_TOPLEFT:int = 0;
		/**
		 * Anchor, top-center.
		 */
		public static const ANCHOR_TOP:int = 1;
		/**
		 * Anchor, top-right.
		 */
		public static const ANCHOR_TOPRIGHT:int = 2;
		/**
		 * Anchor, left-center.
		 */
		public static const ANCHOR_LEFT:int = 3;
		/**
		 * Anchor, bottom-left.
		 */
		public static const ANCHOR_BOTTOMLEFT:int = 4;
		/**
		 * Anchor, bottom-center.
		 */
		public static const ANCHOR_BOTTOM:int = 5;
		/**
		 * Anchor, bottom-right.
		 */
		public static const ANCHOR_BOTTOMRIGHT:int = 6;
		/**
		 * Anchor, right-center.
		 */
		public static const ANCHOR_RIGHT:int = 7;
		/**
		 * Anchor, center.
		 */
		public static const ANCHOR_CENTER:int = 8;
		
		public function GenericTooltip(title:String, content:String, w:int = 0, bg:* = null) 
		{
			super(w);
			
			Title = title;
			Content = content;
			
			MoveFactorX = MoveFactorY = 1.0;
			
			_createTitle();
			_createContent();
			
			setHitbox(w, ContentText.height + TitleText.height);
			
			_createBackground(bg);
			
			MoveToBottom(Background);
			//MoveToTop(ContentText);
			//MoveToTop(TitleText);
			
			UpdateEntityLocations();
		}
		
		private function _createTitle():void
		{
			// TitleText = new Entity(0, 0, new Text(Title, 0, 0, width));
			TitleText = new Entity(0, 0, new TextBox(Title, width, 12));
			var t:TextBox = TitleText.graphic as TextBox;
			// t.font = "MONOTYPE_FONT";
			TitleText.setHitbox(t.width, t.height);
			add(TitleText);
		}
		
		private function _createContent():void
		{
			// ContentText = new Entity(0, 0, new Text(Content, 0, 0, width));
			ContentText = new Entity(0, 0, new TextBox(Content, width, 11));
			var t:TextBox = ContentText.graphic as TextBox;
			// t.font = "MONOTYPE_FONT";
			ContentText.setHitbox(t.width, t.height);
			add(ContentText);
			
			trace("Final content:\n" + (ContentText.graphic as Text).text);
		}
		
		private function _createBackground(bg:*):void
		{
			var e:Entity;
			if (bg == null)
			{
				e = new Entity(0, 0, new Canvas(width, height));
				(e.graphic as Canvas).fill(new Rectangle(0, 0, width, height), 0, 0.5);
			}
			else if (bg is Class)
			{
				// Assume image, create.
				e = new Entity(0, 0, new Image(bg));
			}
			else if (bg is Entity)
			{
				// Plain add.
				e = bg;
			}
			else
			{
				// Something bad.
				throw new Error("Invalid background data passed.");
			}
			add(e);
			Background = e;
		}
		
		/**
		 * Shows the tooltip, makes it visible.
		 */
		public function Show():void
		{
			visible = true;
			UpdateTooltipLocation();
		}
		
		/**
		 * Hides the tooltip, makes it... UN-visible!!!
		 */
		public function Hide():void
		{
			visible = false;
			UpdateTooltipLocation();
		}
		
		override public function update():void 
		{
			super.update();
			
			if (visible)
			{
				UpdateTooltipLocation();
			}
		}
		
		/**
		 * Repositions the entities to one another per specification.
		 */
		protected function UpdateEntityLocations():void
		{
			TitleText.x = x;
			TitleText.y = y;
			ContentText.x = x;
			ContentText.y = y + TitleText.height + VerticalPadding;
		}
		
		public function UpdateTooltipLocation():void
		{
			x = Input.mouseX;
			y = Input.mouseY;
		}
	}
}