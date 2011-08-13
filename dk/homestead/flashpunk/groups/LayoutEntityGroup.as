package dk.homestead.flashpunk.groups 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	/**
	 * Lays out the entities somewhat messily from a specific width
	 * constraint.
	 * @author Johannes L. Borresen
	 */
	public class LayoutEntityGroup extends EntityGroup 
	{
		/**
		 * Creates a new entity group with the specified width constaint.
		 * If omitted, each entity is placed beneath the previous.
		 * @param	w
		 */
		public function LayoutEntityGroup(w:int = 0) 
		{
			super(w);
			setHitbox(w);
			MoveFactorX = MoveFactorY = 1.0;
		}
		
		/**
		 * Recalculates the layout based on width constraint.
		 * Called automatically by super.update() but can be manually
		 * called when need be.
		 */ 
		override protected function updateLayout():void
		{
			var i:int = 0; // Iterator, backwards.
			var e:Entity;	// Temp entity container.
			var maxHeight:Number = 0;	// Max height for a row. Used to calculate y for next row.
			var p:Point = new Point(x, y); // Where to place a given entity.
			while (i++ < members.length)
			{
				e = members[i-1];
				// trace("Doing layout on " + new Point(e.x, e.y).toString(), ", sized " + new Point(e.width, e.height).toString());
				maxHeight = Math.max(e.height, maxHeight); // Get the largest height.
				if (e.width + p.x > width)
				{
					p.y += maxHeight;
					maxHeight = 0;
					p.x = x;
				}
				e.x = p.x;
				e.y = p.y;
				p.x += e.width;
			}
		}
	}
}