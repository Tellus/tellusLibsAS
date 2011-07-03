package utils 
{
	import org.flixel.*;
	
	/**
	 * Static class with drawing functions the I was redoing everywhere anyway.
	 * @author Johannes
	 */
	public class Draw
	{	
		public function Draw(){}
	
		public static function drawFrame(sprite:FlxSprite, color:uint = 0xFF000000):void
		{
			sprite.drawLine(0, 0, sprite.width - 1, 0, color);
			sprite.drawLine(0, 0, 0, sprite.height - 1, color);
			sprite.drawLine(sprite.width - 1, sprite.height - 1, 0, sprite.height - 1, color);
			sprite.drawLine(sprite.width - 1, sprite.height - 1, sprite.width - 1, 0, color);
		}
	}	
}