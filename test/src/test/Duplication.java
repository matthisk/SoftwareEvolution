package test;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;

public class Duplication {
	
	/**
	 * Javadoc
	 */
	public String duplicatedMethod1() {
		String blaat = "test"; /*
		comment
		*/return blaat;
	}
	
	/**
	 * Javadoc
	 */
	public String duplicatedMethod2() {
		String blaat = "test"; /*
		comment
		*/return blaat;
	}
	
	public void resize(int w, int h)
    {
        if ( true )
        {   BufferedImage nieuw = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB );
            Graphics g = nieuw.getGraphics();
            g.setColor(Color.WHITE);
        	g.fillRect(0, 0, w, h);
            if( true ) {
            	int j = 0;
            	int p = 1;
            }
        }
        
        if ( true )
        {   BufferedImage nieuw = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB );
            Graphics g = nieuw.getGraphics();
            g.setColor(Color.WHITE);
            g.fillRect(0, 0, w, h);
            
            if( true ) {
            	
            	int j = 0;
            	int p = 1;
            }
        }
        
        if( true ) {
        	int j = 0;
        	int p = 1;
        }
    }
	
	public void geenDups(int aap) {
		int gaap = aap + 5;
		int blaat = aap + 10;
		String apaat = "AAPJES";
		
		for( int i = 0; i < 10; i++ ) {
			
		}
		
		int agaap = aap + 5;
		int ablaat = aap + 10;
		String apaaton = "AAPJES";
	}
	
	public void geenDups2(int aap) {
		int gaap = aap + 5;
		int blaat = aap + 10;
		String apaat = "AAPJES";
		
		for( int i = 0; i < 10; i++ ) {
			
		}
		
		int agaap = aap + 5;
		int ablaat = aap + 10;
		String apaaton = "AAPJES";
	}
	
}
