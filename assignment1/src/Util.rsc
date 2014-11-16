module Util

import Prelude;
import String;
import util::Math;

public num percentageOf( num i, num j ) = round( (i / j) * 100 );

public lrel[value,num] maxRange( map[ value, num ] m ) {
	r = range( m );
	if( ! isEmpty( r ) ) return [ <k,max(r)> | k <- m, m[k] == max( r ) ];
	else                 return [];
}

public str fillWithSpaces( str text, int offset, int length ) {
	before = text[0..offset];
	after  = text[(offset + length)..];
	return before + left( "", length )  + after;
}

public map[ &T, &Y ] concatenateMap( map[ &T, &Y ] m1, map[ &T, &Y ] m2 ) {
	for( k <- m2 ) {
		m1[ k ] = m2[ k ];
	}
	
	return m1;
}

public str concatString( list[str] lines, str ch ) = ( "" | it + ch + l | l <- lines );