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
	}	
}