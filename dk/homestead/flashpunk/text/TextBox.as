package dk.homestead.flashpunk.text 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	
	/**
	 * The TextBox graphic is a Text derivative that supports automatic line breaking
	 * without ruining words. Hyphenation is not performed.
	 * @author Johannes L. Borresen
	 */
	public class TextBox extends Text
	{
		/**
		 * Indicates exact line-breaking mode.
		 */
		public static const LB_EXACT:int = 0;
		
		/**
		 * Indicates approximating line-breaking mode.
		 */
		public static const LB_APPROX:int = 1;
		
		/**
		 * List of newlines that the parsing function has entered.
		 */
		protected var Newlines:Vector.<int>;
		
		/**
		 * Maximum width in pixels. This is used as a limiter when wrapping text.
		 * @default 0
		 */
		public var MaxWidth:int = 0;
		
		/**
		 * The type of line-breaking to perform on the text.
		 * LB_EXACT is more pixel-perfect but can be more resource consuming.
		 * LB_APPROX is slightly faster but is quite markedly worse in quality
		 * 			with non-monospaced fonts.
		 * Monospaced fonts will have almost identical results with both - thus,
		 * LB_APPROX is recommended for them.
		 */
		public var LinebreakMode:int;
		
		public var 
		
		/**
		 * Creates a new text box.
		 * @param	text	The text to be in the box.
		 * @param	maxWidth	Maximum width (pixels) of the text area. If omitted, a single line (default Text behaviour) is performed.
		 * @param	mode	The line-breaking mode to utilize (see LB_EXACT and LB_APPROX).
		 */
		public function TextBox(text:String, maxWidth:int = 0, mode:int = 1) 
		{
			super(text, 0, 0, maxWidth);
			
			
		}
		
		/**
		 * Parses an input string according to width and line-breaking mode.
		 * @param	input	The string to parse. Any pre-rolled line-breaks will be removed.
		 * @param	mode	The optionally different linebreak mode to use. Defaults to the current instance choice.
		 * @return	The parsed string with new linebreaks.
		 */
		protected function WrapText(input:String, mode:int = -1):String
		{
			// input = UnwrapText(input);
			
			var tf:TextField = new TextField();
			tf.embedFonts = true;
			tf.defaultTextFormat = new TextFormat(font, size, 
			
			return input;
		}
		
		/**
		 * Unwraps text based on the newlines recorded in this.Newlines.
		 * @param	input	The string to unwrap.
		 * @return	Returns the unwrapped text (with original newlines intact).
		 */
		protected function UnwrapText(input:String):String
		{
			// Make sure to sort the newlines so we start with the last newline. This makes it easier
			// to avoid indexing mistakes.
			trace("Shifting newlines: " + Newlines.toString());
			Newlines.sort(function(i1:int, i2:int):int { if (i1 > i2) return 1;
													 else if (i1 < i2) return -1;
													 else return 0;
													})
			trace("Shifted newlines: " + Newlines.toString());
			for (var i:int = 0; i < Newlines.length; i++)
			{
				
			}
			
			return input;
		}
		
		/**
		 * Deletes the last word from a string and returns the resulting substring.
		 * @param	input	A string where the last word (characters after final whitespace) is removed.
		 * @return	A string without the last word.
		 */
		protected function DeleteWord(input:String):String
		{
			return input.substr(0, input.lastIndexOf(" "));
		}
	}
}