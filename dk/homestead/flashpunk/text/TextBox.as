package dk.homestead.flashpunk.text 
{
	import adobe.utils.CustomActions;
	import dk.homestead.utils.Data;
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
		 * 			 with non-monospaced fonts.
		 * Monospaced fonts will have almost identical results with both - thus,
		 * LB_APPROX is recommended for them, and basically not recommended at
		 * all for anything else. In the worst case, using LB_APPROX will get
		 * you less than 50% usage of the max width.
		 */
		public var LinebreakMode:int;
		
		/**
		 * Format applied to the text of the object. Won't proxy the internal textfield as much
		 * as it will actually clone it.
		 */
		public var Format:TextFormat;
		
		override public function set size(value:uint):void
		{
			WrapText(text, value, LinebreakMode);
			super.size = value;
		}
		
		/**
		 * Creates a new text box. Defaults to using exact linebreaking as Flashpunk's default font is not monospaced.
		 * @param	text	The text to be in the box.
		 * @param	maxWidth	Maximum width (pixels) of the text area. If omitted, a single line (default Text behaviour) is performed.
		 * @param	mode	The line-breaking mode to utilize (see LB_EXACT and LB_APPROX).
		 */
		public function TextBox(text:String, maxWidth:int = 0, tSize:uint = 0, textFont:String = "default", mode:int = 0) 
		{
			trace("Creating new textbox.");
			
			/**
			 * Set a size.
			 */
			if (!tSize) tSize = Text.size;
			
			/**
			 * Set the max width.
			 */
			MaxWidth = maxWidth;
			
			/**
			 * Set the correct linebreaking mode.
			 */
			LinebreakMode = mode;
			
			/**
			 * We need to infer a height before calling the super... fuck.
			 */
			var t:String = WrapText(text, tSize, LinebreakMode);
			
			var pSize:uint = Text.size;
			Text.size = tSize;
			super(t, 0, 0, maxWidth, Data.CountStrings(text, "\n") * tSize);
			Text.size = pSize;
		}
		
		/**
		 * Parses an input string according to width and line-breaking mode.
		 * @param	input	The string to parse. Any pre-rolled line-breaks will be removed.
		 * @param	s		Font size to calculate with. We cannot change width/height after construction easily.	
		 * @param	mode	The optionally different linebreak mode to use. Defaults to the current instance choice.
		 * @return	The parsed string with new linebreaks.
		 */
		protected function WrapText(input:String, s:uint, mode:int = -1):String
		{
			trace("Wrapping textbox contents '" + input + "' (length " + input.length + ").");
			
			// If it's an empty input or everything can be on one maxed line, then return it as-is.
			if (input == "" || input.length * s < MaxWidth) return input;
			
			// If mode omitted, set it to the currently set.
			if (mode == -1) mode = LinebreakMode;
			
			// Always start by attempting an unwrap, just in case.
			// input = UnwrapText(input);
			
			// Reset the newlines vector after unwrap.
			Newlines = new Vector.<int>();
			
			// This is where we place the final output.
			var output:String = "";
			
			/**
			 * Counts the distance between previous newline character. This is the value
			 * we insert into the NewLines vector.
			 */
			var indexCounter:int = 0;
			
			if (mode == LB_APPROX)
			{
				output = _wrapApprox(input, s);
			}
			else if (mode == LB_EXACT)
			{
				output = _wrapExact(input, s);
			}
			
			trace("Final output:\n" + output);
			
			return output;
		}
		
		/**
		 * Approximate wrapping function.
		 * @param	input	The string to parse. Any pre-rolled line-breaks will be removed.
		 * @param	s		Font size to calculate with. We cannot change width/height after construction easily.
		 * @return	The parsed string with new linebreaks.
		 */
		private function _wrapExact(input:String, s:uint):String
		{
			// Temp string we use for all our transactions.
			var curString:String = "";
			
			// The exact method uses a real flash text field to measure text width real-time.
			var tf:TextField = new TextField();
			tf.setTextFormat(new TextFormat(font, size, color));
			
			// Max character count.
			var maxChars:int = Math.floor(MaxWidth / s);
			// Highest number of calculated rows. Approximation method used during dev'ing.
			var itmax:int = Math.floor(input.length / maxChars);
			// Final output string.
			var output:String = "";
			
			for (var i:int = 0; i < itmax; i++)
			{
				// Retrieve our assumption of a proper row and remove the final word to make it whole.
				curString =  _removeLastWord(input.substring(0, maxChars));
				
				trace("Extract: " + curString);
				
				if (_widthOfString(curString) <= MaxWidth) // If the content is smaller than allowed
				{
					trace("Text is within margin.");
					while (_widthOfString(curString) < MaxWidth)
					{
						curString += " " + _getFirstWord(input);
					}
				}
				else // If it is larger, however, remove words until it fits. This is an unlikely scenario.
				{
					trace("Text is outside margin. Reducing.");
					while (_widthOfString(curString) >= MaxWidth)
					{
						var word:String = _removeFirstWord(input);
						curString = word;
						input = input.substring(
					}
				}
				output += curString + "\n";
				addIndex(output.length);
				
				trace("Final: " + curString);
				
				input = input.substr(curString.length);
				trace("Remaing: " + input);
			}
			
			return output;
		}
		
		/**
		 * Approximate wrapping function.
		 * @param	input	The string to parse. Any pre-rolled line-breaks will be removed.
		 * @param	s		Font size to calculate with. We cannot change width/height after construction easily.
		 * @return	The parsed string with new linebreaks.
		 */
		private function _wrapApprox(input:String, s:uint):String
		{
			// Temp string we use for all our transactions.
			var curString:String = "";
			
			trace("APPROX: " + input.length.toString() + " characters in input. Accomodating about " + (MaxWidth / s).toString() + " characters per line.");
			while (input.length * s > MaxWidth)
			{
				/* Will give us the estimated current line. We know that the font s under
				 * all circumstances denotes the *largest* pixel s of a character, so using
				 * this method will never give us a string that is longer than the max width.
				 * Our only concern is to make sure we did not break up a word.
				 */
				var w:int = Math.floor(MaxWidth / s);
				trace(w + " characters taken in.");
				curString = input.substring(0, w);
				trace("Evaluating '" + curString + "'.");
				var indexCounter:uint = 0;
				var output:String = "";
				
				var flag:uint = 0;
				if (curString.lastIndexOf(" ") == curString.length - 1)
				{
					/**
					 * Scenario 1: the final character is indeed a whitespace.
					 * Perfect!
					 **/
					trace("Final character is whitespace. Success!");
					flag = 1; // Flag to remove that stupid whitespace.
				}
				else
				{
					/**
					 * Scenario 2: anything else.
					 * Not as perfect, but easily remedied.
					 */
					// Now correctly reduce curString to all whole words less than the max width.
					curString = _removeLastWord(input);
					flag = 2; // Flag to remove the first whitespace of input.
				}
				
				// Tracks newest index.
				indexCounter += curString.length;
				// Adds the newline index to the archive.
				Newlines.push(indexCounter);
				
				trace("Evaluated to '" + curString + "'.");
				input = input.substring(curString.length);
				
				if (flag == 1)
				{
					curString = curString.substring(0, curString.length - 1);
				}
				else if (flag == 2)
				{
					input = input.substring(1);
				}
				
				output += curString + "\n";
				
				trace("Reduced input to '" + input + "'.");
			}
			
			// Add the final text.
			output += input;
			
			return output;
		}
		
		/**
		 * Adds a newline indice to the vector. Mostly a helper function, but it may have its uses.
		 * @param	i	The index to add. Will not be checked for duplicates.
		 */
		protected function addIndex(i:int):void
		{
			Newlines.push(i);
		}
		
		/**
		 * Helper function. Removes anything after the last whitespace of a string, 
		 * including said whitespace.
		 * @param	input	The string to reduce.
		 * @return	The same string, final word removed.
		 */
		private function _removeLastWord(input:String):String
		{
			if (input == "") return input; // Null strings.
			else return input.substring(0, input.lastIndexOf(" "));
		}
		
		private function _removeFirstWord(input:String):String
		{
			// With null strings and no whitespaces, we just return it.
			if (input == "" || _trim(input).indexOf(" ") == -1) return input;
			else return input.substr(0, input.indexOf(" "));
		}
		
		private function _getFirstWord(fromString:String):String
		{
			fromString = _trim(fromString);
			return fromString.substring(0, fromString.indexOf(" "));
		}
		
		/**
		 * Retrieves the next word, starting from a base string and working with the full string.
		 * @param	baseString	The base string (that contains all words up to the one we're seeking).
		 * @param	fromString	The complete string we want to retrieve the next word from.
		 * @return	The next word in the series.
		 */
		private function _getNextWord(baseString:String, fromString:String):String
		{
			// Trim both string.
			baseString = _trim(baseString);
			fromString = _trim(fromString);
			this is where you noeed to continue your work. Finish the method and return to _wrapExact
			return _getFirstWord(fromString.substring(baesString.length
		}
		
		/**
		 * Removes any leading or following whitespaces.
		 * @param	input	The string to trim.
		 * @return	The new string, any first of last whitespaces removed.
		 */
		private function _trim(input:String):String
		{
			if (input.indexOf(" ") == 0) input = input.substr(1);
			if (input.lastIndexOf(" ") == input.length - 1) input = input.substr(0, input.length - 1);
			return input;
		}
		
		/**
		 * Calculates the pixel width of a string given a certain font type and size.
		 * @param	input	The string to calculate width of.
		 * @param	f		The font to calculate with. Uses instance if omitted.
		 * @param	s		The size to calculate with.	Uses instance if omitted.
		 * @return
		 */
		private function _widthOfString(input:String, f:String = "", s:uint = 0):uint
		{
			if (!f) f = font;
			if (!s) s = size;
			
			var tf:TextField = new TextField();
			tf.setTextFormat(new TextFormat(f, s));
			tf.text = input;
			return tf.textWidth;
		}
		
		/**
		 * Unwraps text based on the newlines recorded in this.Newlines.
		 * @param	input	The string to unwrap.
		 * @return	Returns the unwrapped text (with original newlines intact).
		 */
		protected function UnwrapText(input:String):String
		{
			if (input == "") return input;
			
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
	}
}