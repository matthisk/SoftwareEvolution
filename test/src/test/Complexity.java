package test;

public class Complexity {

	public void testComplexityMethod() {
	 	if( true ) { }
	 	if( true && false ) { } else { }
	 	if( true || false ) { }
	  	for(int i = 0; i < 10; i++) { 
	  		String res = true ? "ja" : "nee";
	  	}
	  	try { } catch(NullPointerException e) { }
	  	switch( "blaat" ) {
	  		case "blaat": break;
	  		case "blaaat": break;
	  	}
	  	int i = 1000;
	  	while( i > 100 ) {
	  		
	  	}
	}
	
}
