/** @author Aaron Renfroe
 * Created by Aaron Renfroe on 1/24/17.
 * EGR 326
 * Assignment 3 Restaurant
 * Class Table
 */
public final class Table implements Comparable{
    private final int size;
    private final int ID;

    /**
     *
     * @param ID A unique ID
     * @param size Number of seats at table
     */
    public Table(int ID, int size ){
        this.size = size;
        this.ID = ID;
    }

    /**
     * Gets the size of the table.
     * @return returns number of seats at table
     */
    protected int getSize(){
        return this.size;
    }

    /**
     * @param o object to compare
     * @return returns true if tables are same state
     */
    public int compareTo(Object o){
        if (o.getClass() == Table.class){
            Table t = (Table) o;
            return t.getSize()-this.size;
        }else{
            throw new IllegalArgumentException("Object passed must be of type Table");
        }
    }

    /**
     * @return Hashcode based on ID and Table Size
     */
    @Override
    public int hashCode(){
        return ((this.size * 31) + (this.ID*17));
    }

    /**
     * @param obj Object
     * @return If Object is Table's class and table are the same Id and Size
     */
    @Override
    public boolean equals(Object obj) {
        return obj.getClass() == Table.class && (obj.hashCode() == this.hashCode());
    }

    /**
     *
     * @return String in the format of "Table 4 (4-top)"
     */
    @Override
    public String toString(){
        return "Table "+this.ID+" (" + this.getSize()+"-top)";
    }
}
