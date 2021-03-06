module Volume

// LIBRARY IMPORTS
import Prelude;
import String;
import Set;
import IO;

// M3 IMPORTS
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysis::m3::Registry;

// LOCAL IMPORTS
import Util;

alias LOC = num;

public tuple[ LOC, LOC, LOC, LOC ] sortUnitVolumes( map[ loc, LOC ] unitSizes ) {
	low      = ( 0 | it + e | e <- [ unitSizes[l] | l <- unitSizes, unitSizes[l] <= 20 ] );
 	moderate = ( 0 | it + e | e <- [ unitSizes[l] | l <- unitSizes, unitSizes[l] > 20 && unitSizes[l] <= 50 ] );
 	high     = ( 0 | it + e | e <- [ unitSizes[l] | l <- unitSizes, unitSizes[l] > 50 && unitSizes[l] <= 100 ] );
 	veryHigh = ( 0 | it + e | e <- [ unitSizes[l] | l <- unitSizes, unitSizes[l] > 100 ] );
 
	return <low, moderate, high, veryHigh>;
}

public lrel[loc,list[str]] getCode( loc project ) = getCode( createM3FromEclipseProject( project ) );
public lrel[loc,list[str]] getCode( M3 model ) {
	i          = 1;
	fs         = getFiles( model );
	totalFiles = size(fs);
	result     = [];
	
	for( location <- fs ) {
		if( totalFiles > 10 && i % (totalFiles / 10) == 0 ) println("(<percentageOf( i, totalFiles)>%) ");
		file = readFile( location );
		comments = getDocsForLocation( model, location );
		result += < location, [ l | l <- split( "\n", stripComments( file, comments ) ), ! lineIsBlank( l ) ] >;
		i  += 1;
	}
	
	return result;
}

public LOC getLOC( loc project ) = getLOC( createM3FromEclipseProject( project ) );
public LOC getLOC( M3 model ) {
	 result     = 0;
	 i          = 1;
	 fs      = getFiles( model );
	 totalFiles = size( fs );
	
	 for( location <- fs ) {
		  if( totalFiles > 10 && i % (totalFiles / 10) == 0 ) print("<percentageOf( i, totalFiles)>% ");
		  result += locMetric( readFile( location ), getDocsForLocation( model, location ) );
		  i += 1;
	 }
	 println("");
	
	 return result;
}

public str getFileStr( loc location ) {
	mmm = createM3FromFile( location );
	fileLoc = toLocation( location.uri );
	file = stripComments( readFile( fileLoc ), getDocsForLocation( mmm, fileLoc ) );
	return file;
}

public LOC getLOCFile( loc location ) {
	return locMetricUnit( getFileStr( location ), location );
}

public int getNoComments( M3 model ) = sum( [ comment.end.line - comment.begin.line + 1 | <_,comment> <- model@documentation ] );
public int getNoClasses( M3 model )  = size( classes( model ) );
public int getNoMethods( M3 model )  = sum( [ size( methods( model, c ) ) | c <- classes( model ) ] ); 

public map[ loc, LOC ] getUnitVolumes( loc project ) = getUnitVolumes( createAstsFromEclipseProject( project, true ), createM3FromEclipseProject( project ) );
public map[ loc, LOC ] getUnitVolumes( set[Declaration] decls, M3 model ) {
 	i      = 1;
 	total  = size( [ cu | cu:\compilationUnit(_,_) <- decls ] ) + size( [ cu | cu:\compilationUnit(_,_,_) <- decls ] );
 	result = ();

 	for( cu:\compilationUnit(_,types) <- decls ) {
	  	if( i % (total / 10) == 0 ) println("(<percentageOf( i, total )>%)");
	  	result = concatenateMap( result, visitCompilationUnit( cu@src, types, model ) );
		i += 1;
 	}
 
 	for( cu:\compilationUnit(_,_,types) <- decls ) {
 	 	if( total > 10 && i % (total / 10) == 0 ) println("(<percentageOf( i, total )>%)");
	  	result = concatenateMap( result, visitCompilationUnit( cu@src, types, model ) );
		i += 1;
	}

	return result;
}

private map[ loc, LOC ] visitCompilationUnit( loc file, list[Declaration] decls, M3 model ) {
	comments     = [ comment | <_,comment> <- model@documentation, file.uri == comment.uri ];
	strippedFile = stripComments( readFile( file ), comments );
	result       = (); 
	
	visit( decls ) {
	  case m: \method(_,_,_,_,_):    result[ m@src ] = locMetricUnit( strippedFile, m@src );
	  case c: \constructor(_,_,_,_): result[ c@src ] = locMetricUnit( strippedFile, c@src );
	}
	return result;
}

public list[ loc ] getDocsForLocation( M3 model, loc location ) {
	 resolvedLocation = location;
	 return [ comment | <_,comment> <- model@documentation, comment.uri == resolvedLocation.uri ];
}

public int locMetric( str file, list[ loc ] comments ) = countLines( stripComments( file, comments ) );
public int locMetricUnit( str file, loc unitLocation ) = countLines( file[(unitLocation.offset)..(unitLocation.offset + unitLocation.length)] );

// HELPER FUNCTIONS
private bool lineIsBlank( str line ) = (/^\s*$/ := line);
public int countLines( str file ) = size( [ line | line <- split( "\n", file ), ! lineIsBlank( line ) ] );
private str stripComments( str file, list[ loc ] comments ) {
	 for( comment <- comments ) file = fillWithSpaces( file, comment.offset, comment.length );
	 return file;	
}

	
