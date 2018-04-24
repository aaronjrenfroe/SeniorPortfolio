package TwoDeeBoard;


import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionListener;
import java.util.List;

/**
 * Created by AaronR on 4/6/17.
 * for ?
 */
public class BoardPanel extends JPanel implements TicTacToeBoard{
    ButtonPanel buttonPanel;
    PaintedBoard paintedPanel;
    Boolean buttonPanelShown;
    List<ActionListener> listeners;



    public BoardPanel(List<ActionListener> aListeners){
        super();
        buttonPanelShown = true;
        buttonPanel = new ButtonPanel(aListeners);
        paintedPanel = null;
        listeners = aListeners;
        setLayout(new BorderLayout());

        add(buttonPanel);

        //TODO: FILL THESE IN

    }

    public void swapPanels(){
        if (buttonPanelShown){
            if (paintedPanel == null){
                paintedPanel = new PaintedBoard(listeners,this.getGraphics());
            }
            remove(buttonPanel);
            add(paintedPanel);

        }else{
            remove(paintedPanel);
            add(buttonPanel);
        }
        buttonPanelShown = !buttonPanelShown;
    }

    public void addMark(int space, int player) {
        if (buttonPanelShown) {
            buttonPanel.addMark(space, player);
        } else{
            paintedPanel.addMark(space, player);
        }
    }

    public void drawWinnerLine(int one, int two,int three){
        if (buttonPanelShown) {
            buttonPanel.drawWinnerLine(one, two, three);
        }else {
            paintedPanel.drawWinnerLine(one, two, three);
        }
    }

    public void gameEnabled(boolean status){
        if (buttonPanelShown) {
            buttonPanel.gameEnabled(status);
        }else {
            paintedPanel.gameEnabled(status);
        }
    }

    public void newGame(){
        if (!buttonPanelShown){
            remove(paintedPanel);

        }else{
            remove(buttonPanel);
        }

        buttonPanel = new ButtonPanel(listeners);
        paintedPanel = new PaintedBoard(listeners,this.getGraphics());
        buttonPanel.gameEnabled(true);
        paintedPanel.gameEnabled(true);

        if (!buttonPanelShown){
            add(paintedPanel);

        }else{
            add(buttonPanel);
        }
    }



}
