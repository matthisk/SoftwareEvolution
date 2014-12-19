module Main

// Library imports
import Prelude;
import ListRelation;

// M3 imports
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

// Local imports
import output::Text;
import output::JSON;
import Config;
import Util;
import Volume;
import Clones;

public loc hsqldb          = |project://hsqldb|;
public loc smallsql        = |project://smallsql|;
public loc schets          = |project://schets|;
public loc singleFile      = |file:///Users/matthisk/Repositories/SoftwareEvolution/schets/src/SchetsApplet.java|;
public loc testDuplication = |project://test/src/test/Duplication.java|;

@doc{
	Rascal CLone Detector
	---------------------
	
	The algorithm used in the clone detector is loosely based on the work by Ira Baxter in his paper "Clone detection using abstract syntax trees"
	To detect clones the program generates Abstract Syntax Trees(AST) and hash maps of all subtrees. The detector is also
	capable in detecting sequence clones (which are a list of sibling nodes in the AST). 
	
	Motivation
	----------
	The choice to use ASTs is to be able to detect type2 clones. And to make the code more reusable (different programming languages). Separation of
	concerns is very important for the project. This is why the clones are exported as a json file so any other program could be able to consume
	this data an visualize/manipulate it. Focus of the tool lies on clean representation of the data in a human readable fashion. The detection algorithm
	is separated from the rest of the code, so even though it is not perfect the rest of the tool can still operate. 
	
	Design:
	-------
	The detector is divided in several modules, this module handles a users request to detect clones for a certain eclipse project,
	and generates meta data used when presenting the results to the user. The actual clone detection algorithm is found in the Clones module.
	Output is generated in two ways a readable text file, and a JSON file. The modules in the output folder handle these operations. Volume contains
	methods to detect lines of code for locations. Utility functions (mostly to maniluplate locations) are found in Util. And finally some configuration
	values can be set in the Config module. Consult each module for additional documentaton, especially the Clones module to get more information on the
	clone detection algorithm. Unit tests can be found in the Test module (they use some sample java files found in the test eclipse project)
	
	A seperate program is delivered which visualizes the JSON report using HTML and JS. See this program for additional documentation on the visualization.
}
public tuple[list[CloneClass],map[str,value]] detectClones( loc l ) = detectClones( createM3FromEclipseProject( l ) );
public tuple[list[CloneClass],map[str,value]] detectClones( M3 mmm ) {
	strt    = now();
	fs      = getFiles( mmm );
	totalFs = size( fs );
	
	println("(1/5) Creating AST clone map");
	cloneMaps = generateCloneMaps( fs, totalFs );
	astCloneMap = fst( cloneMaps );
	sequenceCloneMap = snd( cloneMaps );
	
	println("(2/5) Calculating subsumed AST clones");
	astCloneMap      = subsumeAstClones( astCloneMap );
	
	println("(3/5) Calculating subsumed sequence clones");
	sequenceCloneMap = subsumeSequenceClones( sequenceCloneMap );
	
	println("(4/5) Calculating sequence clones subsumed by AST clones");
	sequenceCloneMap = subsumeClones( astCloneMap, sequenceCloneMap );
	cloneClasses = createClones( astCloneMap ) + createClones( sequenceCloneMap );
	
	println("(5/5) Generating meta data");
	meta                 = generateMetaData( mmm, cloneClasses, fs, totalFs );
	meta["created_at"]   = strt;
	meta["elapsed_time"] = createDuration( strt, now() );
	
	if( OUTPUT_TO_FILES ) {
		outputText( cloneClasses, meta, console = false );
		outputJSON( cloneClasses, meta );
	}
	
	return <cloneClasses, meta>;
}

private tuple[CloneMap[node],CloneMap[list[node]]] generateCloneMaps( set[loc] fs, int totalFs ) {
	astCloneMap      = ();
	sequenceCloneMap = ();
	i                = 0;
	
	for( file <- fs ) {
		if( i % (totalFs / 10) == 0 ) print("<percentageOf(i,totalFs)>% "); 
		ast = generalizeNames( createAstFromFile( file, true ) );
		
		astCloneMap      = findAstClones( ast, astCloneMap );
		sequenceCloneMap = findSequenceClones( ast, sequenceCloneMap );
	
		i += 1;
	}
	println("");
	
	return <astCloneMap, sequenceCloneMap>;
}

private map[str,value] generateMetaData( M3 mmm, list[CloneClass] cloneClasses, set[loc] fs, int totalFs ) {
	map[str,value] meta = ();
	file_locations = toList( fs );
	
	meta["number_of_files"] = totalFs;
	i = 0;
	loadedFiles = ();
	for( f <- file_locations ) {
		if( i % ( totalFs*2 / 10 ) == 0 ) print("<percentageOf(i,totalFs*2)>% ");
		i += 1;
		loadedFiles[f.uri] = getFileStr(f);
	}
	meta["file_sizes"] = for( k <- loadedFiles ) append countLines( loadedFiles[k] );
	meta["file_clone_sizes"] = for( f <- file_locations ) {
		if( i % ( totalFs*2 / 10 ) == 0 ) print("<percentageOf(i,totalFs*2)>% ");
		locations = cloneLocations( cloneClasses, f );
		i += 1;
		append ( 0 | it + locMetricUnit( loadedFiles[l.uri], l ) | l <- locations );
	}
	println("");

	meta["project_name"] = mmm.id;
	meta["file_locations"] = file_locations;
	meta["lines_of_code"] = sum(meta["file_sizes"]);
	meta["lines_of_clones"] = sum(meta["file_clone_sizes"]);
	meta["percentage_of_clones"] = percentageOf(meta["lines_of_clones"],meta["lines_of_code"]);
	
	return meta;
}