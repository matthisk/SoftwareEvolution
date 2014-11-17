module Duplication

import Prelude;
import ListRelation;
import String;
import IO;

import Util;

public int findDuplicates( list[str] ls ) {
	lines = mapper( ls, trim );
	dups  = {};
	hash  = index( createBlocks( lines ) );
	hash  = ( k:hash[k] | k <- hash, size( hash[k] ) > 1 );
	
	for( k <- hash ) {
		for( <s,e> <- hash[k] ) {
			for( i <- [s..(e+1)] ) dups += i;
		}
	}
	
	return size( dups );
}

public lrel[list[str],tuple[int,int]] createBlocks( list[str] lines ) {
	blockSize = 6;
	blocks    = [];
	
	next = lines[0..blockSize];
	blocks += <next,<0,blockSize-1>>;
	
	for( i <- [1..(size(lines) - (blockSize-1))] ) {
		if( i % (size(lines)/10) == 0 ) println("(<percentageOf(i,size(lines))>%)");
		next = tail(next);
		next += lines[i+blockSize-1];
		
		blocks += <next,<i,i+blockSize-1>>;
	}
	
	return blocks;
}