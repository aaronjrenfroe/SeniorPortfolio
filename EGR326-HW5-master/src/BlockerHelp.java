import java.util.ArrayList;
import java.util.List;

/**
 * Created by trial on 4/6/2017.
 */
public final class BlockerHelp {

    public static List blockMove(Square[][] squares, Players p) {

        List<Integer> coordinates= new ArrayList<>();
        //if a row contains 2 that are not the blockers we fill the third space.
        int rowNumber = twoInRow(squares, p);
        if (rowNumber != 5) {
            for (int i = 0; i < 3; i++) {
                if (squares[rowNumber][i].player == Players.NOPLAYER) {
                    coordinates.add(rowNumber);
                    coordinates.add(i);
                    return coordinates;
                }

            }
        }

        //if a col contains 2 that are not the blockers we fill the third space.
        int colNumber = twoInCol(squares, p);
        if (colNumber != 5) {
            for (int i = 0; i < 3; i++) {
                if (squares[i][colNumber].player == Players.NOPLAYER) {
                    coordinates.add(i);
                    coordinates.add(colNumber);
                    return coordinates;
                }
            }

        }
        //check for diagonal block
        coordinates=diagonalCheck(squares, p);
        return coordinates;
    }

    private static int twoInRow(Square[][] squares, Players p){
        int rowIndex;
        int count1=0,count2=0, count3=0;
        //check if there are two of the opposite in the squares start with rows
        for (int i = 0; i < 3; i++) {
            if (squares[0][i].player != p && squares[0][i].player != Players.NOPLAYER) {
                count1++;
                if(count1==2)
                {
                    return rowIndex=0;
                }

            }
            if (squares[1][i].player != p && squares[1][i].player != Players.NOPLAYER) {
                count2++;
                if(count2==2)
                {
                    return rowIndex=1;
                }
            }
            if (squares[2][i].player != p && squares[2][i].player != Players.NOPLAYER) {
                count3++;
                if(count3==2)
                {
                    return rowIndex=2;
                }
            }
        }
        return 5;
    }

    private static int twoInCol(Square[][] squares, Players p){
        int rowIndex;
        int count1=0,count2=0, count3=0;
        //check if there are two of the opposite in the squares start with rows
        for (int i = 0; i < 3; i++) {
            if (squares[i][0].player != p && squares[0][i].player != Players.NOPLAYER) {
                count1++;
                if(count1==2)
                {
                    return rowIndex=0;
                }
            }
            if (squares[i][1].player != p && squares[1][i].player != Players.NOPLAYER) {
                count2++;
                if(count2==2)
                {
                    return rowIndex=1;
                }
            }
            if (squares[i][2].player != p && squares[2][i].player != Players.NOPLAYER) {
                count3++;
                if(count3==2)
                {
                    return rowIndex=2;
                }
            }
        }
        return 5;
    }

    private static List diagonalCheck(Square[][] squares, Players p){

        List<Integer> coordinates= new ArrayList<>();
        //checking diagonal
        if(squares[0][0].player != p && squares[1][1].player != p && squares[2][2].player != p)
        {
            if(squares[0][0].player == Players.NOPLAYER)
            {
                coordinates.add(0);
                coordinates.add(0);
                return coordinates;
            }else if(squares[1][1].player== Players.NOPLAYER)
            {
                coordinates.add(1);
                coordinates.add(1);
                return coordinates;
            }else{
                coordinates.add(2);
                coordinates.add(2);
                return coordinates;
            }

        }
        //checking opposite diagonal
        if(squares[2][0].player != p && squares[1][1].player != p && squares[0][2].player != p)
        {
            if(squares[2][0].player == Players.NOPLAYER)
            {
                coordinates.add(2);
                coordinates.add(0);
                return coordinates;
            }else if(squares[1][1].player== Players.NOPLAYER)
            {
                coordinates.add(1);
                coordinates.add(1);
                return coordinates;
            }else{
                coordinates.add(0);
                coordinates.add(2);
                return coordinates;
            }
        }
        return coordinates;
    }

}
