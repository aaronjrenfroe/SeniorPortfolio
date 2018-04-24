import javax.swing.*;
import java.awt.*;

/**
 * Created by AaronR on 4/6/17.
 * for ?
 */
public class GameInfo {
    JPanel pPanel;
    private JTextField player1NameField;
    private JLabel nameLabel1;
    private JLabel player1Wins;
    private JLabel player1Losses;
    private JLabel winsLabel1;
    private JLabel lossesLabel1;
    private JLabel modeLabel;
    private JComboBox playerMode;
    int playerNumber;

    public GameInfo(int pNumber){
        if (pNumber != 1 && pNumber != 2){
            throw new IllegalArgumentException("Player Number bust be a 1 or a 2");
        }
        playerNumber = pNumber;
        nameLabel1 = new JLabel("Name:");
        player1NameField = new JTextField("Player "+playerNumber);
        winsLabel1 = new JLabel("Wins:");
        lossesLabel1 = new JLabel("Losses:");
        player1Wins = new JLabel("0");
        player1Losses = new JLabel("0");
        modeLabel = new JLabel("Type:");
        String[] modeStirngs = { "Human", "Random", "Sequential", "Blocker", "Smart" };
        playerMode = new JComboBox(modeStirngs);
        pPanel = new JPanel();
        setLayout();
    }

    private void setLayout(){
        
        pPanel.setLayout(new GridLayout(4,2));
        pPanel.add(nameLabel1);
        pPanel.add(player1NameField);
        pPanel.add(modeLabel);
        pPanel.add(playerMode);
        pPanel.add(winsLabel1);
        pPanel.add(player1Wins);
        pPanel.add(lossesLabel1);
        pPanel.add(player1Losses);
        pPanel.setBorder(BorderFactory.createTitledBorder("Player1(X):"));
        pPanel.setPreferredSize(new Dimension(220,100));
        if (playerNumber == 2){
            pPanel.setBorder(BorderFactory.createTitledBorder("Player2(0):"));
        }else {
            pPanel.setBorder(BorderFactory.createTitledBorder("Player1(X):"));
        }

    }

    public JPanel getJPanel(){
        return pPanel;
    }

    public void setLooses(int looses){
        if (looses<0){
            throw new IllegalArgumentException("Looses must be positive");
        }
        player1Losses.setText(String.valueOf(looses));

    }
    public void setWins(int wins){
        if (wins <0){
            throw new IllegalArgumentException("Wins must be positive");
        }
        player1Wins.setText(String.valueOf(wins));
    }

    public String getEnteredName(){
        return player1NameField.getText();
    }

    public int getMode(){
        return playerMode.getSelectedIndex();
    }

}
