import java.util.ArrayList;
import java.util.List;

/**
 * Created by Jose on 4/4/2017.
 */
public final class Sequential {


    public static List makeMove(Square[][] squares){
        List<Integer> coordinates= new ArrayList<>();
        for (int row = 0; row < 3; ++row) {
            for (int col = 0; col < 3; ++col) {
                if (squares[row][col].player == Players.NOPLAYER) {
                    coordinates.add(row);
                    coordinates.add(col);
                    return coordinates; //returning an arraylist with the correct coordinates

                }
            }
        }
        return coordinates;
    }
}
