module Util

// LIBRARY IMPORTS
import Prelude;
import String;
import util::Math;

// M3 IMPORTS
import lang::java::m3::Core;
import lang::java::m3::Registry;

// LOCAL IMPORTS
import Config;

/*
 * CLONE (TYPE) HELPERS
 */
public list[loc] cloneLocations( list[CloneClass] classes, loc file ) {
	file_clones = [];
	for( <s,clones> <- classes, clone <- clones, clone.uri == file.uri ) {
		file_clones += clone;
	}
	return file_clones;
}

/*
 * LOCATION HELPERS
 */
public int smallestLoc( set[loc] s ) = min( mapper( s, linesInLoc ) );
public int linesInLoc( loc location ) = location.end.line - location.begin.line + 1;

public loc sequenceLocation( locs:[loc l1, *loc _, loc l2] ) {
	loc result = toLocation(l1.uri);
	return result( l1.offset, l2.offset-l1.offset+l2.length, l1.begin, l2.end);
}

public set[loc] locationsOverlap( set[loc] s1, set[loc] s2 ) {
	result = {};

	for( l1 <- s1, l2 <- s2, l1.uri == l2.uri && locationsOverlap(l1,l2) ) {
		result += sequenceLocation( [l1,l2] );
	}
	
	if( size(result) == size(s1) && size(result) == size(s2) ) {
		return result;
	} else {
		return {};
	} 
}
public bool locationsOverlap( loc l1, loc l2 ) = l2.begin.line > l1.begin.line && l2.begin.line < l1.end.line && l2.end.line > l1.end.line;

public int uniqueLocations( set[loc] ls ) = size( mapper( ls, str(loc l){ return l.uri; } ) );

/*
 * STRING HELPERS
 */
public str fillWithSpaces( str text, int offset, int length ) {
	before = text[0..offset];
	after  = text[(offset + length)..];
	return before + left( "", length )  + after;
}
public str concatString( list[str] lines, str ch ) = ( "" | it + ch + l | l <- lines );

/*
 * LIST, SET & MAP HELPERS
 */
public map[ &T, &Y ] concatenateMap( map[ &T, &Y ] m1, map[ &T, &Y ] m2 ) {
	for( k <- m2 ) {
		m1[ k ] = m2[ k ];
	}
	
	return m1;
}

/*
 * NUMBER HELPERS
 */
public num percentageOf( num i, num j ) = round( (toReal(i) / toReal(j)) * 100 );

public bool less( <int i,_>, <int j,_> ) = i > j;

public &T fst( <&T x, *_> ) = x;
public &T snd( <_,&T x> ) = x;

public int average( list[num] n ) = round( sum(n)/size(n) );
public int average( set[num]  n ) = round( sum(n)/size(n) );

public lrel[value,num] maxRange( map[ value, num ] m ) {
	r = range( m );
	if( ! isEmpty( r ) ) return [ <k,max(r)> | k <- m, m[k] == max( r ) ];
	else                 return [];
}

/*
 * M3 HELPERS
 */
public set[loc] getFiles( M3 mmm ) {
	result = {};
	
	for( <l,t> <- mmm@declarations ) {
		if( isCompilationUnit( l ) ) {
			result += t;
		}
	}
	
	return result;
}