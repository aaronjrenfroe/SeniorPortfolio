/**
 * Created by Danny on 3/29/2017.
 */
public class Main {
    public static void main(String[] args) {
        Game g= new Game();
        //
        g.makeAMove(0,0);
        g.makeAMove(0,1);
        g.makeAMove(2,2);
        g.makeAMove(0,2);
        g.makeAMove(1,1);

        System.out.println(g.gameWon());
        System.out.println(g.gameWon());


    }
}
