package dk.homestead.utils 
{
	/**
	 * A key-value pair is a simple object with two values, the key (a string)
	 * and its value (an object). Very good for storing object members.
	 * @author Johannes L. Borresen
	 */
	public class KeyValuePair
	{
		public var Key:String;
		
		public var Value:*;
		
		public function KeyValuePair(key:String, value:*) 
		{
			Key = key;
			Value = value;
		}
		
	}

}