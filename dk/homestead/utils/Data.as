package dk.homestead.utils 
{
	/**
	 * Static class with various data manipulation functions. They have a good use for 
	 * @author Johannes
	 */
	public final class Data
	{	
		public function Data() { }
		
		/**
		 * Creates an array of size <code>numSlots</code> with iterating integers. Good for quick animations in flixel.
		 * @param	numSlots	Size of array (remember, 10 will give you an array with numbers 0 to 9).
		 * @return	Array of integers.
		 */
		public static function fillArray(numSlots:uint):Array
		{
			var array:Array = new Array();
			for (var i:uint = 0; i < numSlots; i++)
			{
				array.push(i);
			}
			
			return array;
		}
		
		/**
		 * Counts the number of occurrences of a specific match within a string
		 * @param	input	The string in which to search.
		 * @param	match	The string being sought.
		 * @return	Number of matches.
		 */
		public static function CountStrings(input:String, match:String):int
		{
			var s:String = input; // Temp string to avoid messing with the original.
			var count:int = 0;	// Counter for hits. Will be returned.
			while (s.indexOf(match) > -1) // While we still have a hit.
			{
				count++; // Iterate the hit counter.
				s = s.substring(input.indexOf(match) + 1); // Remove the string parsed so far.
			}
			// Return the final count.
			trace("CountStrings returning " + count.toString() + ".");
			return count;
		}
		
		/**
		 * Reduces a vector of objects to a true/false array. False if an index is a null reference, true otherwise.
		 * @param	input	The Vector object to reduce.
		 * @return	The reduced Vector as an Array.
		 */
		public static function GetBinaryArray(input:Vector.<Object>):Array
		{
			var ret:Array = new Array();
			for each (var o:Object in input)
			{
				if (o == null) ret.push(false);
				else ret.push(true);
			}
			return ret;
		}
	}	
}