module Complexity

import Prelude;
import Util;

import lang::java::m3::AST;

alias LOC = num;
alias CC  = num;

public tuple[ LOC, LOC, LOC ] sortComplexities( map[ loc, CC ] unitComplexities, map[ loc, LOC ] unitVolumes ) {
 	moderate = ( 0 | it + e | e <- [ unitVolumes[l] | l <- unitComplexities, unitComplexities[l] > 10 && unitComplexities[l] <= 20 ] );
 	high =     ( 0 | it + e | e <- [ unitVolumes[l] | l <- unitComplexities, unitComplexities[l] > 20 && unitComplexities[l] <= 50 ] );
 	veryHigh = ( 0 | it + e | e <- [ unitVolumes[l] | l <- unitComplexities, unitComplexities[l] > 50 ] );

 	return <moderate, high, veryHigh>;
}

public map[ loc, CC ] getUnitComplexities( set[Declaration] decls ) {
 	result = ();
 	visit( decls ) {
  		case m: \method(_,_,_,_, Statement impl):    result[ m@src ] = cyclomaticComplexity( impl );
  		case c: \constructor(_,_,_, Statement impl): result[ c@src ] = cyclomaticComplexity( impl );
 	}

 	return result;
}

private num cyclomaticComplexity( Statement stat ) {
 	num result = 1;

 	visit( stat ) {
  		case \while(_, Statement body):                          result += 1;
  		case \do(Statement body, _):                             result += 1;
  		case \if(_, Statement thenBranch):                       result += 1;
  		case \if(_, Statement thenBranch, Statement elseBranch): result += 1;
  		case \foreach(_, _, Statement body):                     result += 1;
  		case \for(_, _, _, Statement body):                      result += 1;
  		case \for(_, _, Statement body):                         result += 1;
  		case \switch(_, list[Statement] statements):             result += 1;
  		case \case(Expression expression):                       result += 1;
  		case \catch(_, Statement body):                          result += 1;
  		case \infix(_,"||",_):                                   result += 1;
  		case \infix(_,"&&",_):                                   result += 1;
  		case \conditional(_,_,_):                                result += 1;
 	}

 	return result;
}
