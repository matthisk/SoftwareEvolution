module Util

import Prelude;
import String;
import util::Math;
import lang::java::m3::Core;

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

public int average( list[num] n ) = round( sum(n)/size(n) );
public int average( set[num]  n ) = round( sum(n)/size(n) );

public str concatString( list[str] lines, str ch ) = ( "" | it + ch + l | l <- lines );

public set[loc] myFiles( M3 mmm ) {
	visit( mmm@containment ) {
		case c: \compilationUnit(l,_): println(l);
	}
	
	return {};
}