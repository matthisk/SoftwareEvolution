module Main

// Library imports
import Prelude;
import ListRelation;

// M3 imports
import lang::java::m3::AST;
import lang::java::jdt::m3::AST;

// Local imports
import Config;
import Output;

anno int Declaration@children;
anno int Statement@children;
anno int Expression@children;

anno loc node@src;

public loc hsqldb          = |project://hsqldb|;
public loc smallsql        = |project://smallsql|;
public loc schets          = |project://schets|;
public loc singleFile      = |file:///Users/matthisk/Repositories/SoftwareEvolution/schets/src/SchetsApplet.java|;
public loc testDuplication = |project://test/src/test/Duplication.java|;

public set[Declaration] createAstsF( loc l ) = { createAstFromFile( l, true ) };
public set[Declaration] createAstsE( loc l ) = createAstsFromEclipseProject(l,true);

public void calculateDuplicates( loc l ) = calculateDuplicates( createAstsFromEclipseProject( l, true ) );
public void calculateDuplicates( set[Declaration] ast ) {
	gAst     = annotateNoChildren( generalizeNames( ast ) );
	clones   = findAstClones( gAst );
	sequence = findSequenceClones( gAst );
	
	println("Normal Clones");
	for( cloneClass <- clones ) {
		println( cloneClass );
	}
	
	println("
			'Sequence Clones");
	for( cloneClass <- sequence ) {
		println( cloneClass );
	}
}

public map[node,set[loc]] groupDups( map[node,set[loc]] m ) {
	
	for( k <- m ) {
		visit( getChildren(k) ) {
			case node n: if(n in m) m[n] = removeContainedLocs( m[n], m[k] );
		}
	}
	
	return filterClones( m );
}

public set[loc] removeContainedLocs( set[loc] s1, set[loc] s2 ) = { l1 | l1 <- s1, ! any(l2 <- s2, l1 < l2) };

public set[loc] removeSameFile( set[loc] s1, set[loc] s2 ) = { l | l <- s2, l.uri notin mapper(s1,getUri) };
public str getUri( loc l ) = l.uri;

public map[node,set[loc]] filterTreshold( map[node,set[loc]] m ) = ( k:m[k] | k <- m, withinTreshold(k) );
public map[&K,set[loc]] filterClones( map[&K,set[loc]] m ) = ( k:m[k] | k <- m, size(m[k]) > 1 );

public bool withinTreshold( node n ) {
	if( Declaration d := n || Statement d := n || Expression d := n ) {
		try return d@children > MASS_TRESHOLD; catch NoSuchAnnotation(_): return false;
	} else {
		return false;
	}
}

public set[set[loc]] findAstClones( set[Declaration] ast ) {
	return range( groupDups( filterTreshold( hashMapAst( ast ) ) ) );
}

public map[node, set[loc]] hashMapAst( set[Declaration] ast ) {
	map[node, set[loc]] m = ();
	
	visit( ast ) {
		case Declaration n: m[n] = n in m ? m[n] + getLoc(n) : {getLoc(n)};
		case Statement n:   m[n] = n in m ? m[n] + getLoc(n) : {getLoc(n)};
		case Expression n:  m[n] = n in m ? m[n] + getLoc(n) : {getLoc(n)};
	}

	return filterClones( m );
} 

public set[set[loc]] findSequenceClones( set[Declaration] ast ) {
	map[list[node],set[loc]] m = ();
	
	visit( ast ) {
		case n:\block(list[Statement] statements): m = createSequences( n, statements, m );
	}
	
	m = ( k:m[k] | k <- m, size(m[k]) > 1 );
	
	for( k1 <- m, k2 <- m, k1 != k2 && k2 < k1 ) {
		m[k2] = removeContainedLocs( m[k2], m[k1] );
	}
	
	return range( filterClones( m ) );
}

public map[list[node],set[loc]] createSequences( node parent, list[node] c, map[list[node],set[loc]] m ) {
	for( i <- [0..size(c)], j <- [MIN_SEQUENCE_LENGTH..MAX_SEQUENCE_LENGTH] ) {
		if( i + j <= size(c) ) {
			s = c[i..(i+j)];
			m[s] = s in m ? m[s] + sequenceLocation(mapper(s,getLoc)) : {sequenceLocation(mapper(s,getLoc))};
		} 
	}
	
	return m;
}

public loc sequenceLocation( locs:[loc l1, *loc _, loc l2] ) {
	loc result = toLocation(l1.uri);
	return result(l1.offset,l2.offset-l1.offset+l2.length,l1.begin,l2.end);
}

public set[Declaration] generalizeNames( set[Declaration] ast ) {
	return visit( ast ) {
		case n:\enum(str name, list[Type] i, list[Declaration] c, list[Declaration] b) => setAnnotations( \enum("enum",i,c,b), getAnnotations( n ) )
		case n:\enumConstant(str name, list[Expression] a, Declaration c) => setAnnotations( \enumConstant("enumConst",a,c), getAnnotations( n ) )
		case n:\enumConstant(str name, list[Expression] a) => setAnnotations( \enumConstant("enumConst",a), getAnnotations( n ) )
		case n:\class(str name, list[Type] e, list[Type] i, list[Declaration] b) => setAnnotations( \class("class",e,i,b), getAnnotations( n ) )
		case n:\interface(str name, list[Type] e, list[Type] i, list[Declaration] b) => setAnnotations( \interface("interface", e, i, b ), getAnnotations( n ) )
		case n:\method(Type r:\return, str name, list[Declaration] p, list[Expression] e, Statement i) => setAnnotations( \method( r, "method", p, e, i), getAnnotations( n ) )
		case n:\method(Type r:\return, str name, list[Declaration] p, list[Expression] e) => setAnnotations( \method( r, "method", p, e ), getAnnotations( n ) )
		case n:\constructor(str name, list[Declaration] p, list[Expression] e, Statement i) => setAnnotations( \constructor("constructor", p, e, i), getAnnotations( n ) )
		case n:\typeParameter(str name, list[Type] e) => setAnnotations( \typeParameter("typeParameter", e ), getAnnotations( n ) )
		case n:\annotationType(str name, list[Declaration] b) => setAnnotations( \annotationType("annotationType", b), getAnnotations( n ) )

		case n:\variable(str name, int e) => setAnnotations( \variable("var", e), getAnnotations( n ) )
		case n:\variable(str name, int e, Expression i:\initializer) => setAnnotations( \variable("var", e, i), getAnnotations( n ) )
		case n:\simpleName(str name) => setAnnotations( \simpleName("name"), getAnnotations( n ) )
		case n:\memberValuePair(str name, Expression v:\value) => setAnnotations( \memberValuePair("memberValuePair", v), getAnnotations( n ) )          
  
		case n:\label(str name, Statement b) => setAnnotations( \label("label", b), getAnnotations( n ) )
    }
}

private loc getLoc( node d ) { 
	if( Declaration n := d || Statement n := d || Expression n := d ) {
		try return n@src; catch NoSuchAnnotation(_): return |project://undefined|;
	} else {
		return |project://undefined|;
	} 
}

public set[Declaration] annotateNoChildren( set[Declaration] ast ) {
	return
	bottom-up visit( ast ) {
		case node d => d[@children = getNoChildren( d )]
	}
}

private int getNoChildren( node n ) {
	result = 0;

	visit( n ) {
		case node _ : result += 1;
	}
	
	return result;
}
