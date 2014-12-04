module STree

import Prelude;


data STree[&alf] = Leaf()
		         | Branch( lrel[Label[&alf],STree[&alf]] );
alias Label[&alf] = tuple[list[&alf], int];
alias EdgeFunction[&alf] = tuple[int, list[list[&alf]]] (list[list[&alf]]);

public STree[str]   lazyTree( EdgeFunction[str]  edge, str alpha, str t ) = lazyTree( edge, tail( split( "", alpha ) ), tail( split( "", t ) ) );
public STree[value] lazyTree( EdgeFunction[&alf] edge, list[&alf] alpha, list[&alf] t ) {
	suff = suffixes( t );
	
	return sTr( suff, edge, alpha );
}

public STree[&alf] sTr( [[]], EdgeFunction[&alf] _, list[&alf] _ ) = Leaf();
public STree[&alf] sTr( list[list[&alf]] ss, EdgeFunction[&alf] edge, list[&alf] alpha ) = Branch( [ <<push(a,sa), 1+cpl>, sTr( ssr, edge, alpha )> | a <- alpha, 
																																		              [sa,*ssa] <- [select(ss, a)], 
																																		              <cpl,ssr> <- [edge(push(sa,ssa))] ] );

public list[list[&alf]] select( list[list[&alf]] ss, &alf a ) = [ u | [c,*u] <- ss, a == c];

public list[list[&alf]] suffixes( list[&alf] aw ) {
	result = [];
	for( i <- [0..(size(aw)-1)] ) {
		aw = tail( aw );
		result = push(aw, result);
	}
	
	return result;
}

public STree[value] lazy_ast( list[&alf] alpha, list[&alf] t ) = lazyTree( edge_ast, alpha, t );
public STree[value] lazy_pst( list[&alf] alpha, list[&alf] t ) = lazyTree( edge_pst, alpha, t );
public STree[value] lazy_cst( list[&alf] alpha, list[&alf] t ) = lazyTree( edge_cst, alpha, t );

public tuple[int, list[list[&alf]]] edge_ast( list[list[&alf]] ss ) = <0,ss>;

public tuple[int, list[list[&alf]]] edge_pst( list[list[&alf]] ss ) {
	g = elimNested( ss );
	
	if( [s] := g ) return <size(s), [[]]>;
	
	return <0,ss>;
}

public list[list[&alf]] elimNested( [s] ) = [s];
public list[list[&alf]] elimNested( awss:[ [a, *w] , *ss ] ) {
	if( [] := [0 | [c,*_] <- ss, a != c] ) return [push(a,s) | s <- elimNested(push(w,[u | [_,*u]<-ss]))];
	else								   return awss;
}

public tuple[int, list[list[&alf]]] edge_cst( [s] ) = <size(s),[[]]>;
public tuple[int, list[list[&alf]]] edge_cst( awss:[ [a, *w], *ss ] ) {

	if( [] := [0 | [c,*_] <- ss, a != c] ) {
		tuple[int cpl,list[list[&alf]] rss] t = edge_cst( push(w, [u | [_,*u]<-ss]) );
		return <1+t.cpl,t.rss>;
	}
	else {
		return <0,awss>;
	}
}