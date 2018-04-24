

/**
 * Created by AaronR on 3/22/17.
 * for ?
 */
public class TicTacToe{

    public static void main(String[] args) {

        ViewController c = ViewController.getInstance();
        BoardView v = new BoardView(c);
        c.setView(v);
    }
    
}
