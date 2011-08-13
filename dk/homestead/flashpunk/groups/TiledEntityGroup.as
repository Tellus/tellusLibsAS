package dk.homestead.flashpunk.groups 
{
	import dk.homestead.utils.Calc;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	/**
	 * A Tiled entity group is a glorified tilemap of sorts. It specialises
	 * in placing each Entity within a tile area of a specific size.
	 * You define, width, height and square tile size. Entities will be placed
	 * center within each tile, one entity to a tile. This one would be
	 * pretty decent for inventory screens, for example.
	 * @author Johannes L. Borresen
	 */
	public class TiledEntityGroup extends EntityGroup 
	{
		/**
		 * Size of the tiles for the group.
		 */
		public var TileSize:int;
		
		/**
		 * Number of tiles to a row.
		 */
		public var TileWidth:int;
		
		/**
		 * Number of tiles to a column.
		 */
		public var TileHeight:int;
		
		/**
		 * Creates a new TiledEntityGroup instance.
		 * @param	tileSize	The square size of a tile (so it will be tileSize*tileSize in size).
		 * @param	w	Width, in tiles, of the group.
		 * @param	h	Height, in tiles, of the group.
		 */
		public function TiledEntityGroup(tileSize:int, w:int = 1, h:int = 1) 
		{
			super(w * TileSize, h * tileSize);
			
			MoveFactorX = MoveFactorY = 1.0;
			
			TileSize = tileSize;
			TileWidth = w;
			TileHeight = h;
		}
		
		override protected function updateLayout():void 
		{
			// trace("TiledEntityGroup doing layout on a " + new Point(TileWidth, TileHeight).toString() + " tilemap.");
			var e:Entity;
			var i:int;
			for (var row:int = 0; row < TileHeight; row++)
			{
				for (var col:int = 0; col < TileWidth; col++)
				{
					// Index in Vector: row * TileWidth + col;
					i = row * TileWidth + col;
					if (i < members.length)
					{
						e = members[i];
						
						e.x = this.x + TileSize * col// + TileSize / 2 - e.halfWidth;
						e.y = this.y + TileSize * row// + TileSize / 2 - e.halfHeight;
						trace("Entity moved to tile position " + new Point(col, row).toString() + ", coords " + new Point(e.x, e.y).toString());
					}
					else
					{
						return; // Force out if we can't process any more.
					}
				}
			}
		}
	}
}