package dk.homestead.utils 
{
	import flash.geom.Point;
	/**
	 * Static class with a bunch of math functions, primarily within geometry.
	 * @author Johannes L. Borresen
	 */
	public final class Calc
	{
		public static function vectorLength(input:Point):Number
		{
			return Math.sqrt(Math.pow(input.x, 2) + Math.pow(input.y, 2));
		}
		
		public static function calcVectorLength(pt1:Point, pt2:Point):Number
		{
			return (Math.sqrt(Math.pow(pt2.x - pt1.x,2) + Math.pow(pt2.y - pt1.y,2)));
		}
		
		public static function calcUnitVector(pt1:Point, pt2:Point):Point
		{
			// Calculate the total movement vector:
			var totalMoveVector:Point = new Point(pt2.x - pt1.x, pt2.y - pt1.y);
			
			var returnP:Point = new Point(totalMoveVector.x / calcVectorLength(pt1, pt2), totalMoveVector.y / calcVectorLength(pt1, pt2));
			
			return returnP;
		}
		
		/**
		 * Calculates the distance between two sets of coordinates based on simple Pythagoras.
		 * Strangely, Flash doesn't have this function.
		 * @param	x1	x-coordinate of the first point.
		 * @param	y1	y-coordinate of the first point.
		 * @param	x2	x-coordinate of the second point.
		 * @param	y2	y-coordinate of the second point.
		 * @return	The distance between the points. Always positive.
		 */
		public static function distanceBetweenCoords(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
		}
		
		/**
		 * Calculates the distance between two flash points. Always positive.
		 * @param	pt1	First point.
		 * @param	pt2	Second point.
		 * @return	Distance, always positive.
		 */
		public static function distanceBetweenPoints(pt1:Point, pt2:Point):Number
		{
			return distanceBetweenCoords(pt1.x, pt1.y, pt2.x, pt2.y);
		}
		
		/**
		 * Calculates radians from degrees.
		 * @param	deg	Angle in degrees to convert.
		 * @return
		 */
		public static function degreesToRadians(deg:Number):Number
		{
			return deg * (Math.PI / 180);
		}
		
		/**
		 * Calculates degrees from radians.
		 * @param	rad	Angle in radians to convert.
		 * @return
		 */
		public static function radiansToDegrees(rad:Number):Number
		{
			return rad * (180 / Math.PI);
		}
		
		/**
		 * Rotates a point around another point and returns its new position.
		 * Blatantly stolen from http://tdotblog.info/?q=node/16.
		 * @param	p	The point to rotate.
		 * @param	o	The origin (or the point to rotate around).
		 * @param	d	The amount of degrees to rotate it.
		 * @return	The new position of the point.
		 */
		public static function rotatePoint(p:Point, o:Point, d:Number):Point
		{
			var np:Point = new Point();
			p.x += (0 - o.x);
			p.y += (0 - o.y);
			np = rotate(p, d);
			np.x += (0 + o.x);
			np.y += (0 + o.y)
			
			return np;
		}
		
		public static function rotate(p:Point, d:Number):Point
		{
			var np:Point = new Point();
			np.x = (p.x * Math.cos(d * (Math.PI/180))) - (p.y * Math.sin(d * (Math.PI/180)));
			np.y = Math.sin(d * (Math.PI / 180)) * p.x + Math.cos(d * (Math.PI / 180)) * p.y;
			return np;
		}
		
		public function Calc() { }
		
		/**
		 * The second part of modulo, returns the quotient (fuck, I've needed this).
		 * I should probably make it more effective as I learn, but this is golden!
		 * @param	a	The number to BE divided (as in divident/a).
		 * @param	d	The number to divided (as in b/divisor).
		 * @return	The QUotiENT from the division. Note how mod returns the rest instead.
		 */
		public static function div(a:Number, d:Number):Number
		{
			var q:Number = 0;
			var r:Number = a;
			
			while (r > d)
			{
				r -= d;
				q++;
			}
			
			if (a < 0 && r > 0)
			{
				r = d - r;
				q = -(q + 1);
			}
			
			return q;
		}
		
		/**
		 * Alternative quotient calculation, using modulo and my classic method.
		 * @param	toDivide	The number to divide. toDivide/divideBy
		 * @param	divideBy	The number to divide by. toDivide/divideBy
		 * @return	The quotient. While the input parameters can be numbers, the quotient will always be an integer.
		 */
		public static function div2(toDivide:Number, divideBy:Number):int
		{
			var rest:Number = toDivide % divideBy; // Remainder. Removing this we get a clean quotient.
			return (toDivide-rest) / divideBy;
		}
	}

}