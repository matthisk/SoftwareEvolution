module Duplication

import Prelude;
import ListRelation;
import String;
import IO;

import Util;

@doc {
	For a relation location -> lines of code, find the duplicated lines of code
	This is done by computing the hash of all blocks of 6 lines and looking which
	hash value has multiple locations (i.e. duplication)
	
	Because we also want know where the duplication is located we have to transform the data structure slightly,
	to finally display all the lines that contian duplicated code
}
public int findDuplicates( lrel[ loc, list[str] ] ls ) {
	lines  = [ <l,mapper( code, trim )> | <l,code> <- ls ];
	blocks = ( [] | it + createBlocks( file ) | file <- lines );
	hash   = createHash( blocks );
	dups   = ();
	
	for( k <- hash ) {
		for( location <- hash[k] ) {
			s = location.begin.line; e = location.end.line;
			if( location.uri notin dups ) dups[ location.uri ] = {};
			dups[ location.uri ] = dups[ location.uri ] + <s,e>;
		}
	}
	
	dups = ( l:normalizeDupLines(dups[l]) | l <- dups );
	return calculateDuplicatedLines( dups );
}

private int calculateDuplicatedLines( map[str,rel[int,int]] dups ) {
	result = 0;
	
	for( l <- dups ) {
		println("Source: <l>");
		println("<dups[l]>");
		for( <s,e> <- dups[l] ) result += (e - s) + 1; 
	}
	
	return result;
}

private map[list[str],set[loc]] createHash( lrel[ list[str], loc ] blocks ) {
	hash = index( blocks );
	return ( k:hash[k] | k <- hash, size( hash[k] ) > 1 );
}

private lrel[ list[str], loc ] createBlocks( <loc file,list[str] lines> ) {
	if( size( lines ) < 6 ) return [];
	
	blockSize = 6;
	blocks    = [];
	
	next = lines[0..blockSize];
	blocks += <next, file(0,0,<0,0>,<blockSize-1,0>)>;
	
	for( i <- [1..(size(lines) - (blockSize-1))] ) {
		next = tail(next);
		next += lines[i+blockSize-1];
		 
		blocks += <next, file(0,0,<i,0>,<i+blockSize-1,0>)>;
	}
	
	return blocks;
}