module Ranking

import Util;

alias LOC = num;

public int getVolumeRanking( LOC linesOfCode ) {
 if( linesOfCode < 67 )        return 1;
 else if( linesOfCode < 247 )  return 2;
 else if( linesOfCode < 666 )  return 3;
 else if( linesOfCode < 1311 ) return 4;
 else                          return 5;
}

public int getUnitRanking( LOC linesOfCode, <LOC moderate, LOC high, LOC veryHigh> ) {
 mPerc = percentageOf( moderate, linesOfCode);
 hPerc = percentageOf( high, linesOfCode);
 vhPerc = percentageOf( veryHigh, linesOfCode);

 if( mPerc <= 25 && hPerc == 0, vhPerc == 0 )          return 1;
 else if ( mPerc <= 30 && hPerc <= 5 && vhPerc == 0 )  return 2;
 else if ( mPerc <= 40 && hPerc <= 10 && vhPerc == 0 ) return 3;
 else if ( mPerc <= 50 && hPerc <= 15 && vhPerc <= 5 ) return 4;
 else                                                  return 5;
}
