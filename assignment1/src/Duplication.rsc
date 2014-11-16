module Duplication

import Prelude;
import String;
import IO;

import Util;

public int findDuplicates( list[str] ls ) {
	list[ str ] lines = mapper( ls, trim );
	list[ list[ bool ] ] dupMatrix = createDuplicateMatrix( lines );
	
	return findDuplicateLines( dupMatrix );
}

public int findDuplicateLines( list[list[bool]] dupMatrix ) {
	result    = 0;
	diagonals = getDiagonals( dupMatrix );
	
	for( diagonal <- diagonals ) {
		result += dupBlocks( diagonal );
	}
	
	return result;
}

public int dupBlocks( list[bool] diagonal ) {
	int result = 0;
	int i = 0;
	
	for( match <- diagonal ) {
		if( match ) {
			i += 1;
		}
		
		if( ! match && i >= 6 ) {
			result += i;
		}
		
		if( ! match ) {
			i = 0;
		}
	}
	
	return result;
}

public list[list[bool]] getDiagonals( list[list[bool]] matrix ) {
	dr = for( int y <- [size(matrix)..1] ) {
		append getDiagonalsRow( matrix, y );
	}
	
	dc = for( int x <- [1..size(matrix)] ) {
		append getDiagonalsColumn( matrix, x );
	}
	
	return dr + dc;
}

public list[bool] getDiagonalsRow( list[list[bool]] matrix, int row ) = [ matrix[row + i][i] |int i <- [0..( size(matrix) - row )] ];
public list[bool] getDiagonalsColumn( list[list[bool]] matrix, int column ) = [ matrix[column + j][j] | int j <- [0..( size(matrix) - column)] ];


public list[list[bool]] createDuplicateMatrix( list[str] lines ) {
	return
	 for( int x <- [0..size( lines )] ) {
		append
		 for( int y <- [0..size( lines )] ) {
		     append x != y && lines[x] == lines[y];
		 }
	 }
}