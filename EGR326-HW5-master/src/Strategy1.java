import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Created by Jose on 4/4/2017.
 */
public final class Strategy1 {

    private static int row = 0, col = 0;

    private static void randomGenerator(){

        Random rand= new Random();
        //generating random number
        row= rand.nextInt(3);
        col= rand.nextInt(3);
    }

    public static List makeMove(Square[][] p){

        List<Integer> coordinates;
        coordinates=movingRandomly(p);

        return coordinates;

    }

    public static List movingRandomly(Square[][] squares)
    {

        boolean moved=false;
        List<Integer> coordinates= new ArrayList<>();

        //attempt a random move until it is a valid movie
        do {
            //generating random numbers
            randomGenerator();
            //check if its available
            if (squares[row][col].player == Players.NOPLAYER) {
                //if available make a move
                coordinates.add(row);
                coordinates.add(col);
                moved=true;
            }
        }while(!moved);

        return coordinates;
    }
}
