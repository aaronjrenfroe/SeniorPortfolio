/**
 * Created by trial on 4/6/2017.
 */
public class HumanMove {

    public boolean makeMove(Square[][] squares, int row, int col, Players p){
        squares[row][col].player = p;
        return true;
    }

}
