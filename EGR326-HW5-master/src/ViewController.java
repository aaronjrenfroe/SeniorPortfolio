import javax.swing.text.View;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by AaronR and Jose on 3/23/17.
 * for Dr. Han
 */

public final class ViewController{

    Game m;
    BoardView v;
    Players whoWins;

    int p1Wins;
    int p2Wins;
    int p1Looses;
    int p2Looses;
    List<Integer> moves;
    boolean p1Turn;
    private boolean gameState;
    private static ViewController uniqInstance;
    boolean humanCanMove = true;
    // Aaron
    /**
     * sets new game, passes game a reference to itself
     */
    private ViewController(){
        m = new Game();
        m.setController(this);
        moves = new ArrayList();
        p1Wins = 0;
        p2Wins = 0;
        p1Looses = 0;
        p2Looses = 0;
        p1Turn = true;
        gameState = false;

    }

    public static ViewController getInstance(){
        if (uniqInstance == null){
            synchronized (ViewController.class){
                if (uniqInstance == null){
                    uniqInstance = new ViewController();
                }
            }
        }
        return uniqInstance;
    }
    // Aaron
    /**
     * called by TicTacToe to set the Vc's View
     * @param view the View that is being controlled
     */
    public void setView(BoardView view){
        this.v = view;
    }


    // Jose and debugged by Aaron
    /**
     * Function to make a move.
     * @param move Move attempting to be made
     * @return returns true if it was possible, if not it returns false.
     */
    public String makeMove(int move){

        String playerMove=table(move);
        String[] coordinates=playerMove.split(",");
        int xCoordinate=Integer.parseInt(coordinates[0]);
        int yCoordinate=Integer.parseInt(coordinates[1]);
        if(!moves.contains(move)) {

            boolean good = m.makeAMove(xCoordinate, yCoordinate);
            // We can create an empty board in the constructor, clear in on newGame and
            // We can update a copy of the board here
            //
            v.markTile(move, p1Turn);

            String status = gameStatus(); // Status will always == "noplayer" and assume p2 won.
            if (status == "play") {
                //calling game's move maker since we can play
                if (good == true) {
                    p1Turn = !p1Turn;
                    moves.add(move);
                    checkNextPlayer();
                    return "yes";
                } else {
                    return "no";
                }
            } else if (status == "draw") { //there was a draw, return the draw status
                gameState = false;
                return status;
            } else { //if there was a winner then check which player was, return the name of the player and update the wins and loses
                gameState = false;
                if (status == "PLAYER1") {
                    p1Wins += 1;
                    p2Looses += 1;
                    update();
                    return status;
                } else {
                    p2Wins += 1;
                    p1Looses += 1;
                    update();
                    return status;
                }

            }
        }
        return "no";
    }
    // Jose
    //function to check if there has been a draw or a win
    private String gameStatus(){
        boolean isDraw;
        whoWins = m.gameWon();
        if(whoWins == null){
            isDraw = m.resultIsDraw();
            if(isDraw){
                return "draw";
            }else{
                return "play";
            }
        }else{
            return whoWins.toString();
        }
    }

    // Aaron & Jose
    /**
     * called after a win to update board
     */
    private void update() {
        v.setLooses(p1Looses,p2Looses);
        v.setWins(p1Wins,p2Wins);
    }


    // Adapter
    // Jose
    // conversion table
    private String table(int i){
        if(i==1)
        {
            return "0,0";
        }else if(i==2){
            return "0,1";
        }else if(i==3){
            return "0,2";
        }else if(i==4){
            return "1,0";
        }else if(i==5){
            return "1,1";
        }else if(i==6){
            return "1,2";
        }else if(i==7){
            return "2,0";
        }else if(i==8){
            return "2,1";
        }else{
            return "2,2";
        }
    }

    // Aaron
    /** Called in View
     *  Ends game and clears statistics
     */
    public void reset(){
        newGame();
        p1Wins = 0;
        p2Wins = 0;
        p1Looses = 0;
        p2Looses = 0;
        update();
    }

    //Aaron
    /**
     * Called in View creates a new game
     */
    public void newGame(){
        gameState = true;
        m = new Game();
        moves = new ArrayList();
        p1Turn = true;
        checkNextPlayer();

    }

    public boolean getGameState(){
        return gameState;
    }

    public void checkNextPlayer(){
        int mode = 0;
        if(p1Turn){
            mode = v.getPlayer1Mode();
        }else{
            mode = v.getPlayer2Mode();
        }
        if (mode != 0) {
            humanCanMove = false;
            List<Integer> coord = new ArrayList();
            switch (mode) {
                case 1:
                    coord = Strategy1.makeMove(m.getGameBoardCopy());
                    break;
                case 2:
                    coord = Sequential.makeMove(m.getGameBoardCopy());
                    break;
                case 3:
                    coord = Blocker.makeMove(m.getGameBoardCopy(), p1Turn ? Players.PLAYER1: Players.PLAYER2);
                    break;
                case 4:
                    coord = Smart.makeMove(m.getGameBoardCopy(), p1Turn ? Players.PLAYER1: Players.PLAYER2);
                    break;
                default:
                    break;
            }
            final List<Integer> co = coord;
            new java.util.Timer().schedule(
                    new java.util.TimerTask() {
                        @Override
                        public void run() {
                            System.out.println("Computer Moved");
                            makeMove(((co.get(0)*3)+co.get(1))+1);
                            humanCanMove = true;
                        }
                    },
                    100
            );

        }

    }
}
