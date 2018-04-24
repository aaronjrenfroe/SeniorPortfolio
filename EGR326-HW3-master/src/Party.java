

/**
 * @author Aaron Renfroe
 * Created by Aaron Renfroe on 1/24/17.
 * EGR 326
 * Assignment 3 Restaurant
 *
 */
public final class Party {

    private final String name;
    private final int size;


    /**
     * The Party class represents a Party that has arrived to the restaurant
     * @param name The name of the Party, It must be unique
     * @param size The size of the party. If larger than the largest table the party will not be seated
     */
    public Party(String name, int size){

            this.name = name.trim();
            this.size = size;
    }
    // Returns parties name

    /**
     *
     * @return
     */
    public String getName(){

        return this.name;
    }
    // Return parties size

    /**
     *
     * @return Returns the party's size set by the constructor
     */
    public int getSize(){
        return this.size;
    }

    /**
     *
     * @return Returns a string representation of the Party(Sherry, Party of 5)
     */
    @Override
    public String toString(){

        return (this.name + ", Party of " + this.getSize());

    }

    /**
     *
     * @return Returns the hashcode.
     */
    @Override
    public int hashCode() {
        int hc = 151;
        hc += 17 * this.name.hashCode();

        return hc;
    }

    /**This may be controversial but I did not include size in the hashcode
     * or the equals method because I never compare to parties for equality regarding size.
     * This allows for faster comparisons in the hash table and at party arrival.
     * @param obj The other object to be compared
     * @return returns true if both parties have same name.
     */
    @Override
    public boolean equals(Object obj) {
        if (obj.getClass() == Party.class){
            Party p = (Party) obj;
            if (p.getName().equals(this.getName())){
                return true;
            }
        }
        return false;
    }
    // checks if name is valid
    private boolean checkName(String n){
        if (n != null && n.trim().length() > 0){
            return true;
        }else return false;
    }
    //checks if size is valid
    private boolean checkSize(int s){
        if (s >=1){
            return true;
        }
        else return false;
    }

}
