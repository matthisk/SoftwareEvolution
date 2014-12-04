module Test

import Prelude;

import STree2;

private list[str] strToList( str s ) = tail( split( "", s ) );

// Expect true
public test bool testIsTword1() {
	l = < strToList("acg"),0>;
	t  = Branch( [<<strToList("c"),0>,Leaf()>, <<strToList("a"),0>,Leaf()>, <<strToList("a"),0>,Leaf()>] );

	return isTword( l, t );
}

// Expect false
public test bool testIsTword2() {
	l = < strToList("agcgacgag"), 3 >;
	t = Branch([ << strToList("agga"), 0>,Leaf()> ]);
	
	return ! isTword( l, t );
}

// Expect true
public test bool testIsTword2() {
	l = < strToList("agcgacgag"), 3 >;
	t = Branch([ << strToList("aggg"), 0>,Leaf()> ]);
	
	return isTword( l, t );
}

public test bool testUpdate1() {
	t = update( <Branch([ <<[3],0>,Leaf()>, <<[2],0>,Leaf()>, <<[1],0>,Leaf()> ]), <[1,2,3],0>> );
	
	if( <root,<s,slen>> := t ) return slen == 1;
}

public test bool testUpdate2() {
	t = update( <Branch([ <<[3],0>,Leaf()>, <<[2],0>,Leaf()> ]), <[1,2,3],0>> );
	
	if( <root,<s,slen>> := t ) {
		return s == [2,3] && slen == 0;
	}
}



//public test bool testNaiveOnline() {
//	t = naiveOnline( strToList("agcgacgag") );
//
//	if( Branch([ <<["a",*_],1>es1>, <<["c","g","a",*_],3>,es2>, <<["g",*_],1>,es3> ]) := t ) {		
//		test1 = Branch([ <<["c","g","a","g",*_],4>,Leaf()>, <<["g","c","g","a","c","g","a","g"],_>_>,Leaf()> ]) := es1;
//		test2 = Branch([ <<["c","g","a","g",*_],4>Leaf()>, <<["g",*_],1>,Leaf()> ]) := es2;
//		if( test1 && test2 && Branch([ <<["a",*_],_>,bs1>, <<["c","g","a","c","g","a","g"],7>,Leaf()> ]) := es3 ) {
//			return true;
//		}
//	}
//}
