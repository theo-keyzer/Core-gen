part of gen;

class KpExtra extends Kp 
{
	List get_var(glob, va, lno) {
		var v = names[ va[0] ];
		if(v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Kp?"] );			
	}
		
}



