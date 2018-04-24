import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by trial on 4/6/2017.
 */
public final class Smart {

    public static List makeMove(Square[][] squares, Players p){

        List<Integer> coordinates= new ArrayList<>();
        //instantiating blockerhelp object

        //if statements to drive the move of Smart
        coordinates=smart(squares, p);
        if(coordinates.size()>0){
            return coordinates;
        }
        //if smart didnt work do blocker

        coordinates=BlockerHelp.blockMove(squares,p);
        if(coordinates.size()>0){
                return coordinates;
        }
        //if blocker didnt work do corner
        coordinates= corner(squares);
        if(coordinates.size()>0){
            return coordinates;
        }
        //if that didn't work go for the center, see if its empty. If its empty return coordinates with those numbers
        if(squares[1][1].player==Players.NOPLAYER){
            coordinates.add(1);
            coordinates.add(1);
            return coordinates;
        }
        //if that didn't work go for the edges and return the coordinates
          coordinates= edge(squares);
          return coordinates;


    }
    //function to make a move to an edge
    private static List edge(Square[][] squares)
    {
        List<Integer> numers= new ArrayList<>();
        int[] c=new int[]{1,3,5,7};
        List<Integer> edge= new ArrayList<>();
        //initializing list
        edge=initList(c);
        //shuffling corners
        Collections.shuffle(edge);
        //attempt to place in a corner, if there is an empty corner it will be filled and the loop will break
        for(int i:edge)
        {
            String playerMove=table(i);
            String[] coordinates=playerMove.split(",");
            int xCoordinate=Integer.parseInt(coordinates[0]);
            int yCoordinate=Integer.parseInt(coordinates[1]);
            if(squares[xCoordinate][yCoordinate].player==Players.NOPLAYER){
                numers.add(xCoordinate);
                numers.add(yCoordinate);
                return numers;
            }
        }
        return numers;
    }
    //function to attempt a smart move which is the opposite of a blocker move
    private static List smart(Square[][] squares, Players p)
    {
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
        //check for diagonal MOVE
        coordinates=diagonalCheck(squares, p);
        return coordinates;


    }
    //check if there are two AI4 in a row
    private static int twoInRow(Square[][] squares, Players p){
        int rowIndex;
        int count1=0,count2=0, count3=0;
        //check if there are two of the opposite in the squares start with rows
        for (int i = 0; i < 3; i++) {
            if (squares[0][i].player == p) {
                count1++;
                if(count1==2)
                {
                    return rowIndex=0;
                }

            }
            if (squares[1][i].player == p) {
                count2++;
                if(count2==2)
                {
                    return rowIndex=1;
                }
            }
            if (squares[2][i].player == p) {
                count3++;
                if(count3==2)
                {
                    return rowIndex=2;
                }
            }
        }
        return 5;
    }

    //function to make a move in a corner
    private static List corner(Square[][] squares)
    {
        List<Integer> numbers= new ArrayList<>();
        //variables
        int[] c=new int[]{0,2,6,9};
        List<Integer> corners= new ArrayList<>();
        //initializing list
        corners=initList(c);
        //shuffling corners
        Collections.shuffle(corners);
        //attempt to place in a corner
        for(int i:corners)
        {
            String playerMove=table(i);
            String[] coordinates=playerMove.split(",");
            int xCoordinate=Integer.parseInt(coordinates[0]);
            int yCoordinate=Integer.parseInt(coordinates[1]);
            if(squares[xCoordinate][yCoordinate].player==Players.NOPLAYER){
                numbers.add(xCoordinate);
                numbers.add(yCoordinate);
                return numbers;
            }
        }
        //if it wasn't possible to use a corner then return false
        return numbers;


    }
    //to initialize lists
    private static List initList(int[] a){
        List<Integer> toBeInitialized= new ArrayList<>();

        //initializing list
        for(int i:a){
            toBeInitialized.add(i);
        }
        return toBeInitialized;
    }

    private static int twoInCol(Square[][] squares, Players p){
        int rowIndex;
        int count1=0,count2=0, count3=0;
        //check if there are two of the opposite in the squares start with rows
        for (int i = 0; i < 3; i++) {
            if (squares[i][0].player == p) {
                count1++;
                if(count1==2)
                {
                    return rowIndex=0;
                }
            }
            if (squares[i][1].player == p) {
                count2++;
                if(count2==2)
                {
                    return rowIndex=1;
                }
            }
            if (squares[i][2].player == p) {
                count3++;
                if(count3==2)
                {
                    return rowIndex=2;
                }
            }
        }
        return 5;
    }


    private static String table(int i){
        if(i==0)
        {
           return "0,0";
        }else if(i==1){
            return "0,1";
        }else if(i==2){
            return "0,2";
        }else if(i==3){
            return "1,0";
        }else if(i==4){
            return "1,1";
        }else if(i==5){
            return "1,2";
        }else if(i==6){
            return "2,0";
        }else if(i==7){
            return "2,1";
        }else{
            return "2,2";
        }
    }

    //checking for diagonal move
    private static List diagonalCheck(Square[][] squares, Players p){

        List<Integer> coordinates= new ArrayList<>();
        //checking diagonal
        if(squares[0][0].player == p && squares[1][1].player == p || squares[1][1].player== p && squares[2][2].player == p ||
                squares[0][0].player== p && squares[2][2].player == p)
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
        if(squares[2][0].player == p && squares[1][1].player == p || squares[1][1].player== p && squares[0][2].player == p ||
                squares[2][0].player== p && squares[0][2].player == p)
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
