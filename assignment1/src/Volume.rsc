module Volume

import Prelude;
import String;
import Set;
import IO;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import analysis::m3::Registry;

import Util;

alias LOC = num;

public tuple[ LOC, LOC, LOC, LOC ] sortUnitVolumes( map[ loc, LOC ] unitSizes ) {
	low      = ( 0 | it + e | e <- [ unitSizes[l] | l <- unitSizes, unitSizes[l] <= 20 ] );
 	moderate = ( 0 | it + e | e <- [ unitSizes[l] | l <- unitSizes, unitSizes[l] > 20 && unitSizes[l] <= 50 ] );
 	high     = ( 0 | it + e | e <- [ unitSizes[l] | l <- unitSizes, unitSizes[l] > 50 && unitSizes[l] <= 100 ] );
 	veryHigh = ( 0 | it + e | e <- [ unitSizes[l] | l <- unitSizes, unitSizes[l] > 100 ] );
 
	return <low, moderate, high, veryHigh>;
}

public list[str] getCode( M3 model ) {
	i          = 1;
	fs         = files( model );
	totalFiles = size(fs);
	ls         = [];
	
	for( location <- files( model ) ) {
		if( i % (totalFiles / 10) == 0 ) println("(<percentageOf( i, totalFiles)>%) ");
		file = readFile( location );
		comments = getDocsForLocation( model, location );
		ls += [ l | l <- split( "\n", stripComments( file, comments ) ), ! lineIsBlank( l ) ];
		i  += 1;
	}
	
	return ls;
}

public LOC getLOC( loc project ) = getLOC( createM3FromEclipseProject( project ) );
public LOC getLOC( M3 model ) {
	 result     = 0;
	 i          = 1;
	 fs      = files( model );
	 totalFiles = size( fs );
	
	 for( location <- fs ) {
		  if( i % (totalFiles / 10) == 0 ) println("(<percentageOf( i, totalFiles)>%) ");
		  result += locMetric( readFile( location ), getDocsForLocation( model, location ) );
		  i += 1;
	 }
	
	 return result;
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
 	 	if( i % (total / 10) == 0 ) println("(<percentageOf( i, total )>%)");
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
	 resolvedLocation = resolveM3( location );
	 return [ comment | <_,comment> <- model@documentation, resolvedLocation.uri == comment.uri  ];
}

private int locMetric( str file, list[ loc ] comments ) = countLines( stripComments( file, comments ) );
private int locMetricUnit( str file, loc unitLocation ) = countLines( file[(unitLocation.offset)..(unitLocation.offset + unitLocation.length)] );

// HELPER FUNCTIONS
private bool lineIsBlank( str line ) = (/^\s*$/ := line);
private int countLines( str file ) = size( [ line | line <- split( "\n", file ), ! lineIsBlank( line ) ] );
private str stripComments( str file, list[ loc ] comments ) {
	 for( comment <- comments ) file = fillWithSpaces( file, comment.offset, comment.length );
	 return file;	
}

	
