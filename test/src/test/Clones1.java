package test;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;

public class Clones1 {

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

	public String testCloneMethod2(int w, int h) {
		BufferedImage nieuw = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB );
        Graphics g = nieuw.getGraphics();
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, w, h);
        
        for(int j = 0; j < 66; j++ ) {
        	g.drawArc(0, 0, 100, 200, 2, 60);
        	g.drawArc(0, 0, 100, 200, 2, 60);
        }
        
        BufferedImage nieuwnieuw = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB );
        Graphics gg = nieuwnieuw.getGraphics();
        gg.setColor(Color.WHITE);
        gg.fillRect(0, 0, w, h);
        
        return "leeg";
	}
}
