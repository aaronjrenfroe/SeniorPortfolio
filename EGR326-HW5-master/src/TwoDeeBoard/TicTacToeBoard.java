package TwoDeeBoard;

/**
 * Created by AaronR on 4/6/17.
 * for ?
 */
public interface TicTacToeBoard {
    void addMark(int space, int player);
    void drawWinnerLine(int one, int two,int three);
    void gameEnabled(boolean status);
}
