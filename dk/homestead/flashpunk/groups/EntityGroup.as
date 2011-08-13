package dk.homestead.flashpunk.groups 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Text;
	
	/**
	 * The entity group (originally simply a text group) is a simple assembly
	 * of Entity objects, optionally with a movement factor for when the group
	 * is moved.
	 * I'd love to use the same efficient method that Chevy applies in World,
	 * but it's too far ingrained for me to bother trying to strain it out
	 * right now. I would, however, love to see the group functionality of
	 * World be extracted to a proper EntityGroup class right above World.
	 * @author Johannes L. Borresen
	 */
	public class EntityGroup extends Entity 
	{
		/**
		 * List of the text graphics objects. Partially code redundancy, partially
		 * class design, we utilize proper Entity objects instead of simply Text
		 * objects (Graphic subtype).
		 */
		protected var members:Vector.<Entity> = new Vector.<Entity>();
		
		/**
		 * How much the contained objects are affected by moving the group
		 * along the X axis.
		 * By default, members are not moved at all when you move the group.
		 * This is intentional.
		 * @default 0.0
		 */
		public var MoveFactorX:Number = 0.0;
		
		/**
		 * How much the contained objects are affected by moving the group
		 * along the Y axis.
		 * By default, members are not moved at all when you move the group.
		 * This is intentional.
		 * @default 0.0
		 */
		public var MoveFactorY:Number = 0.0;
		
		/**
		 * Registers the previous location of the group, so it can be determined
		 * whether (and how much) members should be shifted from the current
		 * position.
		 */
		private var _oldLoc:Point = new Point();
		
		/**
		 * Whether the group was moved this frame.
		 */
		protected var movedThisFrame:Boolean = false;
		
		public function EntityGroup(w:int = 0, h:int = 0) 
		{
			super();
			
			setHitbox(w, h);
		}
		
		/**
		 * Adds an Entity to the group.
		 * @param	e
		 */
		public function add(e:Entity):void
		{
			members.push(e);
			updateLayout();
		}
		
		/**
		 * Removes an entity from the group.
		 * @param	e
		 */
		public function remove(e:Entity):void
		{
			members.splice(members.indexOf(e), 1);
			updateLayout();
		}
		
		/**
		 * Moves an entity one step up in the group towards the top layer.
		 * @param	e
		 */
		public function MoveUp(e:Entity):void
		{
			var i:int = members.indexOf(e);
			if (i <= 0) return; // If not in list or already at top, ignore.
			var tmp:Entity = members[i - 1];
			members[i] = tmp; // Put previous occupant one step down.
			members[i - 1] = e;	// Put in new occupant.
			
			updateLayout();
		}
		
		/**
		 * Moves an entity one step down in the group towards the bottom layer.
		 * @param	e
		 */
		public function MoveDown(e:Entity):void
		{
			var i:int = members.indexOf(e);
			if (i >= members.length || i == -1) return; // If in bottom or not in list, ignore.
			var tmp:Entity = members[i + 1];
			// Put occupants around.
			members[i] = tmp;
			members[i + 1] = e;
			
			updateLayout();
		}
		
		/**
		 * Moves an entity the topmost position.
		 * @param	e	The Entity to move.
		 */
		public function MoveToTop(e:Entity):void
		{
			var i:int = members.indexOf(e);
			if (i == -1) throw new Error("Entity was not found in the members collection.");
			
			members.splice(i, 1); // Remove from current location.
			members.unshift(e);	// Insert at start.
		}
		
		/**
		 * Moves an entity to the bottommost position.
		 * @param	e	The Entity to move.
		 */
		public function MoveToBottom(e:Entity):void
		{
			var i:int = members.indexOf(e);
			if (i == -1) throw new Error("Entity was not found in the members collection.");
			
			members.splice(i, 1);
			members.push(e);
		}
		
		override public function render():void 
		{
			super.render();
			
			for each (var e:Entity in members) if (e && e.visible) e.render();
		}
		
		/**
		 * Updates the placement of all entities. Should be overriden (and not
		 * super.called) in subclasses.
		 */
		protected function updateLayout():void
		{
			// Movement differential.
			var nX:Number = (x - _oldLoc.x) * MoveFactorX;
			var nY:Number = (y - _oldLoc.y) * MoveFactorY;
			for each (var e:Entity in members)
			{
				if (e)
				{
					e.x += nX;
					e.y += nY;
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			// Reset movement bool.
			movedThisFrame = false;
			
			// If the group has been moved AND either factor is greater than 0,
			// we move the members as well. Optimized for speed.
			// It will not calculate if move factors are not an issue. If they are,
			// it will not calculate if the group has not been moved.
			if ((MoveFactorX || MoveFactorY) && (_oldLoc.x != x || _oldLoc.y != y))
			{
				// trace("EntityGroup moved. Updating layout.");
				movedThisFrame = true;
				updateLayout();
			}
			
			_oldLoc = new Point(x, y);
		}
	}

}