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
import Duplication;
import Ranking;

public loc hsqldb    = |project://hsqldb|;
public loc smallsql  = |project://smallsql|;
public loc basicJava = |file:///Users/matthisk/Dropbox/Studie/Faculteit-Beta/Bachelor/Datastructuren/practicum1/Dingesen/src/HeapSorteerder.java|;
public loc schets    = |project://schets|;

public void run( loc project ) {
	println("Creating Asts and M3 for: <project>");
	run( createAstsFromEclipseProject( project, true ), createM3FromEclipseProject( project ) );
}
public void run( set[Declaration] ast, M3 model ) {
	println("Running metrics for project: <model.id>");
	
	println("Retrieving code...");
	code                   = getCode( model ); 
	linesOfCode            = size(( [] | it + lines | <_,lines> <- code ));
	
	println("Calculating unit complexities...");
	unitVolumes      = getUnitVolumes( ast, model );
	unitComplexities = getUnitComplexities( ast );
	complexities     = getUnitComplexities( ast );
	sortedCC         = sortComplexities( unitComplexities, unitVolumes );
	sortedUnitVolume = sortUnitVolumes( unitVolumes );
	
	println("Calculating duplicated lines of code...");
	duplicates             = findDuplicates( code );
	
	rankingUnitComplexity  = getUnitRanking( sortedCC );
	rankingUnitVolume      = getUnitRanking( sortedUnitVolume );
	rankingDuplication     = getDuplicationRanking( linesOfCode, duplicates );
	rankingVolume          = getVolumeRanking( linesOfCode ); 
	
	analysability  = average( [rankingVolume, rankingDuplication, rankingUnitVolume] );
	changeability  = average( [rankingUnitVolume, rankingDuplication] );
	stability      = 0;
	testability    = average( [rankingUnitComplexity, rankingUnitVolume] );
	maintenance    = average( [rankingVolume, rankingUnitVolume, rankingUnitComplexity, rankingDuplication ] );
	
	println("
			'Basic result:
			'============================
			'Total lines of code:        <linesOfCode>
			'Duplicated lines of code:   <duplicates>
			'Percentage duplicated code: <percentageOf(duplicates, linesOfCode)>%
			'Number of units:            <getNoMethods( model )>
			'Number of files:            <size(files(model))>
			'Average unit size:          <average( range( unitVolumes ) )>
			'Average unit complexity:    <average( range( unitComplexities ) )>
			'============================");	
	
	println("
			'Most complex unit(s):
			'============================");
	maxUnits( unitComplexities, "Complexity" );
	println("============================");
	
	println("
			'Biggest unit(s):
			'============================");
	maxUnits( unitVolumes, "Size" );
	println("============================");
	
	println("
			'Risk measures unit volume:
			'============================
			'<risk( sortedUnitVolume )>
			'============================");
	
	println("
			'Risk measures unit complexity:
			'============================
			'<risk( sortedCC )>
			'============================");
	
	println("
			'Rank per measure:
			'============================
			'Lines of code:           <printRank( rankingVolume )>
	        'Unit volume ranking:     <printRank( rankingUnitVolume )>
	        'Unit complexity ranking: <printRank( rankingUnitComplexity )>
	        'Duplication ranking:     <printRank( rankingDuplication )>
	        '============================");
	
	println("
			'                  v   c   d   un
			'                  o   o   u   it
			'                  l   m   p   si
			'                  m   p   l   ze 
			'================|===|===|===|===|===
			'Analysability:  | x |   | x | x | <printRank(analysability)>
			'Changeability:  |   | x | x |   | <printRank(changeability)>
			'Stability:      |   |   |   |   | <printRank(stability)>
			'Testability:    |   | x |   | x | <printRank(testability)>
			'====================================
			'Maintenance:    | x | x | x | x | <printRank(maintenance)>");
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
	
	
	println("Most complex unit(s):
			'============================");
	maxUnits( unitComplexities, "Complexities" );
	println("============================");
	
	sortedUnitComplexities = sortComplexities( unitComplexities, unitVolumes );
	
	println("
			'Unit complexity ranking: <printRank( getUnitRanking( sortedUnitComplexities ) )>");
}

private void maxUnits( map[loc,num] unitMeasures, str t ) {
	for( <l,c> <- maxRange( unitMeasures ) ) println("<t>: <c> location: <l>");
}

public void runVolume( loc project ) {
	println("Creating M3 for: <project>");
	runVolume( createM3FromEclipseProject( project ) );
}
public void runVolume( M3 model ) {
	println("Running volume metrics for project: <model.id>");
	
	linesOfCode = getLOC( model );
	
	println("Total lines of code: <linesOfCode>
		    'Lines of comments:   <getNoComments( model )>
			'Volume ranking:      <printRank( getVolumeRanking( linesOfCode ) )>");
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
	
	println("Largest unit(s):
			'============================");
	maxUnits( unitVolumes, "size" );
	
	println("
			'Calculating amount of methods...");
	println("Amount of units: <getNoMethods( model )>
		    '============================");
	
	sortedUnitVolumes = sortUnitVolumes( unitVolumes );
	println("Unit volume ranking: <printRank( getUnitRanking( sortedUnitVolumes ) )>");
}

public void runDuplication( loc project ) {
	println("Creating M3 for: <project>");
	runDuplication( createM3FromEclipseProject( project ) );
}
public void runDuplication( M3 model ) {
	println("Running duplication metrics for project: <model.id>");
	
	println("Retrieving code...");
	code = getCode( model );
	linesOfCode = size(( [] | it + lines | <_,lines> <- code ));
	
	println("
			'Calculating duplicated lines of code...");
	
	duplicatedLinesOfCode = findDuplicates( code );
	
	println("
			'Duplicated lines of code: <duplicatedLinesOfCode>
			'Total lines of code:      <linesOfCode>
			'Percentage of total loc:  <percentageOf(duplicatedLinesOfCode, linesOfCode)>%
			'Rank:                     <printRank( getDuplicationRanking( linesOfCode, duplicatedLinesOfCode ) )>");	
}

private str risk( <LOC low,LOC moderate,LOC high,LOC veryHigh> ) {
	total = low + moderate + high + veryHigh;

	return  "low:       <percentageOf( low, total )>%
			'moderate:  <percentageOf( moderate, total )>%
			'high:      <percentageOf( high, total )>%
			'very high: <percentageOf( veryHigh, total )>%";
} 

