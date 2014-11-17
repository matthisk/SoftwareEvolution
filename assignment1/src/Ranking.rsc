module Ranking

import Util;

alias LOC = num;

public str printRank( 1 ) = "++";
public str printRank( 2 ) = "+";
public str printRank( 3 ) = "o";
public str printRank( 4 ) = "-";
public str printRank( 5 ) = "--";
public default str printRank( _ ) = "";

public int getVolumeRanking( LOC linesOfCode ) {
 linesOfCode /= 1000;
 if( linesOfCode < 67 )        return 1;
 else if( linesOfCode < 247 )  return 2;
 else if( linesOfCode < 666 )  return 3;
 else if( linesOfCode < 1311 ) return 4;
 else                          return 5;
}

public int getUnitRanking( LOC linesOfCode, <LOC low, LOC moderate, LOC high, LOC veryHigh> ) {
 mPerc = percentageOf( moderate, linesOfCode);
 hPerc = percentageOf( high, linesOfCode);
 vhPerc = percentageOf( veryHigh, linesOfCode);

 if( mPerc <= 25 && hPerc == 0, vhPerc == 0 )          return 1;
 else if ( mPerc <= 30 && hPerc <= 5 && vhPerc == 0 )  return 2;
 else if ( mPerc <= 40 && hPerc <= 10 && vhPerc == 0 ) return 3;
 else if ( mPerc <= 50 && hPerc <= 15 && vhPerc <= 5 ) return 4;
 else                                                  return 5;
}

public int getDuplicationRanking( LOC linesOfCode, LOC duplicatedLinesOfCode ) {
	perc = percentageOf( duplicatedLinesOfCode, linesOfCode );
	
	if( perc <= 3 )       return 1;
	else if( perc <= 5 )  return 2;
	else if( perc <= 10 ) return 3;
	else if( perc <= 20 ) return 4;
	else                  return 5;
}
