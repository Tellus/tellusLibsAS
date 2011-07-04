package dk.homestead.utils 
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	/**
	 * Methods for reflection (introspection) primarily inspired by
	 * reflection in .NET and the Type class from the framework.
	 * @author Johannes L. Borresen
	 */
	public final class Reflection 
	{
		public function Reflection() { }
		
		/**
		 * Checks the inheritance of subType and attempts to determine whether it is a subtype of baseType.
		 * @param	baseType	The base type we're checking inheritance for.
		 * @param	subType		The subtype, whose inheritance is being checked.
		 * @return	True if baseType is one of subType's base classes, false otherwise.
		 */
		public static function SubTypeOf(baseType:*, subType:*):Boolean
		{
			// I think execution doesn't care if it's an object or a class.
			var superType:String = getQualifiedSuperclassName(subType);
			
			while (superType != getQualifiedClassName(baseType) && superType != getQualifiedClassName(Object))
			{
				trace("Extracted " + superType);
				superType = getQualifiedSuperclassName(flash.utils.getDefinitionByName(superType));
			}
			
			if (superType == getQualifiedClassName(baseType))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}