/**
 * Created by Danny on 3/29/2017.
 */
public class Square {
    Players player;

    //constructor
    public Square(Players player){
        this.player=player;
    }

    //getter
    public Players getPlayer() {
        return player;
    }

    //setter
    public void setPlayer(Players player) {
        this.player = player;
    }

    public void empty(){
        this.player=Players.NOPLAYER;
    }
}
