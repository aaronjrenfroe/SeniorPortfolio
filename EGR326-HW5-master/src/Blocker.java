import java.util.ArrayList;
import java.util.List;

/**
 * Created by Jose on 4/4/2017.
 */
public final class Blocker   {

    public static List makeMove(Square[][] squares, Players p){

        //if there is a blocked move true will be returned as in a move was made
        List<Integer> coordinates = BlockerHelp.blockMove(squares, p);
        if(coordinates.size()>1){
            return coordinates;
        }else{
            //if no move was blocked a random move is made in an empty space

            coordinates = Strategy1.movingRandomly(squares);
            return coordinates;
        }

    }


}
