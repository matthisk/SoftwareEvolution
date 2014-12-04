module Ukkonen

import Prelude;

alias Active = tuple[Node, Edge, int];
alias Edge = lrel[Pos,Pos,STree];
data Pos   = Pos(int)
		   | Last();
data STree = Node( Edge )
		   | Leaf();

private STree addEdge( Node( edges ), Edge e ) = Node( edges + e );
public Edge findSuffix( Active point, str input, str s ) {
	result = [];
	
	if( Node( edges ) := t ) {

		for( tuple[int i,STree t] edge <- edges, input[edge.i] == s ) {
			result = [edge];
			break;
		}
	}
	
	return result;
}

public STree construct( str input ) {
	input += "$";
	STree root = Node([]);
	
	Active point = <root, [], 0>;
	int remainder = 1;
	int sEndSuffix = 0;
	
	for( sEnd <- [0..size( input )] ) {
		println("Iteration <sEnd>");
	
		for( sStart <- [(sEnd-remainder+1)..(sEnd+1)] ) {
			println("The next suffix of <input> to add is <input[sStart..sEnd]>{<input[sEnd]>} at indices <sStart>,<sEnd>");
			println("=\> Active node <point.n>");
			println("=\> Active edge <point.edge>");
			println("=\> Active length <point.length>");
			edge = findSuffix( point, input, input[sStart] );
			
			if( size(edge) > 0 ) {
				point = <point.n, edge, point.length + 1>;
				remainder += 1;
				
			} else {
				root = addEdge( root, [<sEnd,Leaf()>] );
				point.n = root;	
			}
		}
		
		println("
				'Tree: <root>
				'");
	}
	
	return root;
}
