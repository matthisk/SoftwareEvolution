package test;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;

public class Clones2 {

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
            	g.setPaintMode();
            }
        }
        
        if ( true )
        {   BufferedImage nieuw = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB );
            Graphics g = nieuw.getGraphics();
            g.setColor(Color.WHITE);
            g.fillRect(0, 0, w, h);
            
            if( true ) {
            	int j = 0;
            	int q = 2;
            	g.setPaintMode();
            }
        }
        
        BufferedImage nieuw = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB );
        Graphics g = nieuw.getGraphics();
        
        if( true ) {
        	int j = 0;
        	int z = 3;
        	g.setPaintMode();
        }
    }
	
	public String testCloneMethod1(int w, int h) {
		BufferedImage nieuw = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB );
        Graphics g = nieuw.getGraphics();
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, w, h);
        
        for(int i = 0; i < 100; i++ ) {
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
