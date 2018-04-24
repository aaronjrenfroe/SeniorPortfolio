/**
 * @author Aaron Renfroe
 * Created by Aaron Renfroe on 1/24/17.
 * EGR 326
 * Assignment 3 Restaurant
 * Class: Server
 *
 * Serve Class, keeps track of servers Tips.
 */
public final class Server {
    private int id;
    private double tips;

    /**
     * Constructor, init for id and tips.
     * Id is not forced to be positive to allow integer overflows in the
     * scenario of a restaurant having more than 2^31 serves
     * @param id a unique ID
     */
    public Server(int id){
        this.tips = 0;
        this.id = id;

    }

    /**
     * Gets the Id for this instance
     * @return returns server's ID set by constuctor
     */
    protected int getId(){
        return this.id;
    }

    /**
     * Adds tip Amount to this instances tips
     * @param newTip Takes a double to add to servers Tips
     */
    protected void addTip(double newTip){
        if (Math.floor(newTip) >=0) {
            this.tips += newTip;
        }
    }

    /**
     *
     * @return returns this instances tips in a dollar amount format: $36.94.
     */
    protected String getTips(){
        return "$" + String.format("%1.2f", this.tips);
    }

    /**
     * Overrides the two string method
     * @return Returns a description of this instance in the format of: Server #2 ($20.56 in tips)
     */
    @Override
    public String toString() {
        return "Server #" + this.id + " (" + getTips()+" in tips)";
    }
}

