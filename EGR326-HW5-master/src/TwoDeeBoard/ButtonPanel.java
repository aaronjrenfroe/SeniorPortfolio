package TwoDeeBoard;

import com.sun.scenario.effect.impl.sw.sse.SSEBlend_SRC_OUTPeer;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by AaronR on 4/6/17.
 * for ?
 */
public class ButtonPanel extends JPanel implements TicTacToeBoard{
    private List<JButton> spaces;

    public ButtonPanel(List<ActionListener> aListeners) {
        super();
        setLayout(new GridLayout(3, 3));
        spaces = new ArrayList();
        for (int i = 1; i <= 9; i++) {
            JButton button = new JButton();
            button.addActionListener(aListeners.get(i-1));
            button.setEnabled(false);
            button.setText("");
            spaces.add(button);
            add(button);
        }
    }

    public void addMark(int space, int player){
        JButton spaceButton = spaces.get(space-1);
        if (player == 1){
            spaceButton.setText("X");
        }
        else{
            spaceButton.setText("O");
        }
        System.out.println("Dimentions");
        System.out.println(this.getWidth());
        System.out.println(this.getHeight());
    }

    public void drawWinnerLine(int one, int two,int three){

    }

    public void gameEnabled(boolean status){
        //TODO: Disable Buttons
        removeAll();
        for (int i = 0; i < 9; i++) {
            spaces.get(i).setEnabled(status);
            add(spaces.get(i));
        }

    }

}
