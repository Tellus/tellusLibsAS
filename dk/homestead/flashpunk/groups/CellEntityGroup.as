package dk.homestead.flashpunk.groups 
{
	/**
	 * The cell-based entity group is by far the most visually pleasing
	 * and organic (keep in mind the tiled one will have rigid niceness).
	 * While working from the same tile-based starting point, entities are
	 * allowed to be larger than the cells and will be filled into the cells
	 * accordingly. Each cell may contain part of (or all of) at most one
	 * entity.
	 * @author Johannes L. Borresen
	 */
	public class CellEntityGroup extends EntityGroup 
	{
		
		public function CellEntityGroup() 
		{
			throw new Error(toString() + " has not yet been implemented.");
		}
		
	}

}