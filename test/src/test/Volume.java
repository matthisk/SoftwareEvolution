package test;

// Normal line of comments

/**
 * JAVADOC...
 * @author matthisk
 *
 */
public class Volume {
	
	/**
	 * Javadoc on property
	 */
	public int num = 10;
	
	/**
	 * Test some java doc
	 * @param param1
	 * @param param2
	 */
	public void tester( String param1, int param2) {
		
	}
	
	/*
	 * Multi line comments with stars
	 * 
	 * 
	 * 
	 */
	public String m1() { /*
		Multi line comment broken
		*/
		String res = "";
		
		return res; // Some comments on a line
	}
	
	public String m2() {
		String res = 
				"//Comment in string";
		String res2 = "/* multilin"
				+ "e comment in string */";
		
		return res + res2;
	}
	
	/*
	 * Test strange edge cases 
	 */ // Comment after multiline comment
	public int m3( String param1, /* Comment in params*/ String param2 ) {
		int i = 10;
		int j = 12; 
		
		/*
		 * Multiline 
		 */ return i + j; // Single line
	}
	
}
