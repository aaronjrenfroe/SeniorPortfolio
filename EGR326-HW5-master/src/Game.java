import java.util.Observable;

/**
 * Created by Jose on 3/22/2017.
 */

public class Game {

    ViewController vc;
    static int count;

    //Variables
    Square [][] squares;

    /**
     * Constructor
     */
    public Game(){
        gameBoard();
        count=0;
    }
    /**
     * Sets the controller for the game
     */
    public void setController(ViewController vc){
        this.vc = vc;
    }

    ////initializing every element to a noPlayer
    private void gameBoard() {
        squares = new Square[3][3];  // allocate the array
        for (int row = 0; row < 3; ++row) {
            for (int col = 0; col < 3; ++col) {
                squares[row][col] = new Square(Players.NOPLAYER); //initializing every element to a noPlayer
            }
        }
    }

    /**Check to see if there is an empty cell for a draw
     * created by Jose
     * @return true is board is full and there is no winner
     */
    public boolean resultIsDraw() {
        //double for loop to double check the content of the cells

            for (int row = 0; row < 3; ++row) {
                for (int col = 0; col < 3; ++col) {
                    if (squares[row][col].player == Players.NOPLAYER) {
                        return false; // there is a square which still doesn't have a player assigned
                    }
                }
            }

        return true; //all squares have been assigned players
    }


    /** Jose
     * a move is made if the spot trying to be marked is empty still
     * @param row of cell pressed
     * @param col of cell pressed
     * @return if move is acceptable
     */
    public boolean makeAMove(int row, int col){

        //check first if cell wanted is empty
        if(squares[row][col].player==Players.NOPLAYER) {
            if (count == 0) {
                squares[row][col].player = Players.PLAYER1;


            } else if (count%2 != 0){
                squares[row][col].player = Players.PLAYER2;

            }else{
                squares[row][col].player = Players.PLAYER1;

            }
            //count is increased with every move
            count++;
            return true;

        }else{
            return false;
        }
    }
    // created by Jose debugged by Aaron


    /**
     * Checks if Game was won by a player
     * @return Player who won, null if no winner yet
     */
    public Players gameWon(){
        if (count >= 5) {
            if (checkIfPlayerWon(Players.PLAYER1)) {
                return Players.PLAYER1;
            } else if (checkIfPlayerWon(Players.PLAYER2)) {
                return Players.PLAYER2;
            } else {
                return null;
            }
        }
        return null;
    }

    // Created by Jose debugged by Aaron
    // really debugged by Aaron
    // helper, checks board if passed player has won
    private boolean checkIfPlayerWon(Players p){
        //loop to check if a player has won on a horizontal win
        for (int i = 0; i < 3; i++) {
            if(squares[i][0].player == p && squares[i][1].player == p && squares[i][2].player == p) {
                return true;
            }
        }
        //loop to check if a player has won on a vertical win
        for (int i = 0; i < 3; i++) {
            if (squares[0][i].player == p && squares[1][i].player == p && squares[2][i].player == p) {
                    return true;//return the enum of the player who won
            }
        }
        //checking diagonal
        if(squares[0][0].player == p && squares[1][1].player == p && squares[2][2].player == p) {
                return true;//return the enum of the player who won
        }
        //checking opposite diagonal
        if(squares[2][0].player == p && squares[1][1].player == p && squares[0][2].player == p) {
            return true;//return the enum of the player who won
        }
        return false;
    }

    public Square[][] getGameBoardCopy(){
        return this.squares;
    }
}
