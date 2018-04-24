package TwoDeeBoard;

import com.sun.corba.se.impl.orbutil.graph.Graph;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionListener;
import java.util.List;

/**
 * Created by AaronR on 4/6/17.
 * for ?
 */
public class PaintedBoard extends JPanel implements TicTacToeBoard{
    List<ActionListener> listeners;
    boolean isEnabled;
    Graphics2D g2;

    public PaintedBoard(List<ActionListener> alisteners, Graphics g){
        super();
        listeners = alisteners;
        g2 = (Graphics2D) g;
        drawHash();

    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
            g2 = (Graphics2D) g;
    }

    public void addMark(int space, int player){

        if (player == 1){
            //TODO: DRAW X for player 1
            drawX(space);
        }
        else{
            //TODO: DRAW 0 for player 2
            drawO(space);
        }
    }

    public void drawWinnerLine(int one, int two, int three){

    }

    public void gameEnabled(boolean b){
        //TODO disable clicks
        isEnabled = b;
    }

    private void drawX(int space){

        int startX = (((space-1)%3)* (550/3)) + 20;
        int endX = (((space)%3)* (550/3)) - 20;
        int startY = (((space-1)%3)* (348/3)) + 20;
        int endY = (((space-1)%3)* (348/3)) - 20;
        g2.setPaint(Color.red);
        g2.setStroke(new BasicStroke(3.0f));
        g2.drawLine(startX,startY,endX,endY);
        g2.drawLine(endX,startY,startX,endY);
    }

    private void drawO(int space){
        int startX = (((space-1)%3)* (550/3)) + 20;
        int startY = (((space-1)%3)* (348/3)) + 20;

        g2.drawOval(startX,startY,((550/3) - 30), (348/3) - 30);
    }

    private void drawHash(){
        int x1 = 550/3;
        int x2 = 2 * (550/3);
        int y1 = 348/3;
        int y2 = 2 * (348/3);

        g2.drawLine(x1,0,x1,348);
        g2.drawLine(x2,0,x2,348);
        g2.drawLine(0,y1,550,y1);
        g2.drawLine(0,y2,550,y2);

    }



}
