module Test

// LIBRARY IMPORTS
import Prelude;

// M3 IMPORTS
import lang::java::m3::AST;

// LOCAL IMPORTS
import Clones;
import Util;

// TEST JAVA FILES
public loc test_clones_1 = |project://test/src/test/Clones1.java|;
public loc test_clones_2 = |project://test/src/test/Clones2.java|;

/*
 * CLONES TEST METHODS
 */
public test bool test_astCloneMap_1() {
	ast = generalizeNames( createAstFromFile( test_clones_1, true ) );
	result = range( subsumeAstClones( findAstClones( ast, () ) ) );
	
	assertion = {|project://test/src/test/Clones1.java|(127,116,<9,1>,<16,2>),|project://test/src/test/Clones1.java|(247,116,<18,1>,<25,2>)};
	
	return {assertion} == result;
}

public test bool test_astCloneMap_2() {
	ast = generalizeNames( createAstFromFile( test_clones_2, true ) );
	result = range( subsumeAstClones( findAstClones( ast, () ) ) );
	
	assertion = {{|project://test/src/test/Clones2.java|(402,105,<16,12>,<20,13>),|project://test/src/test/Clones2.java|(779,105,<29,12>,<33,13>),|project://test/src/test/Clones2.java|(1047,89,<39,8>,<43,9>)},{|project://test/src/test/Clones2.java|(174,343,<11,8>,<21,9>),|project://test/src/test/Clones2.java|(535,359,<23,8>,<34,9>)}};
	
	return assertion == result;
}

public test bool test_astCloneMap_3() {
	ast2 = generalizeNames( createAstFromFile( test_clones_1, true ) );
	ast1 = generalizeNames( createAstFromFile( test_clones_2, true ) );
	m = findAstClones( ast1, () );
	result = range( subsumeAstClones( findAstClones( ast2, m ) ) );
	
	assertion = {{|project://test/src/test/Clones2.java|(402,105,<16,12>,<20,13>),|project://test/src/test/Clones2.java|(779,105,<29,12>,<33,13>),|project://test/src/test/Clones2.java|(1047,89,<39,8>,<43,9>)},{|project://test/src/test/Clones2.java|(1146,624,<46,1>,<63,2>),|project://test/src/test/Clones1.java|(366,623,<27,1>,<44,2>)},{|project://test/src/test/Clones2.java|(174,343,<11,8>,<21,9>),|project://test/src/test/Clones2.java|(535,359,<23,8>,<34,9>)},{|project://test/src/test/Clones1.java|(127,116,<9,1>,<16,2>),|project://test/src/test/Clones1.java|(247,116,<18,1>,<25,2>)}};
	
	return assertion == result; 
}

public test bool test_sequenceCloneMap_1() {
	ast = generalizeNames( createAstFromFile( test_clones_2, true ) );
	result = range( subsumeSequenceClones( findSequenceClones( ast, () ) ) );
	
	assertion = {{|project://test/src/test/Clones2.java|(198,309,<12,12>,<20,13>),|project://test/src/test/Clones2.java|(559,325,<24,12>,<33,13>)},{|project://test/src/test/Clones2.java|(1540,195,<57,8>,<60,32>),|project://test/src/test/Clones2.java|(1195,182,<47,2>,<50,31>),|project://test/src/test/Clones2.java|(198,191,<12,12>,<15,32>),|project://test/src/test/Clones2.java|(559,194,<24,12>,<27,35>)}};
	
	return assertion == result;
}

public test bool test_cloneMap_1() {
	ast = generalizeNames( createAstFromFile( test_clones_2, true ) );
	astClones = subsumeAstClones( findAstClones( ast, () ) );
	sequenceClones = subsumeClones( astClones, subsumeSequenceClones( findSequenceClones( ast, () ) ) );
	clones = range(astClones) + range(sequenceClones);
	
	astAssertion = {{|project://test/src/test/Clones2.java|(402,105,<16,12>,<20,13>),|project://test/src/test/Clones2.java|(779,105,<29,12>,<33,13>),|project://test/src/test/Clones2.java|(1047,89,<39,8>,<43,9>)},{|project://test/src/test/Clones2.java|(174,343,<11,8>,<21,9>),|project://test/src/test/Clones2.java|(535,359,<23,8>,<34,9>)}};
	seqAssertion = {{|project://test/src/test/Clones2.java|(1540,195,<57,8>,<60,32>),|project://test/src/test/Clones2.java|(1195,182,<47,2>,<50,31>),|project://test/src/test/Clones2.java|(198,191,<12,12>,<15,32>),|project://test/src/test/Clones2.java|(559,194,<24,12>,<27,35>)}};
	
	return range(astClones) == astAssertion && range(sequenceClones) == seqAssertion;
}

public test bool test_cloneMap_2() {
	ast2 = generalizeNames( createAstFromFile( test_clones_1, true ) );
	ast1 = generalizeNames( createAstFromFile( test_clones_2, true ) );
	
	m = findAstClones( ast1, () );
	astClones = subsumeAstClones( findAstClones( ast2, m ) );
	
	m2 = findSequenceClones( ast1, () );
	sequenceClones = subsumeClones( astClones, subsumeSequenceClones( findSequenceClones( ast2, m2 ) ) );
	
	iprintln(range(astClones));
	iprintln(range(sequenceClones));
	
	astAssertion = {{|project://test/src/test/Clones2.java|(402,105,<16,12>,<20,13>),|project://test/src/test/Clones2.java|(779,105,<29,12>,<33,13>),|project://test/src/test/Clones2.java|(1047,89,<39,8>,<43,9>)},{|project://test/src/test/Clones2.java|(1146,624,<46,1>,<63,2>),|project://test/src/test/Clones1.java|(366,623,<27,1>,<44,2>)},{|project://test/src/test/Clones2.java|(174,343,<11,8>,<21,9>),|project://test/src/test/Clones2.java|(535,359,<23,8>,<34,9>)},{|project://test/src/test/Clones1.java|(127,116,<9,1>,<16,2>),|project://test/src/test/Clones1.java|(247,116,<18,1>,<25,2>)}};
	seqAssertion = {{|project://test/src/test/Clones1.java|(415,182,<28,2>,<31,31>),|project://test/src/test/Clones2.java|(1540,195,<57,8>,<60,32>),|project://test/src/test/Clones1.java|(759,195,<38,8>,<41,32>),|project://test/src/test/Clones2.java|(1195,182,<47,2>,<50,31>),|project://test/src/test/Clones2.java|(198,191,<12,12>,<15,32>),|project://test/src/test/Clones2.java|(559,194,<24,12>,<27,35>)}};
		
	return astAssertion == range(astClones) && seqAssertion == range(sequenceClones);
}

/*
 * UTIL TEST METHODS
 */
public test bool test_locationsOverlap_1() {
	s1 = { |file://schets/location1.java|(0,0,<1,0>,<5,0>), |file://schets/location2.java|(0,0,<7,0>,<11,0>), |file://schets/location3.java|(0,0,<140,0>,<145,0>) };
	s2 = { |file://schets/location1.java|(0,0,<4,0>,<10,0>), |file://schets/location2.java|(0,0,<10,0>,<16,0>), |file://schets/location4.java|(0,0,<143,0>,<149,0>)};
	
	return 0 == size(locationsOverlap( s1, s2 ));
}

public test bool test_locationsOverlap_2() {
	s1 = { |file://schets/location1.java|(0,0,<1,0>,<5,0>), |file://schets/location2.java|(0,0,<7,0>,<11,0>), |file://schets/location3.java|(0,0,<140,0>,<145,0>) };
	s2 = { |file://schets/location1.java|(0,0,<4,0>,<10,0>), |file://schets/location2.java|(0,0,<10,0>,<16,0>), |file://schets/location3.java|(0,0,<143,0>,<149,0>)};
	
	return 3 == size(locationsOverlap( s1, s2 ));
}

public test bool test_locationsOverlap_3() {
	s1 = { |file://schets/location1.java|(0,0,<1,0>,<5,0>), |file://schets/location2.java|(0,0,<7,0>,<11,0>), |file://schets/location3.java|(0,0,<140,0>,<145,0>) };
	s2 = { |file://schets/location1.java|(0,0,<4,0>,<10,0>), |file://schets/location2.java|(0,0,<10,0>,<11,0>), |file://schets/location3.java|(0,0,<143,0>,<149,0>)};
	
	return 0 == size(locationsOverlap( s1, s2 ));
}

public test bool test_smallestLoc_1() {
	s = {|project://test/src/test/Clones2.java|(1069,57,<40,9>,<42,26>),|project://test/src/test/Clones2.java|(428,65,<17,13>,<19,30>),|project://test/src/test/Clones2.java|(805,65,<30,13>,<32,30>) };
	
	return smallestLoc( s ) == 3;
}

public test bool test_uniqueLocations_1() {
	return uniqueLocations({|file:///file1.java|,|file:///file2.java|}) == 2 && uniqueLocations({|file:///file1.java|,|file:///file1.java|}) == 1;
}

public test bool test_sequenceLocation_1() {
	nLoc = sequenceLocation([|project://Clones2.java|(1069,57,<40,9>,<42,26>),|file:///onzin.java|,|project://Clones2.java|(1100,150,<41,9>,<46,26>)]);
	assertion = |project://Clones2.java|(1069,181,<40,9>,<46,26>);
	
	return assertion == nLoc;
}