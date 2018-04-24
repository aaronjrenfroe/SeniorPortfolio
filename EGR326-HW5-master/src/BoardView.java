/**
 * Created by AaronR on 3/27/17.
 * for Dr. Han
 *  Aaron Wrote this whole Class
 */


import TwoDeeBoard.BoardPanel;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import javax.imageio.ImageIO;
import javax.swing.*;
import java.util.List;
/**
 * The View for the Game
 */
public class BoardView {
    // Delegates
     ViewController vc;

    private JFrame frame;
    private GameInfo p1Menu;
    private GameInfo p2Menu;

    private JLabel statusLabel;
    private JRadioButton buttonBordButton;
    private JRadioButton drawBordButton;

    // Collection of all the tic tac toe tiles
    private BoardPanel playingSpace;

    String p1NameText;
    String p2NameText;

    /**
     * Constructor
     * @param delegate The Controller of the view
     */
     public BoardView(ViewController delegate){
         this.vc = delegate;
        p1Menu = new GameInfo(1);
        p2Menu = new GameInfo(2);

        statusLabel = new JLabel("Welcome To Tic-Tac-Toe");
        buttonBordButton = new JRadioButton("Button");
        drawBordButton = new JRadioButton("Painted");

        buttonBordButton.addActionListener(new GraphicsSwapTrigger(0));
        drawBordButton.addActionListener(new GraphicsSwapTrigger(1));

        // creates 9 space buttons and adds creates and adds an
        // action Listener with a unique button ID to it.
        //seems to want an integer so I'll have to use this values, I'll jst make a translation table.
         List<ActionListener> alisteners = new ArrayList();
         for (int i = 1; i <= 9; i++) {
             alisteners.add(new SpacePressedListener(i));
         }
         playingSpace = new BoardPanel(alisteners);


        frame = new JFrame("Tic-Tac-Toe");
        frame.setLocation(300,100);
        frame.setSize(550,550);
        frame.setResizable(false);

        frame.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
        frame.setLayout(new BorderLayout());

        designLayout();
        frame.setVisible(true);
    }
    // helper to setup Layouts
    private void designLayout(){

        Container scoreBoards = new JPanel();
        layoutScoreBoards(scoreBoards);

        Container systemButtons = new JPanel();
        layoutSystemButtons(systemButtons);

        //Container gameField = playingSpace;

        frame.add(scoreBoards, BorderLayout.NORTH);
        frame.add(playingSpace, BorderLayout.CENTER);
        frame.add(systemButtons, BorderLayout.SOUTH);
        frame.invalidate();
        frame.validate();
    }
    // sets up score boards
    private void layoutScoreBoards(Container scoreBoards){


        scoreBoards.add(p1Menu.getJPanel());
        scoreBoards.add(p2Menu.getJPanel());
        //scoreBoards.setPreferredSize(new Dimension(320,120));
    }
    // sets up bottom buttons new game reset exit
    private void layoutSystemButtons(Container bottom){
        bottom.setLayout(new BoxLayout(bottom,BoxLayout.Y_AXIS));

        JPanel sysButtons = new JPanel();
        sysButtons.setComponentOrientation(ComponentOrientation.LEFT_TO_RIGHT);
        statusLabel.setHorizontalAlignment(SwingConstants.CENTER);
        JButton newGame = new JButton("New Game");
        JButton resetGame = new JButton("Reset");
        JButton exitButton = new JButton("Exit");

        newGame.addActionListener(new NewGameListener());
        resetGame.addActionListener(new ResetGameListener());
        exitButton.addActionListener(new CloseListener());

        try {
            Image imgNewGame = ImageIO.read(getClass().getResource("resources/newgame.png"));
            Image imgReset = ImageIO.read(getClass().getResource("resources/reset.png"));
            Image imgExit = ImageIO.read(getClass().getResource("resources/exit.png"));
            newGame.setIcon(new ImageIcon(imgNewGame));
            resetGame.setIcon(new ImageIcon(imgReset));
            exitButton.setIcon(new ImageIcon(imgExit));
        } catch (Exception ex) {
            System.out.println(ex);
        }
        buttonBordButton.setSelected(true);
        sysButtons.add(newGame);
        sysButtons.add(resetGame);
        sysButtons.add(exitButton);
        sysButtons.add(new JLabel("View:"));
        ButtonGroup switchViewButtons = new ButtonGroup();
        switchViewButtons.add(buttonBordButton);
        switchViewButtons.add(drawBordButton);
        sysButtons.add(buttonBordButton);
        sysButtons.add(drawBordButton);
        bottom.add(sysButtons);
        bottom.add(statusLabel, BorderLayout.WEST);
    }

    // EXIT BUTTON
    private class CloseListener implements ActionListener{
        @Override
        public void actionPerformed(ActionEvent e) {
            //DO SOMETHING
            System.exit(0);
        }
    }
    // NEW GAME BUTTON ACTION
    private class NewGameListener implements ActionListener{
        @Override
        public void actionPerformed(ActionEvent e) {

            //TODO: Initiate new Game in the controller
            if (p1Menu.getEnteredName().trim().equals("") || p2Menu.getEnteredName().trim().equals("")) {
                JOptionPane.showOptionDialog(frame, "Illegal player name(s).", "Error", JOptionPane.DEFAULT_OPTION,
                        JOptionPane.ERROR_MESSAGE, null, null, null);
            }

            p1NameText = p1Menu.getEnteredName();
            p2NameText = p2Menu.getEnteredName();

            vc.newGame();
            playingSpace.newGame();
            statusLabel.setText(p1NameText+"'s Turn");
            frame.invalidate();
            frame.validate();
        }
    }
    // RESET GAME ACTION
    private class ResetGameListener implements ActionListener{
        @Override
        public void actionPerformed(ActionEvent e) {
            int res = JOptionPane.showOptionDialog(frame, "This will end the game and set the win/losses stats to 0. Are you sure?", "Are You Sure?", JOptionPane.YES_NO_OPTION,
                    JOptionPane.QUESTION_MESSAGE, null, null, null);
            if (res == JOptionPane.YES_OPTION) {
                vc.reset();
                gameButtonsEnabled(false);
                playingSpace.newGame();
            }
            frame.invalidate();
            frame.validate();
        }
    }
    // TILE Pressed Button
    private class SpacePressedListener implements ActionListener {

        int buttonID;

        public SpacePressedListener(int buttonNumber){

            this.buttonID = buttonNumber;
        }
        // This is the function that gets called
        @Override
        public void actionPerformed(ActionEvent e) {
            if (vc.humanCanMove) {
                System.out.println("Game Button " + buttonID + " was Pressed");
                //passing value of button pressed to makeMove function
                String check = vc.makeMove(buttonID);
                switch (check) {
                    case "yes":
                        break;
                    case "no":
                        statusLabel.setText("Can't Go there, Try again");
                        break;
                    case "draw":
                        statusLabel.setText("There is a draw");
                        gameButtonsEnabled(false);
                        break;
                    case "PLAYER1":
                        statusLabel.setText(p1NameText + " WINS!");
                        gameButtonsEnabled(false);
                        break;
                    case "PLAYER2":
                        statusLabel.setText(p2NameText + " WINS!");
                        gameButtonsEnabled(false);
                        break;
                    default:
                        break;
                }
            }else{
                statusLabel.setText("Please Wait for computer to finish");
            }

        }
    }
    private class GraphicsSwapTrigger implements ActionListener{
        int button;
        public GraphicsSwapTrigger(int id){
            if (id != 0 && id != 1){
                throw new IllegalArgumentException("Button ID must be 1 or 0, you pass a " + id);
            }
            this.button = id;
        }

        @Override
        public void actionPerformed(ActionEvent e) {
            if (false){
            //if (!vc.getGameState()) {
                playingSpace.swapPanels();
                frame.invalidate();
                frame.validate();
            }else{

                buttonBordButton.setSelected(!buttonBordButton.isSelected());

            }
        }
    }

    // Gets called by the controller

    /**
     * Updates the wins labels
     * @param p1wins
     * @param p2wins
     */
    public void setWins(int p1wins, int p2wins){
        p1Menu.setWins(p1wins);
        p2Menu.setWins(p2wins);
    }

    /**
     * updates the looses counter
     * @param p1Val
     * @param p2Val
     */
    public void setLooses(int p1Val, int p2Val){
        p1Menu.setLooses(p1Val);
        p2Menu.setLooses(p2Val);
    }

    /**
     * Receives message from VC saying it is ok to mark space
     * @param space To be marked
     * @param p1Turn Who made the mark. Used to put an x or a o
     */
    public void markTile(int space, boolean p1Turn){
        playingSpace.addMark(space,  p1Turn ? 1 : 2);

        if (p1Turn){

            statusLabel.setText(p2NameText+"'s Turn");
        }
        else{

            statusLabel.setText(p1NameText+"'s Turn");
        }
    }
    // helper method used to enable and disable the board
    private void gameButtonsEnabled(boolean status){
        playingSpace.gameEnabled(status);
        frame.invalidate();
        frame.validate();
    }

    /**
     * 0 Human
     * 1 Random
     * 2 Sequential
     * 3 Blocker
     * 4 Smart
     * @return
     */
    public int getPlayer1Mode(){
        return p1Menu.getMode();
    }
    public int getPlayer2Mode(){
        return p2Menu.getMode();
    }
}
