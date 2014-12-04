module STree2

import Prelude;

data STree[&alf] = Leaf()
		         | Branch( lrel[Label[&alf],STree[&alf]] );
alias Label[&alf] = tuple[list[&alf], int];
alias EdgeFunction[&alf] = tuple[int, list[list[&alf]]] (list[list[&alf]]);

public bool isTword( <list[&alf] aw:[a,*w],0>,    STree[&alf] _:Branch(es) ) = [] != [ 0 | <<[c,*_],_>,_> <- es, a == c];
public bool isTword( <list[&alf] aw:[a,*w],wlen>, STree[&alf] _:Branch(es) ) {
	if( wlen < 1 ) throw IllegalArgument(wlen, "Wlen has to be bigger than 0");
	
	wlen -= 1;
	for( <<[c,*u],culen>,n> <- es, a == c  ) {
		ulen = culen-1;
		if( Leaf := n || wlen < ulen ) return w[wlen] == u[wlen];
		else                           return isTword( <drop( ulen, w ),wlen-ulen>, n );	
	}
	
	return false;
}

public tuple[STree[&alf], Label[&alf]] update( <STree[&alf] root, <list[&alf] s, int slen>> ) {
	if( isTword( <s,slen>, root ) ) return <root, <s,slen+1>>;
	elseif( 0 == slen ) {
		Label[&alf] l = <tail(s), 0>; // If we dont do this Rascal's type system is complaining	
		return <insRelSuff( <s,slen>, root ), l>;
	}
	else {
		Label[&alf] l = <tail(s), slen-1>;
		return update( <insRelSuff( <s,slen>, root ), l> );
	}
} 

private lrel[Label[&alf],STree[&alf]] g1( <list[&alf] aw:[a,*w],_>, [] ) = [<<aw,size(aw)>,Leaf()>];
private lrel[Label[&alf],STree[&alf]] g1( <list[&alf] aw:[a,*w],slen>, [cusn:<<[c,*u],culen>,n>, *es] ) {
	if( a > c ) return push( cusn, g1( <aw,slen>, es) );
	else        return [ <<aw,size(aw)>,Leaf()>, cusn ] + es;
}

private lrel[Label[&alf],STree[&alf]] g2( <list[&alf] aw:[a,*w],slen>, [] ) = [<<aw,size(aw)>,Leaf()>];
private lrel[Label[&alf],STree[&alf]] g2( <list[&alf] aw:[a,*w],slen>, [cusn:<cus:<cu:[c,*_], culen>, n>, *es] ) {
	x = drop(slen, cu);
	y = drop(slen, aw);
	ey = <<y, size(y)>,Leaf()>;
	ex = Leaf() := n ? <<x,size(x)>,Leaf()> : <<x,culen-slen>,n>;

	if( a != c ) return push( cusn, g2( <aw,slen>, es ) );
	elseif( Leaf() !:= n && slen >= culen ) return push( <cus,insRelSuff( <drop( culen, aw ), slen-culen>, n )>, es );
	elseif( head( x ) < head( y ) ) return push( <<cu,slen>,Branch( [ex, ey] )>, es );
	else                            return push( <<cu,slen>,Branch( [ey, ex] )>, es );
}

public STree[&alf] insRelSuff( <aw:[&alf a,*&alf w],0>, STree[&alf] _:Branch(es) ) = Branch( g1( <aw,0>, es ) );
public STree[&alf] insRelSuff( <aw:[&alf a,*&alf w],slen>, STree[&alf] _:Branch(es) ) = Branch( g2( <aw,slen>, es ) );

public STree[&alf] naiveOnline( list[&alf] t ) {
	root = Branch( [] );
	tuple[list[&alf] s, int slen] label = <t,0>;

	while( true ) {
		if( drop( label.slen, label.s ) == [] ) {
			break;
		}
	
		println("updating label, items left: <size(label.s)>");
		if( <n,<s,slen>> := update( <root, label> ) ) {
			root = n;
			label = <s,slen>;
		}
	}
	
	return root;
}