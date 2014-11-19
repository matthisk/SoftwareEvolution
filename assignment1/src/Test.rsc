module Test

import Prelude;

import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import Volume;
import Complexity;
import Duplication;
import Util;

public loc testVolume = |project://test/src/test/Volume.java|;
public loc testComplexity = |project://test/src/test/Complexity.java|;
public loc testDuplication = |project://test/src/test/Duplication.java|;
public loc testProject = |project://test/|;

public test bool testGetLOC() {
	mmm = createM3FromEclipseFile( testVolume );
	return getLOC( mmm ) == 22;
}

public test bool testGetCode() {
	mmm = createM3FromEclipseFile( testVolume );
	return size( ([] | it + l | <_,l> <- getCode( mmm ) ) ) == 22;
}

public test bool testGetUnitVolumes() {
	ast = createAstsFromEclipseFile( testVolume, true );
	mmm = createM3FromEclipseFile( testVolume );
	units = getUnitVolumes( {ast}, mmm );
	total = sum( range( units ) );
	
	return size( units ) == 4 && total == 18; 
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
	complexities = getUnitComplexities( { createAstsFromEclipseFile( testComplexity, true ) } );
	
	result = false;
	for( location <- complexities ) {
		result = complexities[ location ] == 13;
	}
	
	return result;
}

public test bool testDups() {
	mmm = createM3FromEclipseFile( testDuplication );
	
	return findDuplicates( getCode( mmm ) ) == 16;
}

public test bool testGetFiles() {
	mmm = createM3FromEclipseProject( testProject );
	
	return size( getFiles( mmm ) ) == 3;
}