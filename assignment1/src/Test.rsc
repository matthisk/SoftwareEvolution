module Test

import Prelude;

import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;

import Volume;
import Complexity;

public loc testVolume = |file:///Users/matthisk/Repositories/SoftwareEvolution/test/src/test/Volume.java|;
public loc testComplexity = |file:///Users/matthisk/Repositories/SoftwareEvolution/test/src/test/Complexity.java|;

public test bool testGetLOC() {
	mmm = createM3FromFile( testVolume );
	return getLOC( mmm ) == 22;
}

public test bool testGetCode() {
	mmm = createM3FromFile( testVolume );
	return size( getCode( mmm ) ) == 22;
}

public test bool testGetUnitVolumes() {
	ast = createAstFromFile( testVolume );
	mmm = createM3FromFile( testVolume );
	units = getUnitVolumes( {ast}, mmm );
	total = sum( range( units ) );
	
	return size( units ) == 4 && total == 22; 
}

public test bool testSortUnitVolumes() {
	vols = (
		|file://test1/| : 8,
		|file://test2/| : 20,
		|file://test3/| : 22,
		|file://test4/| : 44,
		|file://test5/| : 85,
		|file://test6/| : 99
	);
	
	vols2 = ();
	
	tuple[num low,num moderate,num high,num veryHigh] sorted  = sortUnitVolumes( vols );
	tuple[num low,num moderate,num high,num veryHigh] sorted2 = sortUnitVolumes( vols2 );
	
	return sorted.low == 28 && sorted.moderate == 66 && sorted.high == 184 && sorted.veryHigh == 0
	       && sorted2.low == 0 && sorted2.moderate == 0 && sorted2.high == 0 && sorted2.veryHigh == 0; 
}

public test bool testUnitComplexities() {
	complexities = getUnitComplexities( createAstsFromEclipseProject( testComplexity, true ) );
	
	result = false;
	for( location <- complexities ) {
		result = complexities[ location ] == 13;
	}
	
	return result;
}