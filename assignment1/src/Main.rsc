module Main

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::m3::AST;

import Prelude;
import IO;

import Util;
import Volume;
import Complexity;
import Ranking;

public loc hsqldb = |project://hsqldb|;
public loc smallsql = |project://smallsql|;
public loc basicJava = |file:///Users/matthisk/Dropbox/Studie/Faculteit-Beta/Bachelor/Datastructuren/practicum1/Dingesen/src/HeapSorteerder.java|;
public loc schets = |project://schets|;

public void run( loc project ) {
	println("Running metrics for project: <project>");
	ast = createAstsFromEclipseProject( project, true );
	
	linesOfCode            = getLOC( project );
	complexities           = getCyclomaticComplexity( ast );
	sortedCC               = sortComplexities( complexities );
	sortedUnitSize         = sortUnitSize( complexities );
	rankingUnitComplexity  = getUnitRanking( linesOfCode, sortedCC );
	rankingUnitSize        = getUnitRanking( linesOfCode, sortedUnitSize );
	rankingLinesOfCode     = getLOCRanking( linesOfCode ); 
	
	println("Lines of code: <rankingLinesOfCode>
	        'Unit volume ranking: <rankingUnitSize>
	        'Unit complexity ranking: <rankingUnitComplexity>");
}

public void runComplexity( loc project ) {
	println("Creating Asts and M3 for: <project>");
	runComplexity( createAstsFromEclipseProject( project, true ), createM3FromEclipseProject( project ) );
}
public void runComplexity( set[Declaration] ast, M3 model ) {
	println("Running cyclomatic complexity metrics for project: <model.id>
			'
			'Calculating lines of code");
	
	linesOfCode = getLOC( model );
	
	println("
			'Calculating unit complexities");
	unitVolumes = getUnitVolumes( ast, model );
	unitComplexities = getUnitComplexities( ast );
	
	maxComplexity = maxRange( unitComplexities );
	println("
			'Most complex unit(s):
			'---------------------");
	for( <l,c> <- maxComplexity ) println("Complexity <c> location: <l>");
	
	sortedUnitComplexities = sortComplexities( unitComplexities, unitVolumes );
	
	println("
			'Unit complexity ranking: <getUnitRanking( linesOfCode, sortedUnitComplexities )>");
}

public void runVolume( loc project ) {
	println("Creating M3 for: <project>");
	runVolume( createM3FromEclipseProject( project ) );
}
public void runVolume( M3 model ) {
	println("Running volume metrics for project: <model.id>");
	model = createM3FromEclipseProject( project );
	
	linesOfCode = getLOC( model );
	
	println("Total lines of code: <linesOfCode>
		    'Lines of comments:   <getNoComments( model )>
			'Volume ranking:      <getVolumeRanking( linesOfCode )>");
}

public void runUnitVolume( loc project ) {
	println("Creating Asts and M3 for: <project>");
	runUnitVolume( createAstsFromEclipseProject( project, true ), createM3FromEclipseProject( project ) );
}
public void runUnitVolume( set[Declaration] ast, M3 model ) {
	println("Running unit volume metrics for project: <model.id>");
	
	println("Calculating lines of code");
	linesOfCode = getLOC( model );
	
	println("Calculating unit volumes");
	unitVolumes  = getUnitVolumes( ast, model );
	biggestUnits = maxRange( unitVolumes );
	println("Largest unit(s):
			'--------------");
	for( <l, size> <- biggestUnits ) println("Size: <size>, location: <l>");
	
	println("
			'Calculating amount of methods...");
	println("Amount of units: <getNoMethods( model )>
		    '
		    '--------------");
	
	sortedUnitVolumes = sortUnitVolumes( unitVolumes );
	println("Unit volume ranking: <getUnitRanking( linesOfCode, sortedUnitVolumes )>");
}

