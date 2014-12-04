module Main

import Prelude;
import ListRelation;

import lang::java::m3::AST;
import lang::java::jdt::m3::AST;

anno int Declaration@children;
anno int Statement@children;
anno int Expression@children;

anno loc node@src;

public int MassTreshold = 20;

public loc singleFile = |file:///Users/matthisk/Repositories/SoftwareEvolution/schets/src/SchetsApplet.java|;

public set[Declaration] createAsts( loc l ) = { createAstFromFile( l, true ) };
public set[Declaration] createAsts() = createAstsFromEclipseProject(|project://schets|,true);

public map[node,set[loc]] findDups( map[node,set[loc]] m ) = ( k:m[k] | k <- m, size(m[k]) > 1 && mass(k) > MassTreshold );

public int mass( node n ) {
	int r = 1;
	
	visit( n ) {
		case node _: r += 1;
	}
	
	return r;
}

public map[node, set[loc]] hashMapAst( set[Declaration] ast ) {
	map[node, set[loc]] m = ();
	
	visit( ast ) {
		case Declaration n: m[n] = n in m ? m[n] + getLoc(n) : {getLoc(n)};
		case Statement n:   m[n] = n in m ? m[n] + getLoc(n) : {getLoc(n)}; 
		case Expression n:  m[n] = n in m ? m[n] + getLoc(n) : {getLoc(n)};
	}

	return m;
} 

public set[Declaration] generalizeNames( set[Declaration] ast ) {
	return visit( ast ) {
		case n:\enum(str name, list[Type] i, list[Declaration] c, list[Declaration] b) => \enum("enum",i,c,b)[@src=n@src]
		case n:\enumConstant(str name, list[Expression] a, Declaration c) => \enumConstant("enumConst",a,c)[@src=n@src]
		case n:\enumConstant(str name, list[Expression] a) => \enumConstant("enumConst",a)[@src=n@src]
		case n:\class(str name, list[Type] e, list[Type] i, list[Declaration] b) => \class("class",e,i,b)[@src=n@src]
		case n:\interface(str name, list[Type] e, list[Type] i, list[Declaration] b) => \interface("interface", e, i, b )[@src=n@src]
		case n:\method(Type r:\return, str name, list[Declaration] p, list[Expression] e, Statement i) => \method( r, "method", p, e, i)[@src=n@src]
		case n:\method(Type r:\return, str name, list[Declaration] p, list[Expression] e) => \method( r, "method", p, e )[@src=n@src]
		case n:\constructor(str name, list[Declaration] p, list[Expression] e, Statement i) => \constructor("constructor", p, e, i)[@src=n@src]
		case n:\typeParameter(str name, list[Type] e) => \typeParameter("typeParameter", e )[@src=n@src]
		case n:\annotationType(str name, list[Declaration] b) => \annotationType("annotationType", b)[@src=n@src]

		case n:\variable(str name, int e) => \variable("var", e)[@src=n@src]
		case n:\variable(str name, int e, Expression i:\initializer) => \variable("var", e, i)[@src=n@src]
		case n:\simpleName(str name) => \simpleName("name")[@src=n@src]
		case n:\memberValuePair(str name, Expression v:\value) => \memberValuePair("memberValuePair", v)[@src=n@src]          
  
		case n:\label(str name, Statement b) => \label("label", b)[@src=n@src]
    }
}

public list[node] simpleAst( set[Declaration] ast ) {
	result = [];
	
	for( decl <- ast ) {
		result += getName( decl )( childrenAst( decl ) );
	}
	
	return result;
} 

public list[node] childrenAst( Declaration n ) {
	println( n );
	children = concat( getChildren( n ) );
	result   = [];
	
	for( child <- children ) {
		result += getName( child )( childrenAst( child ) );
	}
	
	return result;
}
public default list[node] childrenAst( value v ) = [v];

public list[str] convertAst( set[Declaration] ast ) {
	annotatedAst = annotateNoChildren( ast );
	result = [];

	top-down visit( annotatedAst ) {
		case Declaration d : result += (getName(d) + toString(d@children));//()[@src = getLoc(d)];
		case Statement d : result +=   (getName(d) + toString(d@children));//()[@src = getLoc(d)];
		case Expression d : result +=  (getName(d) + toString(d@children));//()[@src = getLoc(d)];
	}
	
	return result;
}

private loc getLoc( node d ) { 
	if( Declaration n := d || Statement n := d || Expression n := d ) {
		try return n@src; catch NoSuchAnnotation(_): return |project://schets|;
	} else {
		return |project://schets|;
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

private value children( node n ) { try return n@children; catch NoSuchAnnotation(_): return 0; }
